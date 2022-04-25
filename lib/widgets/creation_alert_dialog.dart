import 'package:flutter/material.dart';
import 'package:milky/screens/create_screen.dart';

class CreationAlertDialog extends StatelessWidget {
  const CreationAlertDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('CREATE:'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateRoomScreen(isGroup: true,)));
            },
            title: const Text('GROUP'),
            subtitle: const Text('creates a group - a lot of talking users.'),
            leading: const Icon(
              Icons.account_circle,
              size: 40,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateRoomScreen(isGroup: false,)));
            },
            title: const Text('CHANNEL'),
            subtitle: const Text('creates a channel - a lot of users listening to one host.'),
            leading: const Icon(
              Icons.ac_unit,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}
