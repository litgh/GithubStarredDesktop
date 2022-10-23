import 'package:flutter/material.dart';
import 'package:flutter_github/event.dart';
import 'package:provider/provider.dart';

import '../database/database.dart';

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
  String _filter = '';
  String _filterValue = '';
  String _loadingText = '数据加载中...';

  @override
  void initState() {
    super.initState();
    Database db = context.read<Database>();
    eventBus.on<TagFilterEvent>().listen((event) async {
      _filter = 'TAG';
      _page = 1;
      _filterValue = event.tag;
      _search(db, event.tag, 1);
    });
    eventBus.on<LanguageFilterEvent>().listen((event) async {
      _filter = 'LANGUAGE';
      _page = 1;
      _filterValue = event.language;
      _search(db, event.language, 1);
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
      case 'TAG':
        var p = await db.githubTagsDao.findByTag(_filterValue, input, page);
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
        break;
      case 'LANGUAGE':
        var p =
            await db.githubTagsDao.findByLanguage(_filterValue, input, page);
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
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
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
                    itemBuilder: _card,
                    itemCount: list.length + 1,
                    shrinkWrap: true,
                  ))
      ]),
    );
  }

  Widget _card(BuildContext context, int index) {
    if (index < list.length) {
      var repo = list[index];
      return InkWell(
          onTap: () {
            eventBus.fire(RepoSelectEvent(repo.owner, repo.name));
          },
          child: ListTile(
            contentPadding: const EdgeInsets.only(top: 10, left: 5, right: 5),
            title: Text(
              repo.fullName,
              style: const TextStyle(
                color: Color(0xff21a179),
              ),
            ),
            subtitle: Text(repo.description ?? ''),
          ));
    } else if (_page >= 0) {
      _page++;
      _search(context.read<Database>(), _searchController.text, _page);
    }
    return Center(
      child: Text(_loadingText),
    );
  }
}
