import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milky/controllers/settings_controller.dart';
import 'package:milky/models/color_schemes.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController cont = TextEditingController();
  final TextEditingController spdcont = TextEditingController();
  // late int schemeindex;

  @override
  void initState() {
    var a = Get.find<SettingsController>();
    cont.text = a.getSize().toString();
    spdcont.text = a.getRadius()!.toString();
    // isDark = a.getDarkmode()!;
    // schemeindex = a.getSchemeIndex()!;
    // rad = a.getRadius()!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('change text size'),
              SizedBox(
                width: 100,
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: cont,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  ),
                  // style: const TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text('change message roundness'),
              SizedBox(
                width: 100,
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: spdcont,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  ),
                  // style: const TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text('set dark mode'),
              Obx(
                () {
                  var themecont = Get.find<ThemeController>();
                  return Switch(
                    value: themecont.thememode$.value == ThemeMode.dark,
                    onChanged: (v) {
                      themecont.toggleTheme(v);
                    },
                  );
                },
              ),
              const Text('set color cheme'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        Get.find<ThemeController>().chooseScheme(0);
                      },
                      child: const Text('1')),
                  TextButton(
                      onPressed: () {
                        Get.find<ThemeController>().chooseScheme(1);
                      },
                      child: const Text('2')),
                  TextButton(
                      onPressed: () {
                        Get.find<ThemeController>().chooseScheme(2);
                      },
                      child: const Text('3')),
                  TextButton(
                      onPressed: () {
                        Get.find<ThemeController>().chooseScheme(3);
                      },
                      child: const Text('4')),
                ],
              ),
              // TextButton.icon(
              //   onPressed: () {
              //     var a = Get.find<SettingsController>();
              //     a.setSize(double.parse(cont.text));
              //     a.setRadius(double.parse(spdcont.text));
              //     // a.setScheme(schemeindex);
              //     // a.setDarkmode(isDark);
              //     Navigator.pop(context);
              //     setState(() {});
              //   },
              //   icon: const Icon(
              //     Icons.save,
              //     // color: Colors.white,
              //   ),
              //   label: const Text(
              //     'сохранить',
              //     // style: TextStyle(color: Colors.white),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget butn(int v) {
  //   return ElevatedButton(
  //     // style: ButtonStyle(backgroundColor: const Color.fromARGB(255, 28, 57, 78),),
  //     style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 28, 57, 78))),
  //     onPressed: () {
  //       setState(() {
  //         spd = v;
  //       });
  //     },
  //     child: Text(
  //       v.toString(),
  //       style: TextStyle(
  //         color: spd == v ? Colors.amber : Colors.white,
  //       ),
  //     ),
  //   );
  // }
}
