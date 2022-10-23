import 'package:drift/drift.dart';
import 'package:flutter_github/database/dao/github_starred_dao.dart';

import 'connection/connection.dart' as impl;
import 'dao/github_tags_dao.dart';
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(
    tables: [GithubStarred, GithubRepoTopics, GithubStarredTags, GithubTags],
    daos: [GithubTagsDao, GithubStarredDao])
class Database extends _$Database {
  Database() : super.connect(impl.connect());

  Database.connect(DatabaseConnection connection) : super.connect(connection);

  @override
  int get schemaVersion => 1;
}
