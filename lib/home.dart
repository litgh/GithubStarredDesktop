import 'package:flutter/material.dart';
import 'package:flutter_github/component/left_menu.dart';
import 'package:flutter_github/component/readme.dart';
import 'package:flutter_github/component/search_bar.dart';
import 'package:flutter_github/provider/app_state_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'provider/user_provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    _getUserProfile(
        context.read<AppStateManager>(), context.read<UserProvider>());
    super.initState();
  }

  _getUserProfile(
      AppStateManager appStateManager, UserProvider userProvider) async {
    userProvider.user = await appStateManager.api.user();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Github starred repos"),
          centerTitle: false,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: PopupMenuButton(
                position: PopupMenuPosition.under,
                child: Consumer<UserProvider>(
                    builder: (context, userProvider, _) =>
                        userProvider.user == null
                            ? const CircleAvatar(child: Text(''))
                            : CircleAvatar(
                                backgroundImage: NetworkImage(
                                    userProvider.user?.avatarUrl ?? ''))),
                itemBuilder: (context) => [
                  const PopupMenuItem<int>(value: 0, child: Text('Home')),
                  const PopupMenuItem<int>(value: 1, child: Text('Search')),
                  const PopupMenuItem<int>(value: 2, child: Text('Settings')),
                  const PopupMenuItem<int>(
                    value: 3,
                    child: Text('Log Out'),
                  )
                ],
                onSelected: (item) {
                  switch (item) {
                    case 0:
                      context.goNamed('Home');
                      break;
                    case 1:
                      context.goNamed('Search');
                      break;
                    case 2:
                      context.goNamed('Settings');
                      break;
                    case 3:
                      context.read<AppStateManager>().logout();
                      context.goNamed('Login');
                      windowManager.restore();
                      break;
                  }
                },
              ),
            ),
          ],
        ),
        body: Row(
          children: [
            const SizedBox(
              width: 250,
              child: LeftMenu(),
            ),
            const SizedBox(
              width: 320,
              child: SearchBar(),
            ),
            Expanded(child: Readme())
          ],
        ));
  }
}
