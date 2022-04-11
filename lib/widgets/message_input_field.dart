import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milky/controllers/chat_room_controller.dart';

class MessageInputField extends StatefulWidget {
  const MessageInputField({
    Key? key,
  }) : super(key: key);

  @override
  State<MessageInputField> createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends State<MessageInputField> {
  final roomcont = Get.find<ChatRoomController>();
  final TextEditingController messagecont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.grey),
              child: Obx(() =>
                Column(
                  children: [
                    if (roomcont.replying$.value)
                      Padding(
                        padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
                        child: Container(
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(width: 6),
                              Container(
                                color: Colors.green,
                                width: 5,
                                height: 40,
                              ),
                              const SizedBox(width: 3),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      roomcont.replymessage!.messagetext,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  roomcont.clear();
                                  setState(() {});
                                },
                                icon: const Icon(Icons.close),
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    TextField(
                      controller: messagecont,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 19, horizontal: 10),
                        hintText: 'type here...',
                        border: InputBorder.none,
                      ),
                      minLines: 1,
                      maxLines: 4,
                      onChanged: (t) {
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          if (messagecont.text.isEmpty)
            FloatingActionButton(
              heroTag: '1',
              onPressed: () {},
              // mini: true,
              child: const Icon(Icons.camera),
              elevation: 0,
            ),
          const SizedBox(
            width: 10,
          ),
          FloatingActionButton(
            heroTag: '2',
            onPressed: () async {
              await roomcont.addMessage(
                {
                  'messagetext': messagecont.text,
                  'senttotoken': 'NOTOKEN1',
                  'replymessage': roomcont.replymessage != null ? roomcont.replymessage!.messagetext : null,
                  // 'replymessage': roomcont.replymessage ?? null
                  'replyauthorid': roomcont.replymessage != null ? roomcont.replymessage!.sentbyid : null,
                },
              );
              messagecont.clear();
              roomcont.clear();
              setState(() {});
            },
            // mini: true,
            child: const Icon(Icons.send),
            elevation: 0,
          ),
        ],
      ),
    );
  }

  // Widget buildReply(BuildContext context) => IntrinsicHeight(
  //       child: Row(
  //         children: [
  //           Container(
  //             color: Colors.green,
  //             width: 4,
  //           ),
  //           const SizedBox(width: 8),
  //           Expanded(child: buildReplyMessage()),
  //         ],
  //       ),
  //     );
}
