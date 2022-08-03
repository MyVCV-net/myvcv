import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsPage extends StatefulWidget {
  static const String routeName = '/SettingsPage';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => SettingsPage(),
    );
  }

  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isSwitched = false;
  bool modeValue = false;
  String? val;
  @override
  void initState() {
    super.initState();
    if (GetStorage().hasData('theme')) {
      // val = ? '1' : '2';
      if (GetStorage().read('theme') == 'dark') {
        val = '1';
      } else if (GetStorage().read('theme') == 'light') {
        val = '2';
      } else if (GetStorage().read('theme') == 'system') {
        val = '3';
      }
    } else {
      val = '3';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        centerTitle: false,
        elevation: 0,
        title:
            const Text("Settings", style: TextStyle(color: Color(0xFF0A6077))),
      ),
      body: Column(
        children: [
          // Switch(
          //   value: isSwitched,
          //   onChanged: (value) {
          //     setState(() {
          //       isSwitched = value;
          //     });
          //     print(isSwitched);
          //   },
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Theme',
                  style: TextStyle(fontSize: 20),
                )),
          ),
          ListTile(
            title: Text("Dark Mode"),
            leading: Radio(
              value: '1',
              groupValue: val,
              onChanged: (value) {
                setState(() {
                  val = value.toString();
                  Get.changeThemeMode(ThemeMode.dark);
                  GetStorage().write('theme', 'dark');
                });
              },
              activeColor: Colors.green,
            ),
          ),
          ListTile(
            title: Text("Light Mode"),
            leading: Radio(
              value: '2',
              groupValue: val,
              onChanged: (value) {
                setState(() {
                  val = value.toString();
                  Get.changeThemeMode(ThemeMode.light);
                  GetStorage().write('theme', 'light');
                });
              },
              activeColor: Colors.green,
            ),
          ),
          ListTile(
            title: const Text('System'),
            leading: Radio(
              value: '3',
              groupValue: val,
              onChanged: (value) {
                setState(() {
                  val = value.toString();
                  Get.changeThemeMode(ThemeMode.system);
                  GetStorage().write('theme', 'system');
                });
              },
            ),
          ),
          // LanguagePickerDropdown(
          //   initialValue: Languages.korean,
          //   itemBuilder: _buildDropdownItem,
          //   onValuePicked: (Language language) {
          //     _selectedDropdownLanguage = language;
          //     print(_selectedDropdownLanguage.name);
          //     print(_selectedDropdownLanguage.isoCode);
          //   },
          // ),
          //   SettingsTile(
          //     title: 'Language',
          //     subtitle: 'English',
          //     leading: const Icon(Icons.language),
          //     onPressed: (context) {
          //       // Navigator.of(context).push(MaterialPageRoute(
          //       // builder: (_) => LanguagesScreen(),
          //       // ));
          //     },
          //   ),
          //   SettingsTile.switchTile(
          //     title: 'Dark mode',
          //     // enabled: notificationsEnabled,
          //     leading: const Icon(Icons.dark_mode),
          //     switchValue: false,
          //     onToggle: (value) {},
          //   ),
          //   SettingsTile.switchTile(
          //     title: 'Enable Notifications',
          //     // enabled: notificationsEnabled,
          //     leading: const Icon(Icons.notifications_active),
          //     switchValue: true,
          //     onToggle: (value) {},
          //   ),
        ],
      ),
    );
  }
}
