import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milky/controllers/firebase_controller.dart';

class RegisterGoogleScreen extends StatelessWidget {
  final String email;
  const RegisterGoogleScreen({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController nicknamecont = TextEditingController();
    TextEditingController identifiercont = TextEditingController();

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: nicknamecont,
                decoration: const InputDecoration(hintText: 'nickname'),
              ),
              TextField(
                controller: identifiercont,
                // maxLength: 10,
                decoration: const InputDecoration(
                  hintText: 'identifier',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextButton.icon(
                onPressed: () async {
                  await Get.find<FirebaseController>().adduser({
                    'email': email,
                    'nickname': nicknamecont.text,
                    'identifier': identifiercont.text,
                  }).whenComplete(() {
                    Navigator.pop(context);
                  });
                },
                icon: const Icon(Icons.account_box),
                label: const Text('LOG IN'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
