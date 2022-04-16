import 'package:flutter/material.dart';
import 'package:milky/controllers/chat_room_controller.dart';
import 'package:get/get.dart';

class ChatDetailsScreen extends StatelessWidget {
  const ChatDetailsScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatRoomController roomcont = Get.find<ChatRoomController>();
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(itemBuilder: (context, index) {
        var a = roomcont.thischatroom!.roomusers.values.toList()[index];
        return ListTile(
          title: Text(a.nickname),
          leading: CircleAvatar(backgroundImage: NetworkImage(a.profilepicUrl != null ? a.profilepicUrl! : 'http://assets.stickpng.com/thumbs/585e4beacb11b227491c3399.png'),),
        );
      },
      itemCount: roomcont.thischatroom!.roomusers.length,),
    );
  }
}