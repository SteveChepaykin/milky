import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milky/controllers/chat_room_controller.dart';
import 'package:milky/controllers/firebase_controller.dart';
import 'package:milky/models/chatroom_model.dart';
import 'package:milky/models/message_model.dart';
import 'package:milky/screens/chat_details_screen.dart';
import 'package:milky/widgets/message_bubble.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:milky/widgets/message_input_field.dart';
import 'package:swipe_to/swipe_to.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messagecont = TextEditingController();
  // Message? replymessage;

  @override
  Widget build(BuildContext context) {
    var roomcont = Get.find<ChatRoomController>();
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Text(roomcont.thischatroom!.id),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ChatDetailsScreen(),
              ),
            );
          },
        ),
      ),
      body: Column(
        children: [
          StreamBuilder<List<Message>>(
            stream: Get.find<FirebaseController>().getRoomMessages(roomcont.thischatroom!),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }
              if (snapshot.data!.isEmpty) {
                return const Expanded(child: Center(child: Text('No messages.')));
              }
              return Expanded(
                child: GroupedListView<Message, DateTime>(
                  elements: snapshot.data!,
                  groupBy: (m) => DateTime(
                    m.timestamp.year,
                    m.timestamp.month,
                    m.timestamp.day,
                  ),
                  reverse: true,
                  order: GroupedListOrder.DESC,
                  useStickyGroupSeparators: true,
                  floatingHeader: true,
                  groupHeaderBuilder: (message) => SizedBox(
                    height: 40,
                    child: Center(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            DateFormat.yMMMd().format(message.timestamp),
                          ),
                        ),
                      ),
                    ),
                  ),
                  itemBuilder: (context, message) {
                    return SwipeTo(
                      child: MessageBubble(
                        key: ValueKey(message.id),
                        thismessage: message,
                      ),
                      onRightSwipe: () {
                        roomcont.replymessage = message;
                        roomcont.replying$.value = true;
                      },
                    );
                  },
                ),
              );
            },
          ),
          roomcont.thischatroom!.purpose == RoomPurpose.channel && roomcont.thischatroom!.hostid != Get.find<FirebaseController>().currentUser!.id
              ? Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    height: 40,
                    width: double.infinity,
                    child: const Center(child: Text('you cant send messages here.')),
                    color: Colors.grey,
                  ),
                )
              : const MessageInputField(),
        ],
      ),
    );
  }
}
