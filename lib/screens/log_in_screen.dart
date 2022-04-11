import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milky/controllers/firebase_controller.dart';
import 'package:milky/screens/register_screen.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  TextEditingController emailcont = TextEditingController();
  TextEditingController paaswordcont = TextEditingController();
  // TextEditingController nicknamecont = TextEditingController();
  // TextEditingController identifiercont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // TextField(
              //   controller: nicknamecont,
              //   decoration: const InputDecoration(hintText: 'nickname'),
              // ),
              // TextField(
              //   controller: identifiercont,
              //   decoration: const InputDecoration(hintText: 'identifier'),
              // ),
              TextField(
                controller: emailcont,
                decoration: const InputDecoration(hintText: 'email'),
              ),
              TextField(
                controller: paaswordcont,
                maxLength: 10,
                decoration: const InputDecoration(
                  hintText: 'password',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextButton.icon(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen()));
                  },
                  icon: const Icon(Icons.account_box),
                  label: const Text('Dont have account? CREATE')),
              const SizedBox(
                height: 30,
              ),
              TextButton.icon(
                onPressed: () {
                  if (emailcont.text.isNotEmpty && paaswordcont.text.isNotEmpty) {
                    Get.find<FirebaseController>().signInUser({
                      'email': emailcont.text,
                      'password': paaswordcont.text,
                    });
                  }
                },
                icon: const Icon(Icons.account_box),
                label: const Text('LOG IN'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
