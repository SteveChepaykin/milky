import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:milky/controllers/crypt_controller.dart';
import 'package:milky/models/chatroom_model.dart';
import 'package:milky/models/message_model.dart';
import 'package:milky/models/user_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseController extends GetxController {
  late final FirebaseFirestore _store;
  late final FirebaseMessaging _messaging;
  late final FirebaseStorage _storage;
  // final String myid = 'XEODdv0veoWU9oZU4D1C';
  // final String otherid = 'rrGVbfwxD1x21TeE6XaR';
  UserModel? currentUser;
  late Rx<UserModel?> currentUser$;

  FirebaseController() {
    _store = FirebaseFirestore.instance;
    _messaging = FirebaseMessaging.instance;
    _storage = FirebaseStorage.instance;
    currentUser$ = currentUser.obs;
  }

  FirebaseStorage get storage => _storage;

  Future<void> changeUserStatus(bool status) async {
    var a = _store.collection('people').doc(currentUser!.id);
    // var p = await a.get();
    await a.update({
      'is_online': status,
    });
  }

  Stream<List<ChatRoom>> getChatRooms() {
    return _store.collection('chatrooms').where('user_ids', arrayContains: currentUser!.id).snapshots().asyncMap((event) async {
      List<ChatRoom> lc = [];
      for (var r in event.docs) {
        var cr = ChatRoom.fromMap(r.id, r.data());
        var info = await getChatRoomInfo(cr);
        cr.lastmessage = info['lastmessage'];
        cr.roomusers = info['roomusers'];
        lc.add(cr);
        await cr.init();
      }
      return lc;
    });
  }

  Future<Map<String, dynamic>> getChatRoomInfo(ChatRoom cr) async {
    var a = _store.collection('chatrooms').doc(cr.id);
    Message? lm;
    // Map<String, UserModel> lru = {};

    if (cr.lastmessageid != null) {
      var x = await a.collection('messages').doc(cr.lastmessageid).get();
      lm = Message.fromMap(x.id, x.data()!);
    } else {
      lm = null;
    }

    Map<String, UserModel> lru = {};

    if (cr.purpose != RoomPurpose.channel) {
      for (var u in cr.usersids) {
        var z = await getUserByID(u);
        lru[z.id] = z;
      }
    } else {
      var z = await getUserByID(cr.hostid!);
      lru[z.id] = z;
    }

    return {
      'lastmessage': lm,
      'roomusers': lru,
    };
  }

  Future<Message> getMessageByID(ChatRoom cr, String id) async {
    var a = await _store.collection('chatrooms').doc(cr.id).collection('messages').doc(id).get();
    return Message.fromMap(a.id, a.data()!);
  }

  Future<UserModel> getUserByID(String id) async {
    var a = await _store.collection('people').doc(id).get();
    return UserModel.fromMap(id, a.data()!);
  }

  Future<UserModel> getUserByEmail(String email) async {
    var a = await _store.collection('people').where('email', isEqualTo: email).limit(1).get();
    return UserModel.fromMap(a.docs[0].id, a.docs[0].data());
  }

  Future<String?> initToken() async {
    return await _messaging.getToken();
  }

  Stream<List<Message>> getRoomMessages(ChatRoom cr) {
    return _store
        .collection('chatrooms')
        .doc(cr.id)
        .collection('messages')
        // .orderBy(
        //   'timestamp',
        //   // descending: true,
        // )
        .snapshots()
        .map((event) {
      List<Message> lm = [];
      for (var m in event.docs) {
        // var cfk = Message.fromMap(m.id, m.data());
        // cfk.replymap = m.data()['replymessage'] != null ? m.data()['replymessage'] as Map<String, String> : null;
        // lm.add(cfk);
        var mes = Message.fromMap(m.id, m.data());
        mes.loadImage();
        // lm.add(Message.fromMap(m.id, m.data()));
        lm.add(mes);
      }
      lm.sort((m1, m2) {
        return m1.timestamp.compareTo(m2.timestamp);
      });
      return lm;
    });
  }

  Future<void> addMessage(ChatRoom cr, Map<String, dynamic> m) async {
    var a = _store.collection('chatrooms').doc(cr.id);
    // http.Response response = await http.get(Uri.parse("http://worldtimeapi.org/api/timezone/Europe/London"));
    // var file = jsonDecode(response.body);
    var b = await a.collection('messages').add({
      'sentbyid': currentUser!.id,
      'messagetext': m['messagetext'] != null ? Crypter.encryptAES(m['messagetext']) : null,
      'timestamp': DateTime.now(),
      // 'timestamp': DateTime.parse(file['utc_datetime']),
      'senttotoken': m['senttotokens'],
      'active': true,
      if (m['replymessage'] != null)
        'replymessage': {
          'message': Crypter.encryptAES(m['replymessage']),
          'authorid': m['replyauthorid'],
          'image': m['replyimageurl'],
        },
      'messageimageurl': m['messageimageurl'],
    });
    await a.update({
      'lastmessageid': b.id,
    });
  }

  Future<Uint8List?> getMessageImage(Message m) async {
    Uint8List? ref;
    try {
      ref = await _storage.ref(m.name).getData();
    } catch (e) {
      return null;
    } 
    return ref;
  }

  Future<void> deactivateMessage(ChatRoom cr, Message m) async {
    var a = _store.collection('chatrooms').doc(cr.id).collection('messages').doc(m.id);
    a.update({
      'active': false,
    });
  }

  Future<void> editMessage(ChatRoom cr, Message m, String newtext) async {
    var a = _store.collection('chatrooms').doc(cr.id).collection('messages').doc(m.id);
    a.update({
      'messagetext': Crypter.encryptAES(newtext),
    });
  }

  Future<List<ChatRoom>> findRoomsByName(String query, int purp) async {
    if (query.isEmpty) return [];
    var a = await _store.collection('chatrooms').orderBy('name').startAt([query]).endAt([query + '\uf8ff']).where('purpose', isEqualTo: purp).get();
    List<ChatRoom> res = [];
    for (var cr in a.docs) {
      var c = ChatRoom.fromMap(cr.id, cr.data());
      var cri = await getChatRoomInfo(c);
      c.lastmessage = cri['lastmessage'];
      c.roomusers = cri['roomusers'];
      res.add(c);
    }
    return res;
  }

  Future<List<UserModel>> findUsersByName(String query) async {
    if (query.isEmpty || (query.startsWith('@') && query.length == 1)) return [];
    var a = await _store.collection('people').orderBy(query.startsWith('@') ? 'identifier' : 'nickname').startAt([query]).endAt([query + '\uf8ff']).get();
    List<UserModel> res = [];
    for (var u in a.docs) {
      if (u.id != currentUser!.id) res.add(UserModel.fromMap(u.id, u.data()));
    }
    return res;
  }

  Future<List<UserModel>> findYourUsers() async {
    // if (query.isEmpty || (query.startsWith('@') && query.length == 1)) return [];
    var a = await _store.collection('chatrooms').where('purpose', isEqualTo: 0).where('user_ids', arrayContains: currentUser!.id).get();
    List<UserModel> res = [];
    for (var u in a.docs) {
      var otherID = (u['user_ids'] as List<dynamic>).map((e) => e.toString()).firstWhere((element) => element != currentUser!.id);
      var otheruser = await getUserByID(otherID);
      res.add(otheruser);
    }
    return res;
  }

  // Future<UserModel> getUserByID(String id) async {
  //   var a = await _store.collection('people').doc(id).get();
  //   return UserModel.fromMap(a.id, a.data()!);
  // }

  Future<void> getOrMakeChatRoom(UserModel partner) async {
    var a = _store.collection('chatrooms');
    await a.add(
      {
        'purpose': 0,
        'lastmessageid': null,
        'user_ids': [currentUser!.id, partner.id],
        'timecreated': DateTime.now(),
      },
    );
  }

  Future<bool> checkExistance(UserModel u) async {
    var a = await _store.collection('chatrooms').where('user_ids', isEqualTo: [currentUser!.id, u.id]).where('purpose', isEqualTo: 0).get();
    return a.docs.isNotEmpty;
  }

  Future<void> createGroup(String name, List<UserModel> users) async {
    var a = _store.collection('chatrooms');
    if (users.isNotEmpty) {
      await a.add({
        'host_id': currentUser!.id,
        'lastmessageid': null,
        'name': name,
        'purpose': 1,
        'user_ids': [
          ...users.map((e) => e.id).toList(),
          currentUser!.id,
        ],
        'roomphoto': null,
        'timecreated': DateTime.now(),
      });
    }
  }

  Future<void> createChannel(String name) async {
    var a = _store.collection('chatrooms');
    await a.add({
      'host_id': currentUser!.id,
      'lastmessageid': null,
      'name': name,
      'purpose': 2,
      'user_ids': [
        currentUser!.id,
      ],
      'roomphoto': null,
      'timecreated': DateTime.now(),
    });
  }

  Future<void> adduser(Map<String, dynamic> m) async {
    var q = await _store.collection('people').add({
      'cloud_token': await initToken(),
      'is_online': true,
      'email': m['email']!,
      'identifier': m['identifier']!,
      'nickname': m['nickname']!,
      'picture_url': m['picture_url'],
    });
    var z = await q.get();
    var u = UserModel.fromMap(z.id, z.data()!);
    setCurrentUser(u);
  }

  Future<void> joinChannel(ChatRoom room) async {
    var a = _store.collection('chatrooms').doc(room.id);
    var b = (await a.get()).data()!['user_ids'];
    await a.update({
      'user_ids': [
        ...(b),
        currentUser!.id,
      ]
    });
  }

  Future<String?> registerUser(Map<String, String?> m) async {
    var a = await _store.collection('people').where('email', isEqualTo: m['email']).get();
    if (a.docs.isNotEmpty) {
      return 'This user already exists in app';
    }
    await adduser({
      'email': m['email'],
      'identifier': m['identifier'],
      'nickname': m['nickname'],
      'picture_url': m['image_url'],
    });
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: m['email']!, password: m['password']!);
    } on FirebaseAuthException catch (e) {
      return 'ERROR: ${e.message!}';
    }
    return null;
  }

  Future<String?> signInUser(Map<String, String> m) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: m['email']!, password: m['password']!);
    } on FirebaseAuthException catch (_) {
      return 'loginerror';
    }
    var a = await _store.collection('people').where('email', isEqualTo: m['email']!).limit(1).get();
    var u = UserModel.fromMap(a.docs[0].id, a.docs[0].data());
    setCurrentUser(u);
    return null;
  }

  Future<String?> signInUserGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;
    var a = await _store.collection('people').where('email', isEqualTo: googleUser.email).limit(1).get();
    if (a.docs.isEmpty) {
      return '##' + googleUser.email;
    }
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (_) {
      return 'logingoogleerror';
    }
    var u = UserModel.fromMap(a.docs[0].id, a.docs[0].data());
    setCurrentUser(u);
    return null;
  }

  Future<void> signOutUser() async {
    await FirebaseAuth.instance.signOut();
  }

  void setCurrentUser(UserModel? user) {
    currentUser = user;
    currentUser$.value = user;
  }

  void listenUserAuthState() {
    FirebaseAuth.instance.authStateChanges().listen(onUserAuthStateChange);
  }

  Future<void> onUserAuthStateChange(User? user) async {
    if (user != null) {
      var u = await getUserByEmail(user.email!);
      setCurrentUser(u);
    } else {
      setCurrentUser(null);
    }
  }

  Stream<String> getUserStatus(UserModel user) {
    return _store
      .collection('people')
      .doc(user.id)
      .snapshots()
      .map((event) => event['is_online'] ? 'online' : 'last seen recently');
  }
}
