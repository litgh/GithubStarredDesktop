import 'package:json_annotation/json_annotation.dart';

part 'repo.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Repo {
  Repo(
      {required this.id,
      required this.nodeId,
      required this.name,
      required this.fullName,
      required this.owner,
      required this.htmlUrl,
      this.description,
      this.language,
      required this.forksCount,
      required this.stargazersCount,
      required this.watchersCount,
      required this.size,
      required this.topics});
  int id;
  String nodeId;
  String name;
  String fullName;
  Owner owner;
  String htmlUrl;
  String? description;
  String? language;
  int forksCount;
  int stargazersCount;
  int watchersCount;
  int size;
  List<String> topics;

  factory Repo.fromJson(Map<String, dynamic> json) => _$RepoFromJson(json);
  Map<String, dynamic> toJson() => _$RepoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Owner {
  Owner(this.login, this.avatarUrl);
  String login;
  String avatarUrl;

  factory Owner.fromJson(Map<String, dynamic> json) => _$OwnerFromJson(json);
  Map<String, dynamic> toJson() => _$OwnerToJson(this);
}
