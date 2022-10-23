import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

import '../model/github/repo.dart';
import '../model/page.dart';
import '../model/user.dart';

abstract class OpenAPI {
  Future<UserModel> user();
  Future<Pageable<Repo>> starred(int page, {int size = 10});
  Future<String> readme(String owner, String repo);

  static void withProxy(Dio dio, String proxyServer) {
    if (proxyServer.isNotEmpty) {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.findProxy = (uri) => 'PROXY $proxyServer';
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }
  }
}
