// import 'package:milky/models/message_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:milky/controllers/firebase_controller.dart';
import 'package:milky/models/message_model.dart';
import 'package:milky/models/user_model.dart';
import 'package:get/get.dart';

class ChatRoom {
  final String id;
  late final List<String> usersids;
  late final RoomPurpose purpose;
  late final String? hostid;
  late final String? name;
  late final String? roomphoto;
  late final DateTime? timeCreated;
  // late DateTime? lastmessageTS;
  // late String? lastmessagesenderID;
  // late String? lastmessage;
  late String? lastmessageid;
  Message? lastmessage;
  final Map<String, UserModel> _roomusers = {};

  Map<String, UserModel> get roomusers => _roomusers;

  set roomusers (Map<String, UserModel> val) {
    _roomusers.clear();
    _roomusers.addAll(val);
  }

  ChatRoom.fromMap(this.id, Map<String, dynamic> map,) {
    // purpose = map['purpose'] != null ? prps((map['purpose'] as double).round()) : throw 'NEED PURPOSE IN CHAT $id';
    if(map['purpose'] != null) {
      if(map['purpose'].runtimeType == int) {
        purpose = prps(map['purpose'] as int);
      } 
      else {
        purpose = prps((map['purpose'] as double).round());
      }
    } else {
      throw 'NEED PURPOSE IN CHAT $id';
    }
    usersids = map['user_ids'] != null ? (map['user_ids'] as List<dynamic>).map((e) => e.toString()).toList() : throw 'NEED USERS IN CHAT $id';
    hostid = map['host_id'] != null ? map['host_id'] as String : null;
    roomphoto  = map['roomphoto'] != null ? map['roomphoto'] as String : null;
    name = map['name'] != null ? map['name'] as String : null;
    lastmessageid = map['lastmessageid'] != null ? map['lastmessageid'] as String : null;
    timeCreated = map['timecreated'] != null ? DateTime.fromMicrosecondsSinceEpoch((map['timecreated'] as Timestamp).millisecondsSinceEpoch) : null; 
    // lastmessage = lm;
  }

  // Message getLastMessage(String id) async {
  //   return 
  // }

  Future<void> init() async {
    var m = await Get.find<FirebaseController>().getChatRoomInfo(this);
    lastmessage = m['lastmessage'];
    roomusers = m['roomusers'];
  }

  String getname() {
    if(purpose == RoomPurpose.chat) {
      Map<String, UserModel> other = roomusers;
      other.removeWhere((key, value) => key == Get.find<FirebaseController>().currentUser!.id);
      // roomusers.addAll();
      return other.values.toList()[0].nickname;
    } else {
      return name!;
    }
  }

  RoomPurpose prps(int i) {
    switch (i) {
      case 0:
        return RoomPurpose.chat;
      case 1:
        return RoomPurpose.group;
      case 2:
        return RoomPurpose.channel;
      default:
        return RoomPurpose.chat;
    }
  }

  // UserModel? getOtherPerson() {
  //   return roomusers.values.where((element) => element.id != Get.find<FirebaseController>().currentUser!.id).toList()[0];
  // }

  List<String> getOthersTokens() {
    return roomusers.values.where((element) => element.id != Get.find<FirebaseController>().currentUser!.id).map((e) => e.cloudtoken).toList();
  }

  // Future<void> addMessage(Map<String, dynamic> map) async {
  //   await Get.find<FirebaseController>().addMessage(this, map);
  // }
}

enum RoomPurpose {
  chat,
  group,
  channel,
}
