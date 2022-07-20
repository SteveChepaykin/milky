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
  late int chosen;

  @override
  void initState() {
    var a = Get.find<SettingsController>();
    cont.text = a.getSize().toString();
    spdcont.text = a.getRadius()!.toString();
    chosen = a.getSchemeIndex()!;
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
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: ThemeController.schemes.length / 4 * 120,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: ThemeController.schemes.length,
                  itemBuilder: (context, i) => Container(
                    decoration: chosen == i
                        ? BoxDecoration(
                            border: Border.all(width: 1.5, color: Theme.of(context).colorScheme.secondary),
                            borderRadius: const BorderRadius.all(Radius.circular(20)))
                        : null,
                    child: TextButton(
                      onPressed: () {
                        Get.find<ThemeController>().chooseScheme(i);
                        chosen = i;
                        setState(() {});
                      },
                      child: Text(ThemeController.schemes[i].name),
                    ),
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  var a = Get.find<SettingsController>();
                  a.setSize(double.parse(cont.text));
                  a.setRadius(double.parse(spdcont.text));
                  Navigator.pop(context);
                  setState(() {});
                },
                icon: const Icon(Icons.save_rounded),
                label: const Text('save changes'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
