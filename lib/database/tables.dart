import 'package:drift/drift.dart';

class GithubStarred extends Table {
  @override
  String get tableName => 'github_starred';
  IntColumn get id => integer()();
  TextColumn get name => text().withLength(max: 255)();
  TextColumn get fullName => text().withLength(max: 255).named('full_name')();
  TextColumn get htmlUrl => text().withLength(max: 512).named('html_url')();
  TextColumn get description => text().nullable()();
  TextColumn get language => text().nullable()();
  TextColumn get owner => text().withLength(max: 512)();
  IntColumn get forksCount => integer().named('forks_count')();
  IntColumn get stargzaersCount => integer().named('stargazers_count')();
  TextColumn get topics => text().nullable().withLength(max: 4096)();
  TextColumn get tags => text().nullable().withLength(max: 4096)();
  DateTimeColumn get createdAt => dateTime().nullable().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().nullable().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};
}

class GithubStarredTags extends Table with AutoIncrement {
  TextColumn get name => text().withLength(max: 64)();
  IntColumn get githubStarredId => integer().named('github_starred_id')();
}

class GithubTags extends Table with AutoIncrement {
  TextColumn get name => text().withLength(max: 255)();
  IntColumn get count => integer()();
}

mixin AutoIncrement on Table {
  IntColumn get id => integer().autoIncrement()();
}
