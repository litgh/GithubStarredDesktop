import 'dart:isolate';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_github/api/openapi.dart';
import 'package:flutter_github/event.dart';
import 'package:flutter_github/provider/app_state_manager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../database/database.dart';
import '../model/github/repo.dart';
import '../model/page.dart';

class LeftMenu extends StatefulWidget {
  const LeftMenu({Key? key}) : super(key: key);

  @override
  _LeftMenuState createState() => _LeftMenuState();
}

class _LeftMenuState extends State<LeftMenu> with TickerProviderStateMixin {
  final Color _selectedColor = const Color(0xff21a179);
  late final AnimationController _refreshController =
      AnimationController(duration: const Duration(seconds: 2), vsync: this);
  final TextEditingController _addTagController = TextEditingController();

  late ValueNotifier<String> _allStars;
  late ValueNotifier<String> _unTaggedStars;
  String _selected = '';
  bool _openTag = true;
  bool _openLanguage = false;

  List<GithubTag> _allTags = [];
  List<Map<String, Object>> _allLanguages = [];

  @override
  void initState() {
    super.initState();
    _allStars = ValueNotifier<String>('-');
    _unTaggedStars = ValueNotifier<String>('-');

    Database db = context.read<Database>();
    _getStarredCount(db);
    _selectAllTags(db);

    eventBus.on<AddTagEvent>().listen((event) {
      _getStarredCount(db);
      _selectAllTags(db);
    });
    eventBus.on<RemoveTagEvent>().listen((event) {
      _getStarredCount(db);
      _selectAllTags(db);
    });
  }

  _selectAllTags(Database db) async {
    var l = await db.githubTagsDao.findAll('');
    setState(() {
      _allTags = l;
    });
  }

  _selectAllLanguage(Database db) async {
    var l = await db.githubStarredDao.languageAgg();
    setState(() {
      _allLanguages = l;
    });
  }

  _getStarredCount(Database db) async {
    _refreshController.repeat();
    int? taggedStars = await db.githubTagsDao.taggedStars();
    int? totalStars = await db.githubStarredDao.totalCount();
    _allStars.value = '${totalStars ?? 0}';
    _unTaggedStars.value = '${(totalStars ?? 0) - (taggedStars ?? 0)}';
    _refreshController.stop();
  }

  _fetchAndSaveAllStarredRepo(
      Database db, OpenAPI api, void Function(int total, int tagged) cb) async {
    int? tagged = await db.githubTagsDao.taggedStars();
    int total = 0;
    ReceivePort receivePort = ReceivePort();
    var isolate = await Isolate.spawn(_fetch, receivePort.sendPort);
    receivePort.listen((message) {
      if (message == null) {
        receivePort.close();
        isolate.kill(priority: Isolate.immediate);
        cb(total, tagged ?? 0);
        return;
      }
      if (message is SendPort) {
        message.send(api);
      } else if (message is List<Repo>) {
        total += message.length;
        db.githubStarredDao.insertBatch(message);
      }
    });
  }

