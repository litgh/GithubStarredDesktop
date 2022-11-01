import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_github/api/github.dart';
import 'package:flutter_github/provider/app_state_manager.dart';
import 'package:flutter_github/provider/settings_provider.dart';
import 'package:flutter_github/util.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:window_manager/window_manager.dart';

import 'constants.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login>
    with WidgetsBindingObserver, TickerProviderStateMixin, WindowListener {
  bool loging = false;
  bool resizing = false;
  @override
  void initState() {
    if (isDesktop()) {
      windowManager.addListener(this);
    } else {
      WidgetsBinding.instance.addObserver(this);
    }

    super.initState();
  }

  @override
  void dispose() {
    if (isDesktop()) {
      windowManager.removeListener(this);
    } else {
      WidgetsBinding.instance.removeObserver(this);
    }

    super.dispose();
  }

  @override
  void onWindowFocus() {
    didChangeAppLifecycleState(AppLifecycleState.resumed);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed && loging) {
      _getAccessToken(
              context.read<AppStateManager>(), context.read<SettingProvider>())
          .then((value) {
        context.go('/');
      }, onError: (e) {
        showDialog(
            context: context,
            builder: ((context) {
              return AlertDialog(content: Text(e.toString()));
            }));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: resizing
          ? Container()
          : Center(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: Image.asset('images/logo.png'),
                  ),
                  Container(
                    width: 180,
                    margin: const EdgeInsets.only(top: 20),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
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
                              context.go('/');
                            },
                            child: const CircularProgressIndicator(),
                          )
                        : InkWell(
                            onTap: () async {
                              if (context.read<AppStateManager>().loggedIn) {
                                setState(() {
                                  resizing = true;
                                });
                                if (isDesktop()) {
                                  windowManager.maximize().then((value) {
                                    context.go('/');
                                  });
                                } else {
                                  context.go('/');
                                }
                                return;
                              }
                              setState(() {
                                loging = true;
                              });
                              if (await canLaunchUrlString(AUTHORIZATION_URL)) {
                                await launchUrlString(AUTHORIZATION_URL);
                              } else {
                                throw 'Can not launch $AUTHORIZATION_URL)';
                              }
                            },
                            child: const Text(
                              'Sign In',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> _getAccessToken(
      AppStateManager appStateManager, SettingProvider settings) async {
    const platform = MethodChannel('app.channel.shared.data');
    final code = await platform.invokeMethod('getLoginCode');
    if (code == null || code == '') {
      return Future.value();
    }
    setState(() {
      loging = true;
    });
    var authCode = code.toString().split('=')[1];
    final token = await GithubAPI.getAccessToken(
        authCode, settings.proxyServer ?? '127.0.0.1:7890');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    print('TOKEN=========>$token');
    appStateManager.token = token;
    return Future.value();
  }
}
