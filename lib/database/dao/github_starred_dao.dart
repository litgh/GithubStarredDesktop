import 'package:drift/drift.dart';

import '../../model/github/repo.dart';
import '../database.dart';
import '../tables.dart';

part 'github_starred_dao.g.dart';

@DriftAccessor(tables: [GithubStarred])
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
              stargzaersCount: e.stargazersCount)));
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
}
