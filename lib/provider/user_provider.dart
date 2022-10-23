import 'package:flutter/foundation.dart';

import '../model/user.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  UserProvider();

  UserModel? get user => _user;

  set user(UserModel? user) {
    _user = user;
    notifyListeners();
  }
}
