import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milky/controllers/chat_room_controller.dart';
import 'package:milky/controllers/firebase_controller.dart';
// import 'package:milky/controllers/settings_controller.dart';
import 'package:milky/models/chatroom_model.dart';
import 'package:milky/screens/chat_screen.dart';
import 'package:milky/screens/search_screen.dart';
import 'package:milky/widgets/creation_alert_dialog.dart';
import 'package:milky/widgets/user_locker.dart';

class HomeChatsScreen extends StatefulWidget {
  const HomeChatsScreen({Key? key}) : super(key: key);

  @override
  State<HomeChatsScreen> createState() => _HomeChatsScreenState();
}

class _HomeChatsScreenState extends State<HomeChatsScreen> with WidgetsBindingObserver {
  // late final colmap;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
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
      drawer: const UserLocker(),
      appBar: AppBar(
        title: const Text('Milky'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(context: context, builder: (_) => const CreationAlertDialog());
            },
            icon: const Icon(Icons.add),
          ),
          // IconButton(
          //     onPressed: () async {
          //       await Get.find<FirebaseController>().signOutUser();
          //     },
          //     icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: StreamBuilder<List<ChatRoom>>(
        stream: Get.find<FirebaseController>().getChatRooms(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.isEmpty) {
            return const Center(child: Text('No contacts. \n Find some!'));
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              // List<ChatRoom> sorted = snapshot.data!.where((element) => element.lastmessage != null).toList()..sort((a, b) {
              //   return b.lastmessage!.timestamp.compareTo(a.lastmessage!.timestamp);
              // });
              List<ChatRoom> sorted = snapshot.data!.where((element) => element.lastmessage == null).toList();
              sorted.addAll(
                snapshot.data!.where((element) => element.lastmessage != null).toList()
                  ..sort(
                    (a, b) {
                      return b.lastmessage!.timestamp.compareTo(a.lastmessage!.timestamp);
                    },
                  ),
              );
              ChatRoom a = sorted[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    a.roomphoto != null ? a.roomphoto! : 'http://assets.stickpng.com/thumbs/585e4beacb11b227491c3399.png',
                    scale: 1,
                  ),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(a.getname()),
                    if (a.lastmessage != null)
                      Text(
                        a.lastmessage!.timestamp.day == DateTime.now().day
                            ? 'today, ${DateFormat.Hm().format(a.lastmessage!.timestamp)}'
                            : DateFormat('MMM d, hh:mm').format(a.lastmessage!.timestamp),
                      ),
                  ],
                ),
                subtitle: a.lastmessage != null
                    ? Text(
                        a.lastmessage!.messagetext != null ? a.lastmessage!.messagetext! : 'photo',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    : const Text(''),
                onTap: () {
                  Get.find<ChatRoomController>().setChatRoom(a);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChatScreen(),
                    ),
                  ).whenComplete(() {
                    setState(() {
                      Get.find<ChatRoomController>().clear();
                    });
                  });
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
