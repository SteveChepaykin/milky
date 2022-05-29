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
    final _form = GlobalKey<FormState>();
    String nickname = '', identifier = '';

    void register() async {
      bool isValid = _form.currentState!.validate();
      if (isValid) {
        await Get.find<FirebaseController>().adduser({
          'email': email,
          'nickname': nickname,
          'identifier': identifier,
        }).whenComplete(() {
          Navigator.pop(context);
        });
      }
    }

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
          //       // maxLength: 10,
          //       decoration: const InputDecoration(
          //         hintText: 'identifier',
          //       ),
          //     ),
          //     const SizedBox(
          //       height: 30,
          //     ),
          //     TextButton.icon(
          //       onPressed: () async {
          //         await Get.find<FirebaseController>().adduser({
          //           'email': email,
          //           'nickname': nicknamecont.text,
          //           'identifier': identifiercont.text,
          //         }).whenComplete(() {
          //           Navigator.pop(context);
          //         });
          //       },
          //       icon: const Icon(Icons.account_box),
          //       label: const Text('LOG IN'),
          //     ),
          //   ],
          // ),
          child: Form(
            key: _form,
            child: ListView(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'enter nickname...',
                    hintStyle: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'please enter a nickname.';
                    }
                    return null;
                  },
                  onSaved: (v) {
                    nickname = v!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'enter identifier...',
                    hintStyle: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'please enter identifier.';
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
                const SizedBox(
                height: 30,
              ),
              TextButton.icon(
                onPressed: register,
                icon: const Icon(Icons.account_box),
                label: const Text('LOG IN'),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
