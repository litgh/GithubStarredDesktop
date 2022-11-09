import 'package:dio/dio.dart';

import '../model/gitee/user.dart';
import '../model/github/repo.dart';
import '../model/page.dart';
import 'openapi.dart';

class GiteeAPI implements OpenAPI {
  Map<String, dynamic> queryParameters;
  final Dio dio;

  GiteeAPI({required String token})
      : dio = Dio(BaseOptions(
            baseUrl: 'https://gitee.com/api/v5',
            connectTimeout: 10000,
            receiveTimeout: 30000,
            headers: {'Content-Type': 'application/json;charset=UTF-8'})),
        queryParameters = {'access_token': token};

  @override
  Future<User> user() async {
    Response response =
        await dio.get('/user', queryParameters: queryParameters);
    return User.fromJson(response.data);
  }

  Future<Pageable<Repo>> starred(int page, {int size = 10}) async {
    return Future.value(null);
  }

  Future<String> readme(String owner, String repo) async {
    return Future.value('');
  }

  Future<void> unStarred(String owner, String repo) async {}

  @override
  Future<Pageable<Repo>> search(String q, int page,
      {int size = 10, String sort = '', String order = ''}) {
    throw UnimplementedError();
  }
}
