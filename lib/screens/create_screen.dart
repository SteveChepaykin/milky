import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milky/controllers/firebase_controller.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({Key? key}) : super(key: key);

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final TextEditingController namecont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('create'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: namecont,
              decoration: const InputDecoration(
                hintText: 'channel name...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            TextButton.icon(
              onPressed: () async {
                await Get.find<FirebaseController>().createChannel(namecont.text).whenComplete(
                  () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('CREATED'),
                          content: Text('channel ${namecont.text} created successfully.'),
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
              label: const Text('create channel'),
            ),
          ],
        ),
      ),
    );
  }
}
