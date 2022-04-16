import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milky/controllers/firebase_controller.dart'; 

class AccountScreen extends StatefulWidget {
  const AccountScreen({ Key? key }) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: Center(child: TextButton.icon(onPressed: () async {
        await Get.find<FirebaseController>().signOutUser();
      }, icon: const Icon(Icons.exit_to_app), label: const Text('LOG OUT'))),
    );
  }
}