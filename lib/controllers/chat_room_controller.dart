import 'dart:typed_data';

import 'package:get/get.dart';
// import 'package:http/http.dart';
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
  Message? selectedMessage;
  Rx<Message?> editedMessage$ = (null as Message?).obs;
  // bool isreplying = false;
  RxBool replying$ = false.obs;
  RxBool hasImage$ = false.obs;
  RxBool messageSelected$ = false.obs;

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

  void setEditedMessage(Message m) {
    editedMessage$.value = m;
    editedMessage$.refresh();
  }

  void deselectMessage() {
    selectedMessage = null;
    messageSelected$.value = false; 
  }

  Future<void> addMessage(Map<String, dynamic> map) async {
    await Get.find<FirebaseController>().addMessage(thischatroom!, map);
  }

  Future<void> deactivateMessage(Message m) async {
    await Get.find<FirebaseController>().deactivateMessage(thischatroom!, m);
  }

  Future<void> updateMessage(String newText) async {
    await Get.find<FirebaseController>().editMessage(thischatroom!, editedMessage$.value!, newText);
  }

  // Future<Message> getMessage(String id) async {
  //   return await Get.find<FirebaseController>().getMessageByID(thischatroom!, id);
  // }
}