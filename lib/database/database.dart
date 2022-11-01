import 'package:drift/drift.dart';
import 'package:flutter_github/database/dao/github_starred_dao.dart';

import 'connection/connection.dart' as impl;
import 'dao/github_tags_dao.dart';
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(
    tables: [GithubStarred, GithubStarredTags, GithubTags],
    daos: [GithubTagsDao, GithubStarredDao])
class Database extends _$Database {
  static Database? _instance;

  factory Database.getInstance() => _get();

  static Database _get() {
    _instance ??= Database._connect(impl.connect());
    return _instance!;
  }

  Database._connect(DatabaseConnection connection) : super.connect(connection);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(onCreate: (Migrator m) async {
      await m.createAll();
    }, onUpgrade: (Migrator m, from, to) async {
      if (from < 2) {
        await m.addColumn(githubStarred, githubStarred.tags);
        await m.addColumn(githubStarred, githubStarred.topics);
        await m.createIndex(Index('githubStarredTagName',
            'create index idx_gst_tag on github_starred_tags (name)'));
        await m.createIndex(Index('githubStarredId',
            'create index idx_gst_id on github_starred_tags (github_starred_id)'));
        await m.deleteTable('github_repo_topics');
      }
    });
  }
}
