import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:milky/controllers/chat_room_controller.dart';
import 'package:milky/controllers/firebase_controller.dart';
import 'package:get/get.dart';
import 'package:milky/controllers/settings_controller.dart';
import 'package:milky/models/color_schemes.dart';
import 'package:milky/models/user_model.dart';
import 'package:milky/screens/home_chats_screen.dart';
import 'package:milky/screens/log_in_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var fcont = FirebaseController();
  fcont.listenUserAuthState();
  var rcont = ChatRoomController();
  var setcont = SettingsController();
  await setcont.init();
  Get.put<FirebaseController>(fcont);
  Get.put<ChatRoomController>(rcont);
  Get.put<SettingsController>(setcont);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, _) {
        final themeprov = Provider.of<ThemeProvider>(context,);
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          themeMode: themeprov.thememode,
          theme: MyThemes.lightTheme,
          darkTheme: MyThemes.darkTheme,
          home: StreamBuilder<UserModel?>(
            stream: Get.find<FirebaseController>().currentUser$.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const LogInScreen();
              }
              return const HomeChatsScreen();
            },
          ),
        );
      },
    );
  }
}
