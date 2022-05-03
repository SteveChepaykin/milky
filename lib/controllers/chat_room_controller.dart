import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:milky/controllers/firebase_controller.dart';
import 'package:milky/models/chatroom_model.dart';
import 'package:milky/models/message_model.dart';

class ChatRoomController extends GetxController {
  ChatRoom? _thischatroom;
  Message? replymessage;
  // String? messageimageurl;
  XFile? imagefile;
  Uint8List? imagedata;
  // bool isreplying = false;
  RxBool replying$ = false.obs;
  RxBool hasImage$ = false.obs;

  // ChatRoomController(this.thischatroom) {
  //   // replying$ = isreplying.obs;
  // }

  ChatRoom? get thischatroom => _thischatroom;

  void clear() {
    replymessage = null;
    imagefile = null;
    imagedata = null;
    replying$.value = false;
    hasImage$.value = false;
  }

  void clearImage() {
    imagefile = null;
    imagedata = null;
    hasImage$.value = false;
  }

  void clearReply() {
    replymessage = null;
    replying$.value = false;
  }

  void setChatRoom(ChatRoom a) {
    _thischatroom = a;
  }

  Future<void> addMessage(Map<String, dynamic> map) async {
    await Get.find<FirebaseController>().addMessage(thischatroom!, map);
  }

  // Future<Message> getMessage(String id) async {
  //   return await Get.find<FirebaseController>().getMessageByID(thischatroom!, id);
  // }
}