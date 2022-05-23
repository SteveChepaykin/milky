import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:milky/controllers/crypt_controller.dart';
import 'package:milky/controllers/firebase_controller.dart';
import 'package:path_provider/path_provider.dart';

class Message {
  final String id;
  late final String? messagetext;
  late final DateTime timestamp;
  late final String sentbyid;
  late final List<String?>? senttotoken;
  late final String? messageimageurl;
  late final bool? active;
  Uint8List? imagebytes;
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

    // loadImage();
    // isread = map['isread'] != null ? map['isread'] as bool : throw 'NEED STATUS IN $id';
  }

  String get name =>
      messageimageurl!.split('?').first.toString().split('/').where((element) => element.endsWith('.jpg') || element.endsWith('.png')).toList().first;

  bool sentByMe() {
    return sentbyid == Get.find<FirebaseController>().currentUser!.id;
  }

  // Future<bool> imageDownloaded() async {
  //   final appStorage = await getApplicationDocumentsDirectory();
  //   final image = File('${appStorage.path}/$name');
  //   if (image.existsSync()) {
  //     imagebytes = await image.readAsBytes();
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  Future<void> loadImage() async {
    final bytes = await Get.find<FirebaseController>().getMessageImage(this);
    if (bytes != null) {
      final appStorage = await getApplicationDocumentsDirectory();
      final image = File('${appStorage.path}/$name');
      if (!image.existsSync()) {
        image.writeAsBytes(bytes);
      }
      imagebytes = await image.readAsBytes();
    } else {
      imagebytes = null;
    }
  }

  // Future<bool> imageDownloaded() async {
  //   // String name =
  //   //     messageimageurl!.split('?').first.toString().split('/').where((element) => element.endsWith('.jpg') || element.endsWith('.png')).toList().first;
  //   final appStorage = await getApplicationDocumentsDirectory();
  //   final image = File('${appStorage.path}/$name');
  //   return image.existsSync();
  // }

  // void loadImage() async {
  //   // String name =
  //   //     messageimageurl!.split('?').first.toString().split('/').where((element) => element.endsWith('.jpg') || element.endsWith('.png')).toList().first;
  //   final bytes = await Get.find<FirebaseController>().getMessageImage(this);
  //   final appStorage = await getApplicationDocumentsDirectory();
  //   final image = File('${appStorage.path}/$name');
  //   if (bytes != null) {
  //     if (!image.existsSync()) {
  //       image.writeAsBytes(bytes);
  //     }
  //   }
  //   imagebytes = await image.readAsBytes();
  // }
}
