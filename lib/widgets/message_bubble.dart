import 'package:flutter/material.dart';
import 'package:milky/controllers/chat_room_controller.dart';
import 'package:milky/controllers/crypt_controller.dart';
import 'package:milky/controllers/settings_controller.dart';
import 'package:milky/models/message_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class MessageBubble extends StatelessWidget {
  final Message thismessage;
  const MessageBubble({
    Key? key,
    required this.thismessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final roomcont = Get.find<ChatRoomController>();
    final rad = Get.find<SettingsController>().getRadius();
    final size = Get.find<SettingsController>().getSize();
    return Align(
      // padding: const EdgeInsets.all(8.0),
      alignment: thismessage.sentByMe() ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPressEnd: (_) {
          Clipboard.setData(
            ClipboardData(text: Crypter.decryptAES(thismessage.messagetext),),
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
              color: const Color.fromARGB(255, 54, 159, 245)),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                                  Text(
                                    roomcont.thischatroom!.roomusers[thismessage.replymap!['authorid']]!.nickname,
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: size! - 2),
                                  ),
                                  Text(
                                    Crypter.decryptAES(thismessage.replymap!['message']!),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(fontSize: size - 2),
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
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  Crypter.decryptAES(thismessage.messagetext),
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
