import 'package:flutter/material.dart';
import 'package:milky/controllers/chat_room_controller.dart';
import 'package:milky/controllers/firebase_controller.dart';
import 'package:milky/controllers/settings_controller.dart';
import 'package:milky/models/chatroom_model.dart';
import 'package:milky/models/color_schemes.dart';
import 'package:milky/models/message_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class MessageBubble extends StatelessWidget {
  final Message thismessage;
  const MessageBubble({
    Key? key,
    required this.thismessage,
  }) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Provider.of<ThemeProvider>(context, listen: false).isDarkmode ? MyThemes.darkTheme : MyThemes.lightTheme;
    final roomcont = Get.find<ChatRoomController>();
    final rad = Get.find<SettingsController>().getRadius();
    final size = Get.find<SettingsController>().getSize();
    return Align(
      // padding: const EdgeInsets.all(8.0),
      alignment: thismessage.sentByMe() ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPressEnd: (_) {
          Clipboard.setData(
            ClipboardData(text: thismessage.messagetext),
          );
        },
        child: Container(
          // alignment: thismessage.sentbyid == Get.find<FirebaseController>().myid ? Alignment.centerRight : Alignment.centerLeft,
          constraints: BoxConstraints(
            maxWidth: thismessage.messageimageurl != null ? MediaQuery.of(context).size.width * 0.6 : MediaQuery.of(context).size.width * 0.85,
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: thismessage.sentByMe() ? Radius.circular(rad!) : const Radius.circular(0),
                  topRight: thismessage.sentByMe() ? const Radius.circular(0) : Radius.circular(rad!),
                  bottomLeft: Radius.circular(rad!),
                  bottomRight: Radius.circular(rad)),
              color: thismessage.sentByMe() ? theme.colorScheme.secondary : theme.colorScheme.tertiary),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (roomcont.thischatroom!.purpose != RoomPurpose.chat)
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Text(
                    thismessage.sentbyid == Get.find<FirebaseController>().currentUser!.id ? 'You' : roomcont.thischatroom!.roomusers[thismessage.sentbyid]!.nickname,
                    style: TextStyle(fontSize: size! - 1, fontWeight: FontWeight.bold),
                  ),
                ),
              if (thismessage.replymap != null)
                IntrinsicWidth(
                  child: Container(
                    constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width * 0.2),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                      color: Color.fromARGB(150, 38, 124, 194),
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          // const SizedBox(width: 3),
                          Container(
                            width: 5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: const Color.fromARGB(255, 88, 255, 94),
                            ),
                            // height: 35,
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  roomcont.thischatroom!.purpose != RoomPurpose.chat ? Text(
                                    roomcont.thischatroom!.roomusers[thismessage.replymap!['authorid']]!.nickname,
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: size! - 2),
                                  ) : const SizedBox(),
                                  Text(
                                    thismessage.replymap!['message']!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(fontSize: size! - 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4, top: 3),
                child: Text(
                  thismessage.messagetext,
                  style: TextStyle(fontSize: size),
                ),
              ),
              Text(
                DateFormat.Hm().format(thismessage.timestamp),
                style: TextStyle(fontSize: size! - 3),
              )
            ],
          ),
        ),
      ),
    );
  }
}
