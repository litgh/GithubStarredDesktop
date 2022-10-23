import 'package:json_annotation/json_annotation.dart';

import '../user.dart';

part 'user.g.dart';

@JsonSerializable()
class User implements UserModel {
  User(
    this.avatarUrl,
    this.id,
    this.login,
    this.name,
  );

  String avatarUrl;
  int id;
  String login;
  String name;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
