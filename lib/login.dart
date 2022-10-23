import 'dart:async';
import 'dart:io';

import 'package:desktop_lifecycle/desktop_lifecycle.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_github/api/github.dart';
import 'package:flutter_github/provider/app_state_manager.dart';
import 'package:flutter_github/provider/settings_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'constants.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  bool loging = false;
  @override
  void initState() {
    if (Platform.isIOS || Platform.isAndroid) {
      WidgetsBinding.instance.addObserver(this);
    } else {
      DesktopLifecycle.instance.isActive.addListener(resume);
    }

    super.initState();
  }

  @override
  void dispose() {
    if (Platform.isIOS || Platform.isAndroid) {
      WidgetsBinding.instance.removeObserver(this);
    } else {
      DesktopLifecycle.instance.isActive.removeListener(resume);
    }

    super.dispose();
  }

  void resume() {
    didChangeAppLifecycleState(AppLifecycleState.resumed);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !loging) {
      _getAccessToken(
          context.read<AppStateManager>(), context.read<SettingProvider>());
    }
  }

  @override
  Widget build(BuildContext context) {
    return loginScreen(context);
  }

  Widget loginScreen(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: h * 0.2,
            ),
            const Text(
              'Github starred',
              style: TextStyle(fontSize: 40, color: Colors.black),
            ),
            Container(
              width: 300,
              margin: EdgeInsets.only(top: 20),
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(2, 2),
                        blurRadius: 1,
                        spreadRadius: 1),
                    BoxShadow(
                        color: Colors.white,
                        offset: Offset(0, 0),
                        blurRadius: 0,
                        spreadRadius: 0)
                  ]),
              child: loging
                  ? InkWell(
                      onTap: () {
                        context.go('/home');
                      },
                      child: const CircularProgressIndicator(),
                    )
                  : InkWell(
                      onTap: () async {
                        if (await canLaunchUrlString(AUTHORIZATION_URL)) {
                          await launchUrlString(AUTHORIZATION_URL);
                        } else {
                          throw 'Can not launch $AUTHORIZATION_URL)';
                        }
                      },
                      child: const Text(
                        'Sign In',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  _getAccessToken(
      AppStateManager appStateManager, SettingProvider settings) async {
    const platform = MethodChannel('app.channel.shared.data');
    final code = await platform.invokeMethod('getLoginCode');
    if (code == null || code == '') {
      return Future.value('');
    }
    setState(() {
      loging = true;
    });
    var authCode = code.toString().split('=')[1];
    try {
      final token = await GithubAPI.getAccessToken(
          authCode, settings.proxyServer ?? '127.0.0.1:7890');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      print('TOKEN=========>$token');
      appStateManager.token = token;
    } on DioError catch (e) {
      print(e);
    } on IOException catch (e) {
      print(e);
    }
  }
}
