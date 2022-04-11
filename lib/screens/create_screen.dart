import 'package:flutter/material.dart';

class OnBoardCreateScreen extends StatefulWidget {
  const OnBoardCreateScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardCreateScreen> createState() => _OnBoardCreateScreenState();
}

class _OnBoardCreateScreenState extends State<OnBoardCreateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'create:',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            createContainer(
                () {},
                const Icon(
                  Icons.account_box,
                  size: 50,
                ),
                'GROUP'),
            const SizedBox(
              height: 20,
            ),
            createContainer(
                () {},
                const Icon(
                  Icons.ac_unit,
                  size: 50,
                ),
                'CHANNEL'),
          ],
        ),
      ),
    );
  }

  Widget createContainer(Function() funk, Icon icon, String t) => Expanded(
        child: GestureDetector(
          onTap: funk,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Color.fromARGB(134, 158, 158, 158),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    t,
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
