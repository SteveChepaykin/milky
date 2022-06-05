import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:milky/controllers/firebase_controller.dart';
import 'package:milky/screens/register_google_screen.dart';
import 'package:milky/widgets/pick_pfp.dart';

class LoggingScreen extends StatefulWidget {
  const LoggingScreen({Key? key}) : super(key: key);

  @override
  State<LoggingScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<LoggingScreen> {
  TextEditingController passwordcont = TextEditingController();
  final _form = GlobalKey<FormState>();
  String nickname = '', identifier = '', email = '', password = '';
  File? imagefile;
  bool isLogin = true;

  void register() async {
    bool isvalid = _form.currentState!.validate();
    if (isvalid) {
      _form.currentState!.save();
      final ref = FirebaseStorage.instance.ref().child('user_images').child(email + '.jpg');
        await ref.putFile(imagefile!).whenComplete(() => null);
        final imageurl = await ref.getDownloadURL();
      Get.find<FirebaseController>().registerUser({
        'nickname': nickname,
        'email': email,
        'password': password,
        'identifier': identifier,
        'image_url': imageurl,
      });
    }
  }

  void login() {
    bool isValid = _form.currentState!.validate();
    if (isValid) {
      _form.currentState!.save();
      Get.find<FirebaseController>().signInUser({
        'email': email,
        'password': password,
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? 'log in' : 'create account'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _form,
            child: Column(
              children: [
                if (!isLogin)
                  PfpPick(pickImage: (File? f) {imagefile = f;},),
                if (!isLogin)
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
                if (!isLogin)
                  const SizedBox(
                    height: 10,
                  ),
                if (!isLogin)
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
                if (!isLogin)
                  const SizedBox(
                    height: 10,
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
                const SizedBox(
                  height: 10,
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
                if (!isLogin)
                  const SizedBox(
                    height: 10,
                  ),
                if (!isLogin)
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 're-enter password...',
                      hintStyle: TextStyle(fontStyle: FontStyle.italic),
                    ),
                    obscureText: true,
                    maxLength: 10,
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
                // TextButton.icon(
                //   onPressed: register,
                //   icon: const Icon(Icons.account_box),
                //   label: const Text('CREATE'),
                // ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton.icon(
                      onPressed: isLogin ? login : register,
                      icon: Icon(isLogin ? Icons.account_box : Icons.add_circle_outline_rounded),
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                      ),
                      label: Text(isLogin ? 'LOG IN' : 'CREATE'),
                    ),
                    TextButton.icon(
                      onPressed: checkOrLoginGoogle,
                      icon: const Icon(Icons.gpp_good_rounded),
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                      ),
                      label: const Text('SIGN IN WITH GOOGLE'),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                if (!isLogin)
                  const SizedBox(
                    height: 10,
                  ),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      isLogin = !isLogin;
                    });
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                  ),
                  icon: Icon(isLogin ? Icons.add_circle_outline_rounded : Icons.account_box),
                  label: Text(
                    isLogin ? 'Dont have account? CREATE' : 'already have an account? LOG IN',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
