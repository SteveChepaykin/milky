import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milky/controllers/firebase_controller.dart';
import 'package:milky/screens/register_google_screen.dart';
import 'package:milky/screens/register_screen.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  // TextEditingController emailcont = TextEditingController();
  // TextEditingController paaswordcont = TextEditingController();
  final _form = GlobalKey<FormState>();
  String email = '', password = '';
  // TextEditingController nicknamecont = TextEditingController();
  // TextEditingController identifiercont = TextEditingController();

  void register() {
    bool isValid = _form.currentState!.validate();
    if (isValid) {
      Get.find<FirebaseController>().signInUser({
        'email': email,
        'password': password,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          // child: Column(
          //   children: [
          //     TextField(
          //       controller: emailcont,
          //       decoration: const InputDecoration(hintText: 'email'),
          //     ),
          //     TextField(
          //       controller: paaswordcont,
          //       maxLength: 10,
          //       decoration: const InputDecoration(
          //         hintText: 'password',
          //       ),
          //     ),
          //     const SizedBox(
          //       height: 30,
          //     ),
          //     TextButton.icon(
          //         onPressed: () {
          //           Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen()));
          //         },
          //         icon: const Icon(Icons.account_box),
          //         label: const Text('Dont have account? CREATE')),
          //     const SizedBox(
          //       height: 30,
          //     ),
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: [
          //         TextButton.icon(
          //           onPressed: () {
          //             if (emailcont.text.isNotEmpty && paaswordcont.text.isNotEmpty) {
          //               Get.find<FirebaseController>().signInUser({
          //                 'email': emailcont.text,
          //                 'password': paaswordcont.text,
          //               });
          //             }
          //           },
          //           icon: const Icon(Icons.account_box),
          //           label: const Text('LOG IN'),
          //         ),
          //         TextButton.icon(
          //           onPressed: checkOrLoginGoogle,
          //           icon: const Icon(Icons.compare),
          //           label: const Text('LOG IN WITH GOOGLE'),
          //         ),
          //       ],
          //     )
          //   ],
          // ),
          child: Form(
            key: _form,
            child: ListView(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'enter your email...',
                    hintStyle: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'please enter email.';
                    }
                    if (!value.isEmail) {
                      return 'please enter valid email.';
                    }
                    return null;
                  },
                  onSaved: (v) {
                    email = v!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'enter password...',
                    hintStyle: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  obscureText: true,
                  maxLength: 10,
                  obscuringCharacter: '*',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'please enter password.';
                    }
                    return null;
                  },
                  onSaved: (v) {
                    password = v!;
                  },
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton.icon(
                      onPressed: register,
                      icon: const Icon(Icons.account_box),
                      label: const Text('LOG IN'),
                    ),
                    TextButton.icon(
                      onPressed: checkOrLoginGoogle,
                      icon: const Icon(Icons.compare),
                      label: const Text('LOG IN WITH GOOGLE'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void checkOrLoginGoogle() async {
    String? res = await Get.find<FirebaseController>().signInUserGoogle();
    if (res == null) return;
    if (res.startsWith('##')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RegisterGoogleScreen(
            email: res.substring(2),
          ),
        ),
      );
    }
  }
}
