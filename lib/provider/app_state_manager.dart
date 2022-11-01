import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_github/api/github.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/openapi.dart';
import '../constants.dart';

class AppStateManager extends ChangeNotifier {
  late final SharedPreferences sharedPreferences;
  late OpenAPI _openAPI;
  bool _loginState = false;

  AppStateManager(this.sharedPreferences);

  bool get loggedIn => _loginState;
  OpenAPI get api => _openAPI;

  set token(String token) {
    sharedPreferences.setString('token', token);
    _loginState = true;
    _openAPI = GithubAPI(token);
    notifyListeners();
  }

  void logout() async {
    _loginState = false;
    sharedPreferences.remove('token');
    notifyListeners();
  }

  Future<void> onAppStart() async {
    String? token = sharedPreferences.getString('token');
    if (token == null || token.isEmpty) {
      return;
    }
    Dio dio = Dio();
    dio.options.connectTimeout = 10000;
    dio.options.receiveTimeout = 30000;
    OpenAPI.withProxy(dio, '127.0.0.1:7890');

    try {
      await dio.post('https://api.github.com/applications/$CLIENT_ID/token',
          data: {'access_token': token},
          options: Options(headers: {
            'Authorization':
                'Basic ${base64Encode('$CLIENT_ID:$CLIENT_SECRET'.codeUnits)}',
            'Accept': 'application/vnd.github+json'
          }));
      this.token = token;
    } on DioError catch (e) {
      print(e.toString());
      if (e.response?.statusCode == 404) {
        await sharedPreferences.remove('token');
      }
      this.token = token;
    }
  }
}
