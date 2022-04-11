import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:milky/models/chatroom_model.dart';
import 'package:milky/models/message_model.dart';
import 'package:milky/models/user_model.dart';

class FirebaseController extends GetxController {
  late final FirebaseFirestore _store;
  final String myid = 'XEODdv0veoWU9oZU4D1C';
  final String otherid = 'rrGVbfwxD1x21TeE6XaR';

  FirebaseController() {
    _store = FirebaseFirestore.instance;
  }

  Future<void> changeUserStatus(bool status) async {
    var a = _store.collection('people').doc(myid);
    // var p = await a.get();
    await a.update({
      'is_online': status,
    });
  }

  Stream<List<ChatRoom>> getChatRooms() {
    return _store.collection('chatrooms').where('user_ids', arrayContains: myid).snapshots().map((event) {
      List<ChatRoom> lc = [];
      for (var r in event.docs) {
        lc.add(ChatRoom.fromMap(r.id, r.data()));
      }
      return lc;
    });
  }

  // Future<List<UserModel>> getRoomUsers(ChatRoom cr) async {
  //   var a = await _store.collection('chatrooms').doc(cr.id).get();
  //   List<UserModel> res = [];
  //   for(var p in a.data()!['usersids']) {
  //     UserModel u = await getUserByID(p);
  //     res.add(u);
  //   }
  //   return res;
  // }

  // Future<Message?> getLastMessageByID(ChatRoom cr) async {
  //   if (cr.lastmessageid != null) {
  //     var a = await _store.collection('chatrooms').doc(cr.id).collection('messages').doc(cr.lastmessageid).get();
  //     return Message.fromMap(a.id, a.data()!);
  //   } else {
  //     return null;
  //   }
  // }

  Future<Map<String, dynamic>> getChatRoomInfo(ChatRoom cr) async {
    var a = _store.collection('chatrooms').doc(cr.id);
    Message? lm;
    Map<String, UserModel> lru = {};

    if (cr.lastmessageid != null) {
      var x = await a.collection('messages').doc(cr.lastmessageid).get();
      lm = Message.fromMap(x.id, x.data()!);
    } else {
      lm = null;
    }

    var ab = await a.get();
    if (ab.data()!['purpose'] != 2) {
      for (var u in ab.data()!['user_ids']) {
        var z = await getUserByID(u);
        lru[u] = z;
      }
    } else {
      var z = await getUserByID(ab.data()!['host_id']);
      lru[z.id] = z;
    }

    return {
      'lastmessage': lm,
      'roomusers': lru,
    };
  }

  // Future<Message> getMessageByID(ChatRoom cr, String id) async {
  //   var a = await _store.collection('chatrooms').doc(cr.id).collection('messages').doc(id).get();
  //   return Message.fromMap(a.id, a.data()!);
  // }

  Future<UserModel> getUserByID(String id) async {
    var a = await _store.collection('people').doc(id).get();
    return UserModel.fromMap(id, a.data()!);
  }

  Stream<List<Message>> getRoomMessages(ChatRoom cr) {
    return _store
        .collection('chatrooms')
        .doc(cr.id)
        .collection('messages')
        .orderBy(
          'timestamp',
        )
        .snapshots()
        .map((event) {
      List<Message> lm = [];
      for (var m in event.docs) {
        // var cfk = Message.fromMap(m.id, m.data());
        // cfk.replymap = m.data()['replymessage'] != null ? m.data()['replymessage'] as Map<String, String> : null;
        // lm.add(cfk);
        lm.add(Message.fromMap(m.id, m.data()));
      }
      return lm;
    });
  }

  Future<void> addMessage(ChatRoom cr, Map<String, dynamic> m) async {
    var a = _store.collection('chatrooms').doc(cr.id);
    var b = await a.collection('messages').add({
      'sentbyid': myid,
      'messagetext': m['messagetext'],
      'timestamp': DateTime.now(),
      'senttotoken': m['senttotoken'],
      // 'replytextid': m['replytextid'],
      if(m['replymessage'] != null) 'replymessage': {
        'message': m['replymessage'],
        'authorid': m['replyauthorid'],
      }
      // 'messageimageurl': m['messageimageurl'],
    });
    await a.update({
      'lastmessageid': b.id,
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
      if (u.id != myid) res.add(UserModel.fromMap(u.id, u.data()));
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
        'user_ids': [myid, partner.id],
      },
    );
  }

  Future<bool> checkExistance(UserModel u) async {
    var a = await _store.collection('chatrooms').where('user_ids', isEqualTo: [myid, u.id]).get();
    return a.docs.isNotEmpty;
  }

  Future<void> createGroup() async {
    var a = _store.collection('chatrooms');
    await a.add({});
  }

  Future<void> createChannel() async {
    var a = _store.collection('chatrooms');
    await a.add({});
  }
}
