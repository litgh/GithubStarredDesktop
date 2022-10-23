import 'package:drift/drift.dart';
import 'package:flutter_github/database/tables.dart';

import '../../model/page.dart';
import '../database.dart';

part 'github_tags_dao.g.dart';

@DriftAccessor(
    tables: [GithubTags, GithubRepoTopics, GithubStarred, GithubStarredTags])
class GithubTagsDao extends DatabaseAccessor<Database>
    with _$GithubTagsDaoMixin {
  GithubTagsDao(Database db) : super(db);

  Future<List<GithubTag>> findAll() {
    return select(githubTags).get();
  }

  Future<int> save(GithubTagsCompanion tag) {
    return into(githubTags).insert(tag);
  }

  Future<int?> taggedStars() {
    return customSelect(
        'select count(*) as c from github_starred_tags group by github_starred_id',
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
      query.limit(size, offset: (page - 1) * size);

      var l = await query.map((row) => row.readTable(githubStarred)).get();
      return Pageable.of(page, size, (totalCount ~/ size) + 1, list: l);
    }
    return Pageable.of(page, size, 0);
  }

  Future<Pageable<GithubStarredData>> findByLanguage(
      String language, String filter, int page,
      {int size = 20}) async {
    return _findByLanguage(page, size, language);
  }

  Future<Pageable<GithubStarredData>> _findByLanguage(page, size, lang) async {
    final count = githubStarred.id.count();
    var countQuery = selectOnly(githubStarred)
      ..addColumns([count])
      ..where(githubStarred.language.equals(lang));

    var totalCount =
        await countQuery.map((row) => row.read(count)!).getSingle();
    if (totalCount > 0) {
      var query = select(githubStarred)
        ..where((tbl) => tbl.language.equals(lang))
        ..limit(size, offset: (page - 1) * size);
      var l = await query.get();
      return Pageable.of(page, size, ((totalCount ~/ size)) + 1, list: l);
    }
    return Pageable.of(page, size, 0);
  }
}
