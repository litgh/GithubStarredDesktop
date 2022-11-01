import 'package:drift/drift.dart';
import 'package:flutter_github/database/tables.dart';

import '../../model/page.dart';
import '../database.dart';

part 'github_tags_dao.g.dart';

@DriftAccessor(tables: [GithubTags, GithubStarred, GithubStarredTags])
class GithubTagsDao extends DatabaseAccessor<Database>
    with _$GithubTagsDaoMixin {
  GithubTagsDao(Database db) : super(db);

  Future<List<GithubTag>> findAll(String name) {
    final q = select(githubTags);
    if (name.isNotEmpty) {
      q.where((tbl) => tbl.name.lower().like('%${name.toLowerCase()}%'));
    }
    q.orderBy([(t) => OrderingTerm.desc(t.count)]);
    return q.get();
  }

  Future<int> save(GithubTagsCompanion tag) {
    return into(githubTags).insert(tag);
  }

  Future<int?> taggedStars() {
    return customSelect(
        'select count(*) as c from (select github_starred_id from github_starred_tags group by github_starred_id)',
        readsFrom: {
          githubStarredTags
        }).map((row) => row.read<int>('c')).getSingleOrNull();
  }

  Future<Pageable<GithubStarredData>> findByTag(
      String tag, String filter, int page,
      {int size = 20}) async {
    return _findByTag(page, size, githubStarredTags.name.equals(tag));
  }

  Future<Pageable<GithubStarredData>> _findByTag(page, size, where) async {
    var count = githubStarred.id.count();
    var query = selectOnly(githubStarredTags).join([
      innerJoin(githubStarred,
          githubStarredTags.githubStarredId.equalsExp(githubStarred.id),
          useColumns: false)
    ])
      ..where(where);
    query.addColumns([count]);

    var totalCount = await query.map((row) => row.read(count)!).getSingle();
    if (totalCount > 0) {
      query = select(githubStarredTags).join([
        innerJoin(githubStarred,
            githubStarred.id.equalsExp(githubStarredTags.githubStarredId))
      ])
        ..where(where);
      query
        ..orderBy([OrderingTerm.desc(githubStarred.updatedAt)])
        ..limit(size, offset: (page - 1) * size);

      var l = await query.map((row) => row.readTable(githubStarred)).get();
      return Pageable.of(page, size, (totalCount ~/ size) + 1, list: l);
    }
    return Pageable.of(page, size, 0);
  }

  Future<List<GithubStarredTag>> findByGithubStarredId(int id) async {
    final q = select(githubStarredTags)
      ..where((tbl) => tbl.githubStarredId.equals(id));
    return q.get();
  }
}
