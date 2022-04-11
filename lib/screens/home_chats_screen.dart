import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milky/controllers/chat_room_controller.dart';
import 'package:milky/controllers/firebase_controller.dart';
import 'package:milky/models/chatroom_model.dart';
import 'package:milky/models/message_model.dart';
import 'package:milky/screens/chat_screen.dart';
import 'package:milky/screens/create_screen.dart';
import 'package:milky/screens/search_screen.dart';
import 'package:milky/widgets/creation_alert_dialog.dart';

class HomeChatsScreen extends StatefulWidget {
  const HomeChatsScreen({Key? key}) : super(key: key);

  @override
  State<HomeChatsScreen> createState() => _HomeChatsScreenState();
}

class _HomeChatsScreenState extends State<HomeChatsScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setUserStatus(true);
    } else {
      setUserStatus(false);
    }
  }

  void setUserStatus(bool s) async {
    Get.find<FirebaseController>().changeUserStatus(s);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (_) => const OnBoardCreateScreen(),
              //   ),
              // );
              showDialog(context: context, builder: (_) => const CreationAlertDialog());
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder<List<ChatRoom>>(
        stream: Get.find<FirebaseController>().getChatRooms(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          if (snapshot.data!.isEmpty) {
            return const Text('No contacts.');
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              ChatRoom a = snapshot.data![index];
              return FutureBuilder<Map<String, dynamic>>(
                future: Get.find<FirebaseController>().getChatRoomInfo(a),
                builder: (context, rsnapshot) {
                  if (!rsnapshot.hasData) {
                    return const ListTile();
                  }
                  late Message? lm;
                  if (rsnapshot.data!.isNotEmpty) {
                    lm = rsnapshot.data!['lastmessage'];
                    a.roomusers = rsnapshot.data!['roomusers'];
                  }
                  return ListTile(
                    leading: const CircleAvatar(
                      backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSRt110PWYr_eqwfC-rgM7A_ceWC0aIYQvx0Q&usqp=CAU'),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(a.getname()),
                        if (lm != null)
                          Text(
                            DateFormat.Hm().format(lm.timestamp),
                          ),
                      ],
                    ),
                    subtitle: lm != null
                        ? Text(
                            lm.messagetext,
                          )
                        : const Text(''),
                    onTap: () {
                      Get.find<ChatRoomController>().setChatRoom(a);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChatScreen(),
                        ),
                      );
                    },
                  );
                },
              );
            },
            itemCount: snapshot.data!.length,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const SearchScreen(),
            ),
          );
        },
        child: const Icon(Icons.search_rounded),
      ),
    );
  }
}
