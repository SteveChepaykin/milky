import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milky/controllers/firebase_controller.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool isEditing = false;
  TextEditingController nicknamecont = TextEditingController();
  TextEditingController identifiercont = TextEditingController();

  void activateTextFields(String nickname, String identifier) {
    nicknamecont.text = nickname;
    identifiercont.text = identifier;
  }

  @override
  Widget build(BuildContext context) {
    final user = Get.find<FirebaseController>().currentUser!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        actions: [
          TextButton.icon(
            onPressed: () async {
              await Get.find<FirebaseController>().signOutUser();
            },
            icon: const Icon(Icons.exit_to_app_rounded),
            label: const Text('LOG OUT'),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {},
              child: CircleAvatar(
                radius: 50,
                backgroundImage:
                    NetworkImage(user.profilepicUrl != null ? user.profilepicUrl! : 'http://assets.stickpng.com/thumbs/585e4beacb11b227491c3399.png'),
              ),
            ),
            isEditing
                ? Text(user.nickname)
                : TextField(
                    controller: nicknamecont,
                  ),
            // isEditing ? Text(user.identifier) : TextField(
            //   controller: identifiercont,
            // ),
            Text(user.identifier),
            TextButton.icon(
              onPressed: isEditing
                  ? () async {
                      await Get.find<FirebaseController>().updateUserInfo({
                        'nickname': nicknamecont.text,
                      });
                      isEditing = false;
                    }
                  : () {
                      setState(() {
                        activateTextFields(user.nickname, user.identifier);
                        isEditing = true;
                      });
                    },
              icon: const Icon(Icons.edit),
              label: const Text('change'),
            )
          ],
        ),
      ),
    );
  }
}
