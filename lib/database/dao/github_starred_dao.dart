import 'package:drift/drift.dart';
import 'package:flutter_github/model/page.dart';

import '../../model/github/repo.dart';
import '../database.dart';
import '../tables.dart';

part 'github_starred_dao.g.dart';

@DriftAccessor(tables: [GithubStarred, GithubStarredTags, GithubTags])
class GithubStarredDao extends DatabaseAccessor<Database>
    with _$GithubStarredDaoMixin {
  GithubStarredDao(Database db) : super(db);

  Future<void> insertBatch(List<Repo>? repos) async {
    if (repos == null || repos.isEmpty) {
      return;
    }
    await batch((batch) {
      batch.insertAllOnConflictUpdate(
          githubStarred,
          repos.map((e) => GithubStarredCompanion.insert(
              id: Value(e.id),
              name: e.name,
              fullName: e.fullName,
              htmlUrl: e.htmlUrl,
              description: e.description == null
                  ? const Value.absent()
                  : Value(e.description),
              language:
                  e.language == null ? const Value.absent() : Value(e.language),
              owner: e.owner.login,
              forksCount: e.forksCount,
              stargzaersCount: e.stargazersCount,
              topics: e.topics.isEmpty
                  ? const Value.absent()
                  : Value(e.topics.join(",")),
              createdAt: Value(DateTime.parse(e.createdAt)),
              updatedAt: Value(DateTime.parse(e.updatedAt)))));
    });
  }

  Future<int?> totalCount() async {
    return customSelect('select count(*) as c from github_starred',
            readsFrom: {githubStarred})
        .map((row) => row.read<int>('c'))
        .getSingleOrNull();
  }

  Future<List<Map<String, Object>>> languageAgg() async {
    return customSelect(
            'select language, count(*) as c from github_starred where language is not null group by language order by c desc',
            readsFrom: {
          githubStarred
        })
        .map((row) =>
            {'l': row.read<String>('language'), 'c': row.read<int>('c')})
        .get();
  }

  Future<Pageable<GithubStarredData>> findAll(String input, int page,
      {int size = 20}) async {
    final count = githubStarred.id.count();
    var countQuery = selectOnly(githubStarred)..addColumns([count]);
    if (input.isNotEmpty) {
      countQuery.where(githubStarred.name.like('%$input%') |
          githubStarred.description.like('%$input%'));
    }
    var totalCount =
        await countQuery.map((row) => row.read(count)!).getSingle();

    if (totalCount > 0) {
      var query = select(githubStarred);
      if (input.isNotEmpty) {
        query.where(
            (tbl) => tbl.name.like('%$input%') | tbl.name.like('%$input%'));
      }
      query
        ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])
        ..limit(size, offset: (page - 1) * size);
      var l = await query.get();
      return Pageable.of(page, size, (totalCount ~/ size) + 1, list: l);
    }
    return Pageable.of(page, size, 0);
  }

  Future<Pageable<GithubStarredData>> findUnStarred(String input, int page,
      {int size = 20}) async {
    final count = githubStarred.id.count();
    final notExist = notExistsQuery(select(githubStarredTags)
      ..where((tbl) => tbl.githubStarredId.equalsExp(githubStarred.id)));
    var countQuery = selectOnly(githubStarred)
      ..addColumns([count])
      ..where(notExist);
    if (input.isNotEmpty) {
      countQuery.where(githubStarred.name.like('%$input%') |
          githubStarred.description.like('%$input%'));
    }
    var totalCount =
        await countQuery.map((row) => row.read(count)!).getSingle();

    if (totalCount > 0) {
      var query = select(githubStarred)..where((tbl) => notExist);
      if (input.isNotEmpty) {
        query.where(
            (tbl) => tbl.name.like('%$input%') | tbl.name.like('%$input%'));
      }
      query
        ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])
        ..limit(size, offset: (page - 1) * size);
      var l = await query.get();
      return Pageable.of(page, size, (totalCount ~/ size) + 1, list: l);
    }
    return Pageable.of(page, size, 0);
  }

  Future<Pageable<GithubStarredData>> findByLanguage(
      String language, String filter, int page,
      {int size = 20}) async {
    return _findByLanguage(page, size, language, filter);
  }

  Future<Pageable<GithubStarredData>> _findByLanguage(
      page, size, lang, String filter) async {
    final count = githubStarred.id.count();
    var countQuery = selectOnly(githubStarred)
      ..addColumns([count])
      ..where(githubStarred.language.equals(lang));
    if (filter.isNotEmpty) {
      countQuery.where(githubStarred.name.like('%$filter%') |
          githubStarred.description.like('%$filter%'));
    }

    var totalCount =
        await countQuery.map((row) => row.read(count)!).getSingle();
    if (totalCount > 0) {
      var query = select(githubStarred)
        ..where((tbl) => tbl.language.equals(lang));
      if (filter.isNotEmpty) {
        query.where((tbl) =>
            tbl.name.like('%$filter%') | tbl.description.like('%$filter%'));
      }
      query
        ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])
        ..limit(size, offset: (page - 1) * size);

      var l = await query.get();
      return Pageable.of(page, size, ((totalCount ~/ size)) + 1, list: l);
    }
    return Pageable.of(page, size, 0);
  }

  Future<List<GithubStarredTag>> findNewTag(int id, String query) async {
    return customSelect('''
select gst.id, t.name from
             github_tags t left join github_starred_tags gst on t.name = gst.name
where ifnull(gst.github_starred_id, 0) != ? and t.name like ? group by t.name
''',
            readsFrom: {githubTags, githubStarredTags},
            variables: [Variable.withInt(id), Variable.withString('%$query%')])
        .map((row) => GithubStarredTag(
            id: row.read<int?>('id') ?? 0,
            name: row.read<String>('name'),
            githubStarredId: 0))
        .get();
  }

  Future<GithubStarredTag> addTag(GithubStarredTag tag) async {
    final row = await into(githubStarredTags).insertReturning(
        GithubStarredTagsCompanion.insert(
            name: tag.name, githubStarredId: tag.githubStarredId));
    final qt = select(githubTags)..where((tbl) => tbl.name.equals(tag.name));
    final t = await qt.getSingleOrNull();
    if (t == null) {
      into(githubTags)
          .insert(GithubTagsCompanion.insert(name: tag.name, count: 1));
    } else {
      (update(githubTags)..where((tbl) => tbl.id.equals(t.id)))
          .write(GithubTagsCompanion(count: Value(t.count + 1)));
    }
    _updateTag(tag.githubStarredId);
    return tag.copyWith(
        id: row.id, name: row.name, githubStarredId: row.githubStarredId);
  }

  void deleteTag(int id, String name) async {
    int c = await (delete(githubStarredTags)
          ..where(
              (tbl) => tbl.githubStarredId.equals(id) & tbl.name.equals(name)))
        .go();
    if (c > 0) {
      _updateTag(id);
      customUpdate('update github_tags set count = count - 1 where name = ?',
          variables: [Variable.withString(name)]);
    }
  }

  void _updateTag(int id) async {
    List<GithubStarredTag> l = await (select(githubStarredTags)
          ..where((tbl) => tbl.githubStarredId.equals(id)))
        .get();

    (update(githubStarred)..where((tbl) => tbl.id.equals(id))).write(
        GithubStarredCompanion(tags: Value(l.map((e) => e.name).join(','))));
  }

  void deleteRepo(int id) async {
    await (delete(githubStarred)..where((tbl) => tbl.id.equals(id))).go();
    await customUpdate(
        'update github_tags set count = count - 1 where name in (select name from github_starred_tags where github_starred_id = ?)',
        variables: [Variable.withInt(id)]);
    await (delete(githubStarredTags)
          ..where((tbl) => tbl.githubStarredId.equals(id)))
        .go();
  }
}
