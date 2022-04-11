import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:milky/controllers/chat_room_controller.dart';
import 'package:milky/controllers/firebase_controller.dart';
import 'package:get/get.dart';
import 'package:milky/screens/home_chats_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var fcont = FirebaseController();
  var rcont = ChatRoomController();
  Get.put<FirebaseController>(fcont);
  Get.put<ChatRoomController>(rcont);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeChatsScreen(),
    );
  }
}