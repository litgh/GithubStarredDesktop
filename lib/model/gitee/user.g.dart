// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['avatarUrl'] as String,
      json['id'] as int,
      json['login'] as String,
      json['name'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'avatarUrl': instance.avatarUrl,
      'id': instance.id,
      'login': instance.login,
      'name': instance.name,
    };
