import 'package:get/get.dart';
import 'package:milky/controllers/firebase_controller.dart';
import 'package:milky/models/chatroom_model.dart';
import 'package:milky/models/message_model.dart';

class ChatRoomController extends GetxController {
  ChatRoom? thischatroom;
  Message? replymessage;
  String? messageimageurl;
  // bool isreplying = false;
  RxBool replying$ = false.obs;

  // ChatRoomController(this.thischatroom) {
  //   // replying$ = isreplying.obs;
  // }

  void clear() {
    replymessage = null;
    messageimageurl = null;
    // isreplying = false;
    replying$.value = false;
  }

  void setChatRoom(ChatRoom a) {
    thischatroom = a;
  }

  Future<void> addMessage(Map<String, dynamic> map) async {
    await Get.find<FirebaseController>().addMessage(thischatroom!, map);
  }

  // Future<Message> getMessage(String id) async {
  //   return await Get.find<FirebaseController>().getMessageByID(thischatroom!, id);
  // }
}