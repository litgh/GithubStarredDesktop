import 'package:flutter/material.dart';
import 'package:flutter_github/event.dart';
import 'package:flutter_github/model/page.dart';
import 'package:provider/provider.dart';

import '../database/database.dart';
import 'repo_card.dart';

enum Filter { none, tag, lang, starred, unStarred }

final Color _selectedColor = const Color(0xff21a179);

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  List<GithubStarredData> list = [];
  int _page = 1;
  Filter _filter = Filter.none;
  String _filterValue = '';
  String _loadingText = 'Loading...';

  @override
  void initState() {
    super.initState();
    Database db = context.read<Database>();
    eventBus.on<TagFilterEvent>().listen((event) async {
      _filter = Filter.tag;
      _page = 1;
      _filterValue = event.tag;
      _search(db, '', 1);
    });
    eventBus.on<LanguageFilterEvent>().listen((event) async {
      _filter = Filter.lang;
      _page = 1;
      _filterValue = event.language;
      _search(db, '', 1);
    });
    eventBus.on<AllStarsEvent>().listen((event) async {
      _filter = Filter.starred;
      _page = 1;
      _search(db, '', 1);
    });
    eventBus.on<UntaggedStarsEvent>().listen((event) async {
      _filter = Filter.unStarred;
      _page = 1;
      _search(db, '', 1);
    });
    eventBus.on<RepoDeleteEvent>().listen((event) async {
      list.remove(event.repo);
      if (mounted) {
        setState(() {});
      }
    });
    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels ==
    //       _scrollController.position.maxScrollExtent) {
    //     _page++;
    //     _search(db, _searchController.text, _page);
    //   }
    // });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  _search(Database db, String input, int page) async {
    switch (_filter) {
      case Filter.tag:
        var p = await db.githubTagsDao.findByTag(_filterValue, input, page);
        _setState(p, page);
        break;
      case Filter.lang:
        var p =
            await db.githubStarredDao.findByLanguage(_filterValue, input, page);
        _setState(p, page);
        break;
      case Filter.starred:
        var p = await db.githubStarredDao.findAll(input, page);
        _setState(p, page);
        break;
      case Filter.unStarred:
        var p = await db.githubStarredDao.findUnStarred(input, page);
        _setState(p, page);
        break;
      default:
    }
  }

  _setState(Pageable<GithubStarredData> p, int page) {
    setState(() {
      if (page > 1) {
        list.addAll(p.list ?? []);
      } else {
        list = p.list ?? [];
      }
      if (!p.hasNext()) {
        _page = -1;
        _loadingText = 'No more data..';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(right: BorderSide(color: Colors.grey))),
      padding: const EdgeInsets.all(3),
      child: Column(children: [
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            enabledBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            focusedBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            prefixIcon: const Icon(Icons.search),
            hintText: 'Find..',
          ),
          onSubmitted: (value) {
            _page = 1;
            _search(context.read<Database>(), value, 1);
          },
        ),
        const Divider(),
        Expanded(
            child: list.isEmpty
                ? const Text('No Results')
                : ListView.builder(
                    controller: _scrollController,
                    itemBuilder: _repoCard,
                    itemCount: list.length + 1,
                    shrinkWrap: true,
                  ))
      ]),
    );
  }

  Widget _repoCard(BuildContext context, int index) {
    if (index < list.length) {
      var repo = list[index];
      return RepoCard(
        repo: repo,
        key: ValueKey(repo.id),
      );
    } else if (_page >= 0) {
      _page++;
      _search(context.read<Database>(), _searchController.text, _page);
    }
    if (list.length < 20) {
      return Container();
    }
    return Center(
      child: Text(_loadingText),
    );
  }
}