  static void _fetch(SendPort sendPort) async {
    var ourReceivePort = ReceivePort();
    sendPort.send(ourReceivePort.sendPort);

    var api = await ourReceivePort.first as OpenAPI;
    ourReceivePort.close();

    Pageable<Repo>? page;
    while (page == null || page.hasNext()) {
      page = await api.starred(page?.next() ?? 1, size: 100);
      if (page.list != null) {
        sendPort.send(page.list);
      }
    }
    Isolate.exit(sendPort, null);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _allTags.clear();
    _allLanguages.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff12283a),
      width: 250,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Container(
            padding:
                const EdgeInsets.only(top: 40, left: 15, right: 20, bottom: 10),
            child: Column(
              children: [
                _stars(),
                const SizedBox(
                  height: 10,
                ),
                _allStar(),
                const SizedBox(
                  height: 5,
                ),
                _unTaggedStar(),
                const SizedBox(
                  height: 10,
                ),
                _tags(),
                const SizedBox(
                  height: 5,
                ),
                if (_openTag) ..._allTag(),
                const SizedBox(
                  height: 5,
                ),
                _languages(),
                const SizedBox(
                  height: 5,
                ),
                if (_openLanguage) ..._allLanguage(),
              ],
            )),
      ),
    );
  }

  Widget _stars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'STARS',
          style: TextStyle(
              color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
        ),
        RotationTransition(
          turns: _refreshController,
          child: IconButton(
              constraints: const BoxConstraints(maxWidth: 20, maxHeight: 20),
              onPressed: () {
                if (_refreshController.isAnimating) {
                  return;
                }
                _refreshController.repeat();
                _fetchAndSaveAllStarredRepo(context.read<Database>(),
                    context.read<AppStateManager>().api, (total, tagged) {
                  _allStars.value = total.toString();
                  _unTaggedStars.value = (total - tagged).toString();
                  _refreshController.reset();
                  _refreshController.stop();
                });
              },
              iconSize: 18,
              padding: EdgeInsets.zero,
              color: Colors.grey,
              icon: const Icon(
                Icons.loop,
              )),
        ),
      ],
    );
  }

  Widget _allStar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _myTextButton(
            onPressed: () {
              eventBus.fire(AllStarsEvent());
              setState(() {
                _selected = 'All Stars';
              });
            },
            label: const Text('All Stars'),
            icon: const Icon(
              Icons.star,
              size: 18,
            ),
            style: _selected == 'All Stars'
                ? ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(_selectedColor))
                : null),
        ValueListenableBuilder(
            valueListenable: _allStars,
            builder: (context, value, child) => Badge(
                toAnimate: false,
                shape: BadgeShape.square,
                badgeColor: _selectedColor,
                borderRadius: BorderRadius.circular(10),
                badgeContent: Text(value,
                    style: const TextStyle(color: Colors.white, fontSize: 11))))
      ],
    );
  }

  Widget _unTaggedStar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _myTextButton(
            onPressed: () {
              eventBus.fire(UntaggedStarsEvent());
              setState(() {
                _selected = 'Untagged Stars';
              });
            },
            label: const Text('Untagged Stars'),
            icon: const Icon(
              Icons.star_border,
              size: 18,
            ),
            style: _selected == 'Untagged Stars'
                ? ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(_selectedColor))
                : null),
        ValueListenableBuilder(
            valueListenable: _unTaggedStars,
            builder: (context, value, child) => Badge(
                toAnimate: false,
                shape: BadgeShape.square,
                badgeColor: _selectedColor,
                borderRadius: BorderRadius.circular(10),
                badgeContent: Text(value,
                    style: const TextStyle(color: Colors.white, fontSize: 11))))
      ],
    );
  }

  Widget _tags() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          child: Row(
            children: [
              Icon(
                _openTag
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_right,
                color: Colors.grey,
                size: 18,
              ),
              const Text(
                'TAGS',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              )
            ],
          ),
          onTap: () {
            setState(() {
              _openTag = !_openTag;
            });
          },
        ),
        Row(
          children: const [
            Text(
              'SORT',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w300),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey,
              size: 18,
            )
          ],
        )
      ],
    );
  }

  List<Widget> _allTag() {
    return [
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        _myTextButton(
            onPressed: () {
              _showAddTagDialog(context);
            },
            icon: const Icon(Icons.add_circle_outline, size: 15),
            label: const Text(
              'Add a tag..',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            ))
      ]),
      ..._allTags.map((e) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _myTextButton(
                  onPressed: () {
                    setState(() {
                      _selected = e.name;
                    });
                    eventBus.fire(TagFilterEvent(e.name));
                  },
                  icon: const Icon(FontAwesomeIcons.tag, size: 15),
                  label: Text(e.name),
                  style: _selected == e.name
                      ? ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(_selectedColor))
                      : null),
              Badge(
                  toAnimate: false,
                  shape: BadgeShape.square,
                  badgeColor: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                  badgeContent: Text(e.count.toString(),
                      style:
                          const TextStyle(color: Colors.white, fontSize: 11)))
            ],
          ))
    ];
  }

  List<Widget> _allLanguage() {
    return [
      ..._allLanguages.map((e) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _myTextButton(
                  onPressed: () {
                    setState(() {
                      _selected = (e['l'] as String);
                    });
                    eventBus.fire(LanguageFilterEvent(_selected));
                  },
                  icon: const Icon(Icons.language, size: 15),
                  label: Text(e['l'] as String),
                  style: _selected == (e['l'] as String)
                      ? ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(_selectedColor))
                      : null),
              Badge(
                  toAnimate: false,
                  shape: BadgeShape.square,
                  badgeColor: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                  badgeContent: Text(e['c'].toString(),
                      style:
                          const TextStyle(color: Colors.white, fontSize: 11)))
            ],
          ))
    ];
  }

  Widget _languages() {
    return InkWell(
      child: Row(
        children: [
          Icon(
            _openLanguage
                ? Icons.keyboard_arrow_down
                : Icons.keyboard_arrow_right,
            color: Colors.grey,
            size: 18,
          ),
          const Text(
            'LANGUAGES',
            style: TextStyle(
                color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w400),
          )
        ],
      ),
      onTap: () {
        _openLanguage = !_openLanguage;
        _selectAllLanguage(context.read<Database>());
      },
    );
  }

  Widget _myTextButton(
      {required onPressed, required label, required icon, style, onHover}) {
    return TextButton.icon(
        onPressed: onPressed,
        onHover: onHover,
        label: label,
        icon: icon,
        style: style ??
            ButtonStyle(
                foregroundColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.hovered)) {
                    return Colors.white;
                  }
                  return Colors.grey;
                }),
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.transparent)));
  }

  _showAddTagDialog(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('ADD A TAG'),
            content: TextField(
              controller: _addTagController,
              decoration: const InputDecoration(hintText: 'Enter a tag name..'),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    var db = context.read<Database>();
                    db.githubTagsDao.save(GithubTagsCompanion.insert(
                        name: _addTagController.text, count: 0));
                    _selectAllTags(db);
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                  child: const Text('SUBMIT')),
              TextButton(
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                  child: const Text(
                    'CANCEL',
                    style: TextStyle(color: Colors.grey),
                  )),
            ],
          );
        });
  }
}
