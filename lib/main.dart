import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_github/provider/settings_provider.dart';
import 'package:flutter_github/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

import 'database/database.dart';
import 'provider/app_state_manager.dart';
import 'router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isDesktop = Platform.isMacOS || Platform.isWindows || Platform.isLinux;
  if (isDesktop) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
        size: Size(1400, 900),
        center: true,
        backgroundColor: Colors.transparent,
        skipTaskbar: false);
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  AppStateManager appStateManager = AppStateManager(sharedPreferences);
  await appStateManager.onAppStart();
  AppCatchError().run(GithubStarredApp(appStateManager: appStateManager));
}

class AppCatchError {
  run(Widget app) {
    FlutterError.onError = (details) async {
      if (kReleaseMode) {
        Zone.current.handleUncaughtError(details.exception, details.stack!);
      } else {
        FlutterError.dumpErrorToConsole(details);
      }
    };
    runZonedGuarded(() {
      runApp(app);
    }, (err, stack) => catchError(err, stack));
  }

  catchError(Object err, StackTrace stack) {
    print('$err, $stack');
  }
}

class GithubStarredApp extends StatefulWidget {
  final AppStateManager appStateManager;
  const GithubStarredApp({Key? key, required this.appStateManager})
      : super(key: key);

  @override
  _GithubStarredAppState createState() => _GithubStarredAppState();
}

class _GithubStarredAppState extends State<GithubStarredApp> {
  final Database database = Database();
  late final AppRouter _goRouter = AppRouter(widget.appStateManager);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider.value(value: database),
          ChangeNotifierProvider.value(value: widget.appStateManager),
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => SettingProvider())
        ],
        child: Builder(
          builder: (context) {
            final goRouter = _goRouter.router;
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'Github starred',
              routeInformationParser: goRouter.routeInformationParser,
              routeInformationProvider: goRouter.routeInformationProvider,
              routerDelegate: goRouter.routerDelegate,
              theme: ThemeData(
                  scrollbarTheme: ScrollbarThemeData(
                      trackVisibility: MaterialStateProperty.all(true),
                      thickness: MaterialStateProperty.all(10),
                      thumbColor: MaterialStateProperty.all(Colors.blue),
                      radius: const Radius.circular(10),
                      minThumbLength: 30)),
            );
          },
        ));
  }
}
