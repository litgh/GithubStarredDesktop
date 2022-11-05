import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:go_router/go_router.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        backgroundColor: Colors.grey.withOpacity(0.3),
        body: Center(
            child: Container(
          width: 500,
          height: 700,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              TextInputSettingsTile(
                borderColor: Colors.black,
                helperText: 'Http Proxy Server',
                title: 'Proxy',
                settingKey: 'proxy',
              ),
              TextButton(
                  onPressed: () {
                    context.goNamed('Home');
                  },
                  child: Text('OK'))
            ],
          ),
        )));
  }
}
