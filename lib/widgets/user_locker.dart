import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milky/controllers/firebase_controller.dart';
import 'package:milky/screens/account_screen.dart';
import 'package:milky/screens/settings_screen.dart';

class UserLocker extends StatelessWidget {
  const UserLocker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final thisuser = Get.find<FirebaseController>().currentUser;
    return Drawer(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AccountScreen()));
            },
            child: Container(
              color: Theme.of(context).cardColor,
              height: MediaQuery.of(context).size.height * 0.2,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        thisuser!.profilepicUrl != null ? thisuser.profilepicUrl! : 'http://assets.stickpng.com/thumbs/585e4beacb11b227491c3399.png',
                      ),
                      radius: 40,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          child: Text(
                            thisuser.nickname,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        FittedBox(
                          child: Text(
                            thisuser.identifier,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          ListTile(
            title: const Text('settings'),
            leading: const Icon(Icons.settings),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ),
        ],
      ),
    );
  }
}
