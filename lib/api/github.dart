import 'dart:convert';

import 'package:dio/dio.dart';

import '../constants.dart';
import '../model/github/repo.dart';
import '../model/github/user.dart';
import '../model/page.dart';
import 'openapi.dart';

final RegExp linkReg = RegExp(
    r'<https://api.github.com/user/starred\?page=(\d+)&per_page=(\d+)>; rel="last"');

class GithubAPI implements OpenAPI {
  String _token;
  late Dio dio;

  GithubAPI(this._token) {
    dio = Dio(BaseOptions(
        baseUrl: 'https://api.github.com',
        connectTimeout: 10000,
        receiveTimeout: 30000))
      ..interceptors.add(AuthInterceptors(_token));
  }

  factory GithubAPI.withProxy(String token, String proxyServer) {
    var api = GithubAPI(token);
    OpenAPI.withProxy(api.dio, proxyServer);
    return api;
  }

  static Future<String> getAccessToken(String code,
      [String proxyServer = '']) async {
    Dio dio = Dio();
    dio.options.baseUrl = 'https://github.com';
    dio.options.connectTimeout = 10000;
    dio.options.receiveTimeout = 30000;
    dio.options.headers['Accept'] = 'application/json';
    if (proxyServer.isNotEmpty) {
      OpenAPI.withProxy(dio, proxyServer);
    }
    var uri = '/login/oauth/access_token';
    Response response = await dio.post(uri,
        data: FormData.fromMap({
          // 'grant_type': 'authorization_code',
          'client_id': CLIENT_ID,
          'client_secret': CLIENT_SECRET,
          'code': code,
          'redirect_uri': REDIRECT_URL
        }));
    return response.data['access_token'];
  }

  Future<User> user() async {
    Response response = await dio.get('/user');
    return User.fromJson(response.data);
  }

  Future<Pageable<Repo>> starred(int p, {int size = 10}) async {
    Response response = await dio.get('/user/starred?page=$p&per_page=$size');
    int totalPage = p;
    var link = response.headers.value('Link');
    // <https://api.github.com/user/starred?page=2&per_page=10>; rel="next", <https://api.github.com/user/starred?page=135&per_page=10>; rel="last"
    if (link != null) {
      var m = linkReg.firstMatch(link);
      var t = m?.group(1) ?? p.toString();
      totalPage = int.parse(t);
    }
    Pageable<Repo> page = Pageable<Repo>.of(p, size, totalPage);
    page.list = (response.data as List).map((e) => Repo.fromJson(e)).toList();
    return page;
  }

  Future<String> readme(String owner, String repo) async {
    Response response = await dio.get('/repos/$owner/$repo/readme');
    return response.data['content'];
  }

  Future<void> unStarred(String owner, String repo) async {
    await dio.delete('/user/starred/$owner/$repo');
  }
}

class AuthInterceptors extends Interceptor {
  final String token;

  AuthInterceptors(this.token);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Accept'] = 'application/vnd.github+json';
    options.headers['Authorization'] = 'token $token';
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('RESPONSE[${response.statusCode}] => ${json.encode(response.data)}');
    super.onResponse(response, handler);
  }

  void onError(
    DioError err,
    ErrorInterceptorHandler handler,
  ) {
    print('${err.requestOptions.headers}');
    return handler.next(err);
  }
}
