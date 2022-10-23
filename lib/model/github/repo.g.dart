// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Repo _$RepoFromJson(Map<String, dynamic> json) => Repo(
      id: json['id'] as int,
      nodeId: json['node_id'] as String,
      name: json['name'] as String,
      fullName: json['full_name'] as String,
      owner: Owner.fromJson(json['owner'] as Map<String, dynamic>),
      htmlUrl: json['html_url'] as String,
      description: json['description'] as String?,
      language: json['language'] as String?,
      forksCount: json['forks_count'] as int,
      stargazersCount: json['stargazers_count'] as int,
      watchersCount: json['watchers_count'] as int,
      size: json['size'] as int,
      topics:
          (json['topics'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$RepoToJson(Repo instance) => <String, dynamic>{
      'id': instance.id,
      'node_id': instance.nodeId,
      'name': instance.name,
      'full_name': instance.fullName,
      'owner': instance.owner,
      'html_url': instance.htmlUrl,
      'description': instance.description,
      'language': instance.language,
      'forks_count': instance.forksCount,
      'stargazers_count': instance.stargazersCount,
      'watchers_count': instance.watchersCount,
      'size': instance.size,
      'topics': instance.topics,
    };

Owner _$OwnerFromJson(Map<String, dynamic> json) => Owner(
      json['login'] as String,
      json['avatar_url'] as String,
    );

Map<String, dynamic> _$OwnerToJson(Owner instance) => <String, dynamic>{
      'login': instance.login,
      'avatar_url': instance.avatarUrl,
    };
