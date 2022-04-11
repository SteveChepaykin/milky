import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milky/controllers/firebase_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailcont = TextEditingController();
  TextEditingController paaswordcont = TextEditingController();
  TextEditingController nicknamecont = TextEditingController();
  TextEditingController identifiercont = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                decoration: const InputDecoration(hintText: 'identifier'),
              ),
              TextField(
                controller: emailcont,
                decoration: const InputDecoration(hintText: 'email'),
              ),
              TextField(
                controller: paaswordcont,
                maxLength: 10,
                decoration: const InputDecoration(hintText: 'password',),
              ),
              const SizedBox(height: 30,),
              TextButton.icon(onPressed: () {
                Get.find<FirebaseController>().registerUser({
                  'nickname': nicknamecont.text,
                  'email': emailcont.text,
                  'password': paaswordcont.text,
                  'identifier': identifiercont.text,
                });
              }, icon: const Icon(Icons.account_box), label: const Text('CREATE'))
            ],
          ),
        ),
      ),
    );
  }
}
