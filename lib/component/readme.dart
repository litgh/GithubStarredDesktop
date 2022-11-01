import 'dart:convert';

import 'package:chips_input/chips_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_github/database/database.dart';
import 'package:flutter_github/event.dart';
import 'package:flutter_github/provider/app_state_manager.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

final Color _selectedColor = const Color(0xff21a179);

class Readme extends StatefulWidget {
  Readme({Key? key}) : super(key: key);

  @override
  _ReadmeState createState() => _ReadmeState();
}

class _ReadmeState extends State<Readme> {
  final space = '\u200B';
  final _hintText = 'Add a tag';

  String readme = '';
  GithubStarredData? _repo;
  Set<GithubStarredTag> _tags = <GithubStarredTag>{};
  bool _editTag = false;

  GlobalKey<ChipsInputState> _editTagKey = GlobalKey();
  late FocusNode _editTagFocus;
  late TextEditingController _editTagController;

  @override
  void initState() {
    _editTagFocus = FocusNode();
    _editTagController = TextEditingController();

    var api = context.read<AppStateManager>().api;
    var db = context.read<Database>();

    eventBus.on<RepoSelectEvent>().listen((event) async {
      _repo = event.repo;
      _tags.clear();

      var l = await db.githubTagsDao.findByGithubStarredId(event.repo.id);

      var md = await api.readme(event.repo.owner, event.repo.name);
      md = md.replaceAll(RegExp(r'\n'), '');
      setState(() {
        readme = utf8.decode(base64.decode(md));
        _tags.addAll(l);
        _editTag = false;
      });
    });

    _editTagController.addListener(() {
      final str = _editTagController.text.replaceAll("$space", "");
      if (str == _hintText || str.isEmpty) {
        _editTagController.value = _editTagController.value.copyWith(
          text: _editTagController.text,
          selection: const TextSelection.collapsed(offset: 0),
          composing: TextRange.empty,
        );
      } else if (str.endsWith(_hintText)) {
        _editTagController.value = _editTagController.value.copyWith(
          text: _editTagController.text.replaceAll(_hintText, ''),
          composing: TextRange.empty,
        );
      }
    });

    _editTagFocus.addListener(() {
      if (!_editTagFocus.hasFocus && _tags.isEmpty) {
        setState(() {
          _editTag = false;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _editTagFocus.dispose();
    _editTagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _repo == null
        ? Container(
            alignment: Alignment.center,
            child: const Text('No Repo Selected'),
          )
        : Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 15, top: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        onTap: () async {
                          await launchUrlString(_repo!.htmlUrl);
                        },
                        child: Text(_repo!.fullName,
                            style: const TextStyle(
                                color: Color(0xff0969da),
                                fontSize: 25,
                                fontWeight: FontWeight.w400)),
                      ),
                    ),
                    if (_editTag) _editTags(),
                    if (!_editTag) _displayTags(),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
              const Divider(
                height: 2,
              ),
              Expanded(
                  child: Markdown(
                      onTapLink: (text, href, title) async {
                        if (href != null && await canLaunchUrlString(href)) {
                          await launchUrlString(href);
                        }
                      },
                      styleSheet: MarkdownStyleSheet(
                          p: const TextStyle(
                              fontFamily: 'monospace', fontSize: 15),
                          code: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 15,
                              color: Color(0xff3d4852)),
                          codeblockDecoration: BoxDecoration(
                              border: Border.all(color: Colors.black26))),
                      data: readme,
                      imageBuilder: (uri, title, alt) {
                        if (uri.scheme == 'http' || uri.scheme == 'https') {
                          if (uri.path.endsWith('svg')) {
                            return SvgPicture.network(uri.toString());
                          }
                          return Image.network(uri.toString());
                        }
                        return const SizedBox();
                      }))
            ],
          );
  }

  Widget _displayTags() {
    var textButton = InkWell(
        hoverColor: Colors.transparent,
        onTap: () {
          setState(() {
            _editTag = true;
            _editTagFocus.requestFocus();
            _editTagController.text = _hintText;
          });
        },
        child: const Chip(
            backgroundColor: Color(0xfff1f5f8),
            label: Text(
              'Edit Tag',
              style: TextStyle(color: Colors.black45),
            )));

    if (_tags.isNotEmpty) {
      return Wrap(
        spacing: 4,
        runSpacing: 4,
        children: [
          ..._tags
              .map((e) => Chip(
                    label: Text(e.name),
                  ))
              .toList(),
          textButton
        ],
      );
    }
    return textButton;
  }

  Widget _editTags() {
    return ChipsInput(
      key: _editTagKey,
      focusNode: _editTagFocus,
      controller: _editTagController,
      decoration: InputDecoration(hintText: _hintText),
      initialValue: _tags.toList(),
      chipBuilder: ((context, state, data) {
        return InputChip(
            label: Text(data.name),
            onDeleted: () {
              state.deleteChip(data);
              _editTagFocus.requestFocus();
              context
                  .read<Database>()
                  .githubStarredDao
                  .deleteTag(_repo!.id, data.name);
              eventBus.fire(RemoveTagEvent());
            });
      }),
      onChanged: (value) async {
        _editTagFocus.requestFocus();
        if (value.isEmpty) {
          _tags.clear();
          return;
        }
        final v = await context.read<Database>().githubStarredDao.addTag(value
            .last
            .copyWith(name: value.last.name, githubStarredId: _repo!.id));
        _tags.add(v);
        eventBus.fire(AddTagEvent());
      },
      onEditingComplete: () {
        setState(() {
          _editTag = false;
        });
      },
      findSuggestions: (query) async {
        if (query.endsWith(_hintText) || query.isEmpty) {
          return <GithubStarredTag>[];
        }
        List<GithubStarredTag> l = await context
            .read<Database>()
            .githubStarredDao
            .findNewTag(_repo!.id, query);
        if (l.isEmpty) {
          return <GithubStarredTag>[
            GithubStarredTag(id: 0, name: query, githubStarredId: 0)
          ];
        }
        if (l
            .where(
                (element) => element.name.toLowerCase() == query.toLowerCase())
            .isEmpty) {
          return [
            ...l,
            GithubStarredTag(id: 0, name: query, githubStarredId: 0)
          ];
        }
        return l;
      },
      suggestionBuilder: (context, data) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(data.name),
          leading: data.id == 0
              ? const Icon(
                  Icons.add,
                )
              : null,
        );
      },
    );
  }
}
