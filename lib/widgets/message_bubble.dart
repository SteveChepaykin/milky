import 'package:flutter/material.dart';
import 'package:milky/controllers/chat_room_controller.dart';
import 'package:milky/models/message_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final Message thismessage;
  const MessageBubble({
    Key? key,
    required this.thismessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final roomcont = Get.find<ChatRoomController>();
    return Align(
      // padding: const EdgeInsets.all(8.0),
      alignment: thismessage.sentByMe() ? Alignment.centerRight : Alignment.centerLeft,
      child: InkWell(
        onLongPress: () {
          //TODO: copies to clipboard
        },
        child: Container(
          // alignment: thismessage.sentbyid == Get.find<FirebaseController>().myid ? Alignment.centerRight : Alignment.centerLeft,
          constraints: BoxConstraints(
            maxWidth: thismessage.messageimageurl != null ? MediaQuery.of(context).size.width * 0.6 : MediaQuery.of(context).size.width * 0.85,
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: thismessage.sentByMe() ? const Radius.circular(12) : const Radius.circular(0),
                  topRight: thismessage.sentByMe() ? const Radius.circular(0) : const Radius.circular(12),
                  bottomLeft: const Radius.circular(12),
                  bottomRight: const Radius.circular(12)),
              color: const Color.fromARGB(255, 54, 159, 245)),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (thismessage.replymap != null)
                IntrinsicWidth(
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                      color: Color.fromARGB(150, 38, 124, 194),
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
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
                              child: Text(
                                thismessage.replymap!['message']!,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  thismessage.messagetext,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              Text(
                DateFormat.Hm().format(thismessage.timestamp),
                style: const TextStyle(fontSize: 13),
              )
            ],
          ),
        ),
      ),
    );
  }
}
