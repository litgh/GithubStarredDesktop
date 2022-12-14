import 'package:flutter_github/provider/app_state_manager.dart';
import 'package:flutter_github/setting.dart';
import 'package:go_router/go_router.dart';

import 'home.dart';
import 'login.dart';
import 'error.dart';
import 'search.dart';

class AppRouter {
  late final AppStateManager appStateManager;

  AppRouter(this.appStateManager);

  GoRouter get router => _goRouter;
  late final _goRouter = GoRouter(
    refreshListenable: appStateManager,
    initialLocation: '/login',
    routes: <GoRoute>[
      GoRoute(
          path: '/',
          name: 'Home',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: Home())),
      GoRoute(
        path: '/login',
        name: 'Login',
        pageBuilder: (context, state) => const NoTransitionPage(child: Login()),
      ),
      GoRoute(
        path: '/error',
        name: 'Error',
        builder: (context, state) => Error(error: state.extra.toString()),
      ),
      GoRoute(
          path: '/settings',
          name: 'Settings',
          builder: ((context, state) => Setting())),
      GoRoute(
        path: '/search',
        name: 'Search',
        builder: (context, state) => Search(),
      )
    ],
    errorBuilder: (context, state) => Error(error: state.extra.toString()),
    redirect: (context, state) {
      final loginLocation = state.namedLocation('Login');
      // final homeLocation = state.namedLocation('Home');
      final isLogedIn = appStateManager.loggedIn;
      final isGoToLogin = state.subloc == loginLocation;
      // if (isLogedIn && isGoToLogin) {
      //   return homeLocation;
      // }
      if (!isLogedIn && !isGoToLogin) {
        return loginLocation;
      }

      return null;
    },
  );
}
