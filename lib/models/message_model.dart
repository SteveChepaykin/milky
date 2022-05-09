import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:milky/controllers/crypt_controller.dart';
import 'package:milky/controllers/firebase_controller.dart';

class Message {
  final String id;
  late final String? messagetext;
  late final DateTime timestamp;
  late final String sentbyid;
  late final List<String?>? senttotoken;
  late final String? messageimageurl;
  late final bool? active;
  Map<String, dynamic>? replymap;
  // late final bool isread;

  Message.fromMap(this.id, Map<String, dynamic> map) {
    messagetext = map['messagetext'] != null ? Crypter.decryptAES(map['messagetext'] as String) : null;
    timestamp =
        map['timestamp'] != null ? DateTime.fromMillisecondsSinceEpoch((map['timestamp'] as Timestamp).millisecondsSinceEpoch) : throw 'NEED DATETIME IN $id';
    sentbyid = map['sentbyid'] != null ? map['sentbyid'] as String : throw 'NEED SENDER IN $id';
    senttotoken = map['senttotoken'] != null
        ? map['senttotoken'].runtimeType == String
            ? [map['senttotoken'] as String]
            : (map['senttotoken'] as List<dynamic>).map((e) => e.toString()).toList()
        : null;
    // replytextid = map['replytextid'] != null ? map['replytextid'] as String : null;
    replymap = map['replymessage'] != null
        ? {
            'message': Crypter.decryptAES((map['replymessage'] as Map<String, dynamic>)['message'] as String),
            'authorid': (map['replymessage'] as Map<String, dynamic>)['authorid'] as String,
          }
        : null;
    // var a = map['replymessage'] != null ? map['replymessage'] : null;
    messageimageurl = map['messageimageurl'] != null ? map['messageimageurl'] as String : null;
    active = map['active'] != null ? map['active'] as bool : null;
    // isread = map['isread'] != null ? map['isread'] as bool : throw 'NEED STATUS IN $id';
  }

  bool sentByMe() {
    return sentbyid == Get.find<FirebaseController>().currentUser!.id;
  }
}
