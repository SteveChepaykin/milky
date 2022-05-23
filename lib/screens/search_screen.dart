import 'package:flutter/material.dart';
import 'package:milky/controllers/chat_room_controller.dart';
import 'package:milky/controllers/firebase_controller.dart';
import 'package:milky/models/chatroom_model.dart';
import 'package:get/get.dart';
import 'package:milky/models/user_model.dart';
import 'package:milky/screens/chat_screen.dart';
import 'package:intl/intl.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ScrollController peoplecont = ScrollController();
  final ScrollController channelscont = ScrollController();
  final ScrollController userscont = ScrollController();
  final TextEditingController searchcont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                // decoration: BoxDecoration(
                //   border: const Border(
                //     bottom: BorderSide(width: 2),
                //     left: BorderSide(width: 2),
                //     right: BorderSide(width: 2),
                //     top: BorderSide(width: 2),
                //   ),
                //   borderRadius: BorderRadius.circular(12),
                // ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: searchcont,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    onChanged: (text) {
                      setState(() {});
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),
              userslistviewunit(userscont, searchcont.text, 'users'),
              const SizedBox(height: 30),
              listviewunit(channelscont, searchcont.text, 2, 'channels'),
              const SizedBox(height: 30),
              listviewunit(peoplecont, searchcont.text, 0, 'your chats'),
            ],
          ),
        ),
      ),
    );
  }

  Widget listviewunit(ScrollController cont, String q, int p, String title) {
    return Column(
      children: [
        Text(title),
        FutureBuilder<List<ChatRoom>>(
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Text('HASNT DATA');
            }
            if (snapshot.data!.isEmpty) {
              return const Text('no matches');
            }
            return SizedBox(
              height: snapshot.data!.length * 60 + 10,
              child: ListView.builder(
                controller: cont,
                itemBuilder: (context, index) {
                  var a = snapshot.data![index];
                  return ListTile(
                    leading: const CircleAvatar(
                      backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSRt110PWYr_eqwfC-rgM7A_ceWC0aIYQvx0Q&usqp=CAU'),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(a.getname()),
                        if (a.lastmessage != null)
                          Text(
                            DateFormat.Hm().format(a.lastmessage!.timestamp),
                          ),
                      ],
                    ),
                    subtitle: a.lastmessage != null
                        ? Text(
                            a.lastmessage!.messagetext != null ? a.lastmessage!.messagetext! : 'photo',
                          )
                        : const Text(''),
                    onTap: () {
                      Get.find<ChatRoomController>().setChatRoom(a);
                      // Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChatScreen(),
                        ),
                      );
                    },
                  );
                },
                itemCount: snapshot.data!.length,
              ),
            );
          },
          future: Get.find<FirebaseController>().findRoomsByName(q, p),
        ),
      ],
    );
  }

  Widget userslistviewunit(ScrollController cont, String q, String title) {
    return Column(
      children: [
        Text(title),
        FutureBuilder<List<UserModel>>(
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Text('HASNT DATA');
            }
            if (snapshot.data!.isEmpty) {
              return const Text('no matches');
            }
            return SizedBox(
              height: snapshot.data!.length * 60 + 10,
              child: ListView.builder(
                controller: cont,
                itemBuilder: (context, index) {
                  var a = snapshot.data![index];
                  return ListTile(
                    // leading: CircleAvatar(
                    //   backgroundImage: NetworkImage(a.profilepicUrl != null ? a.profilepicUrl! : 'http://assets.stickpng.com/thumbs/585e4beacb11b227491c3399.png'),
                    // ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(a.nickname),
                      ],
                    ),
                    subtitle: Text(a.email),
                    onTap: () async {
                      // bool exists = await Get.find<FirebaseController>().getOrMakeChatRoom(a);
                      bool exists = await Get.find<FirebaseController>().checkExistance(a);
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title: Text(exists ? 'already chatting.' : 'Start chatting?'),
                              content: Text(exists ? 'You already have a conversation with ${a.nickname}' : 'Do you want to start a chat with ${a.nickname}?'),
                              actions: [
                                TextButton.icon(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.close),
                                  label: const Text('back'),
                                ),
                                if (!exists)
                                  TextButton.icon(
                                    onPressed: () async {
                                      await Get.find<FirebaseController>().getOrMakeChatRoom(a).then((value) {
                                        Navigator.of(context).popUntil((route) => route.isFirst);
                                      });
                                    },
                                    icon: const Icon(Icons.arrow_forward),
                                    label: const Text('continue'),
                                  ),
                              ],
                            );
                          },);
                      // Get.find<ChatRoomController>().setChatRoom(a);
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const ChatScreen(),
                      //   ),
                      // );
                    },
                  );
                },
                itemCount: snapshot.data!.length,
              ),
            );
          },
          future: Get.find<FirebaseController>().findUsersByName(q),
        ),
      ],
    );
  }
}
