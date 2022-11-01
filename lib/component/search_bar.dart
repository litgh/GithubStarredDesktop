import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_github/event.dart';
import 'package:flutter_github/model/page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../database/database.dart';

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
  String _loadingText = '数据加载中...';
  int _selectRepo = -1;

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
      var timeAgo = '';
      if (repo.updatedAt != null) {
        var d = DateTime.now().difference(repo.updatedAt!);
        if (d.inDays > 0) {
          timeAgo = '${d.inDays}d ago';
        } else if (d.inHours > 0) {
          timeAgo = '${d.inHours}h ago';
        } else if (d.inMinutes > 0) {
          timeAgo = '${d.inMinutes}m ago';
        }
      }
      return InkWell(
          onTap: () {
            eventBus.fire(RepoSelectEvent(repo));
            setState(() {
              _selectRepo = index;
            });
          },
          child: Container(
              decoration: BoxDecoration(
                  border: _selectRepo == index
                      ? Border(
                          left: BorderSide(width: 5, color: _selectedColor))
                      : null),
              child: Card(
                  child: Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.all(8),
                    title: Text(
                      repo.fullName,
                      style: TextStyle(fontSize: 20, color: _selectedColor),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 10),
                      child: Text(
                        repo.description ?? '',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                    style: ListTileStyle.drawer,
                  ),
                  if (repo.tags != null) _repoTag(repo),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 5, right: 2),
                        child: Icon(
                          Icons.star_border,
                          size: 18,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        repo.stargzaersCount.toString(),
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 11),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 5, right: 3),
                        child: Icon(
                          FontAwesomeIcons.codeFork,
                          size: 13,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        repo.forksCount.toString(),
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 11),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 5, right: 3),
                        child: Icon(
                          Icons.calendar_month,
                          size: 18,
                          color: Colors.grey,
                        ),
                      ),
                      if (timeAgo.isNotEmpty)
                        Text(timeAgo,
                            style: const TextStyle(
                                fontSize: 11, color: Colors.grey))
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  )
                ],
              ))));
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

  Widget _topic(GithubStarredData repo) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: repo.topics!
          .split(',')
          .map((e) => Chip(
                backgroundColor: Colors.blue[50],
                label: Text(e),
                labelStyle: TextStyle(color: Colors.blue[500], fontSize: 12),
              ))
          .toList(),
    );
  }

  Widget _repoTag(GithubStarredData repo) {
    if ((repo.tags ?? '').isEmpty) {
      return Container();
    }
    return Container(
      width: 300,
      padding: const EdgeInsets.all(8),
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: repo.tags!
            .split(',')
            .map((e) => Badge(
                toAnimate: false,
                shape: BadgeShape.square,
                badgeColor: _selectedColor,
                borderRadius: BorderRadius.circular(10),
                badgeContent: Text(e,
                    style: const TextStyle(color: Colors.white, fontSize: 11))))
            .toList(),
      ),
    );
  }
}
