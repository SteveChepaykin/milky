import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milky/controllers/firebase_controller.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Get.find<FirebaseController>().currentUser!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        actions: [
          TextButton.icon(
            onPressed: () {
              Get.find<FirebaseController>().signOutUser();
            },
            icon: const Icon(Icons.exit_to_app_rounded),
            label: const Text('LOG OUT'),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage:NetworkImage(user.profilepicUrl != null ? user.profilepicUrl! : 'http://assets.stickpng.com/thumbs/585e4beacb11b227491c3399.png'),
            ),
            Text(user.nickname),
            Text(user.identifier),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit),
              label: const Text('change'),
            )
          ],
        ),
      ),
    );
  }
}
