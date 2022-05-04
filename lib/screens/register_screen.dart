import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milky/controllers/firebase_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController passwordcont = TextEditingController();
  final _form = GlobalKey<FormState>();
  String nickname = '', identifier = '', email = '', password = '';

  void register() {
    bool isvalid = _form.currentState!.validate();
    if (isvalid) {
      _form.currentState!.save();
      Get.find<FirebaseController>().registerUser({
        'nickname': nickname,
        'email': email,
        'password': password,
        'identifier': identifier,
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
          //       controller: nicknamecont,
          //       decoration: const InputDecoration(hintText: 'nickname'),
          //     ),
          //     TextField(
          //       controller: identifiercont,
          //       decoration: const InputDecoration(hintText: 'identifier'),
          //     ),
          //     TextField(
          //       controller: emailcont,
          //       decoration: const InputDecoration(hintText: 'email'),
          //     ),
          //     TextField(
          //       controller: paaswordcont,
          //       maxLength: 10,
          //       decoration: const InputDecoration(hintText: 'password',),
          //     ),
          //     const SizedBox(height: 30,),
          //     TextButton.icon(onPressed: () {
          //       Get.find<FirebaseController>().registerUser({
          //         'nickname': nicknamecont.text,
          //         'email': emailcont.text,
          //         'password': paaswordcont.text,
          //         'identifier': identifiercont.text,
          //       });
          //     }, icon: const Icon(Icons.account_box), label: const Text('CREATE'))
          //   ],
          // ),
          child: Form(
            key: _form,
            child: ListView(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'enter username...',
                    hintStyle: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'please enter nickname.';
                    }
                    return null;
                  },
                  onSaved: (v) {
                    nickname = v!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'enter identifier ...',
                    hintStyle: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'please enter your identifier.';
                    }
                    if (!value.startsWith('@')) {
                      return 'identifier should start with "@".';
                    }
                    return null;
                  },
                  onSaved: (v) {
                    identifier = v!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'enter email...',
                    hintStyle: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'please enter your email.';
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
                  controller: passwordcont,
                  decoration: const InputDecoration(
                    hintText: 'enter password...',
                    hintStyle: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  maxLength: 10,
                  obscureText: true,
                  obscuringCharacter: '*',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'please enter password.';
                    }
                    if (value.length < 5) {
                      return 'password is too short.';
                    }
                    return null;
                  },
                  onSaved: (v) {
                    password = v!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 're-enter password...',
                    hintStyle: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  obscureText: true,
                  obscuringCharacter: '*',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'please re-enter your password.';
                    }
                    if (value != passwordcont.text) {
                      return 'shouldn\'t be different from password.';
                    }
                    return null;
                  },
                ),
                TextButton.icon(
                  onPressed: () {
                    // Get.find<FirebaseController>().registerUser({
                    //   'nickname': nicknamecont.text,
                    //   'email': emailcont.text,
                    //   'password': paaswordcont.text,
                    //   'identifier': identifiercont.text,
                    // });
                    register();
                  },
                  icon: const Icon(Icons.account_box),
                  label: const Text('CREATE'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
