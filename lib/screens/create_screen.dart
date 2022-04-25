import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milky/controllers/firebase_controller.dart';
import 'package:milky/models/search_listtile_model.dart';
import 'package:milky/models/user_model.dart';
import 'package:milky/widgets/choose_user_listtile.dart';

class CreateRoomScreen extends StatefulWidget {
  final bool isGroup;
  const CreateRoomScreen({Key? key, required this.isGroup}) : super(key: key);

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final TextEditingController namecont = TextEditingController();
  List<SearchListTile> myusers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('create'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: namecont,
                decoration: InputDecoration(
                  hintText: widget.isGroup ? 'group name...' : 'channel name...',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              if (widget.isGroup)
                FutureBuilder<List<UserModel>>(
                  future: Get.find<FirebaseController>().findYourUsers(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Text('NODATA');
                    }
                    if (snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('You have no known users.'),
                      );
                    }
                    // myusers.addAll(snapshot.data!.map((e) => false));
                    return SizedBox(
                      height: snapshot.data!.length * 60 + 10,
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var a = snapshot.data![index];
                          // return ListTile(
                          //   key: ValueKey(a.id),
                          //   leading: Checkbox(
                          //     value: myusers[index],
                          //     onChanged: (v) {
                          //       myusers[index] = !myusers[index];
                          //     },
                          //   ),
                          //   title: Text(a.nickname),
                          //   subtitle: Text(a.identifier),
                          // );

                          // return CheckboxListTile(
                          //   value: myusers[index],
                          //   onChanged: (v) {
                          //     myusers[index] = !myusers[index];
                          //     // setState(() {

                          //     // });
                          //   },
                          //   title: Text(a.nickname),
                          //   subtitle: Text(a.identifier),
                          // );

                          SearchListTile slt = SearchListTile(a);
                          myusers.add(slt);
                          return ChooseUserListtile(slt: slt);
                        },
                      ),
                    );
                  },
                ),
              TextButton.icon(
                onPressed: () async {
                  await (widget.isGroup
                          ? Get.find<FirebaseController>().createGroup(
                              namecont.text,
                              myusers.where((element) => element.isChosen).toList().map((e) => e.user).toList(),
                            )
                          : Get.find<FirebaseController>().createChannel(namecont.text))
                      .whenComplete(
                    () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('CREATED'),
                            content: Text('${widget.isGroup ? 'group' : 'channel'} ${namecont.text} created successfully.'),
                            actions: [
                              TextButton.icon(
                                onPressed: () {
                                  Navigator.popUntil(context, (route) => route.isFirst);
                                },
                                icon: const Icon(Icons.close),
                                label: const Text('back'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
                icon: const Icon(Icons.create),
                label: Text(widget.isGroup ? 'create group' : 'create channel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
