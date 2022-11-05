import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_github/event.dart';
import 'package:flutter_github/provider/app_state_manager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../database/database.dart';

final Color _selectedColor = const Color(0xff21a179);

class RepoCard extends StatefulWidget {
  GithubStarredData repo;
  RepoCard({required this.repo, Key? key}) : super(key: key);

  @override
  _RepoCardState createState() => _RepoCardState();
}

class _RepoCardState extends State<RepoCard> {
  bool _selected = false;
  bool _showDelIcon = false;
  final Set<_Tag> _tags = {};
  @override
  void initState() {
    super.initState();
    eventBus.on<AddTagEvent>().listen((event) {
      if (event.repo.id == widget.repo.id) {
        if (mounted) {
          setState(() {
            _tags.add(_Tag(event.tag.name, 'T'));
          });
        }
      }
    });
    eventBus.on<RemoveTagEvent>().listen((event) {
      if (event.repo.id == widget.repo.id) {
        if (mounted) {
          setState(() {
            _tags.remove(event.tag.name);
          });
        }
      }
    });
    eventBus.on<RepoSelectEvent>().listen((event) {
      if (event.repo.id != widget.repo.id && _selected) {
        if (mounted) {
          setState(() {
            _selected = false;
          });
        }
      }
    });
    if (widget.repo.language != null) {
      _tags.add(_Tag(widget.repo.language!, 'L'));
    }
    if (widget.repo.tags != null && widget.repo.tags != '') {
      _tags.addAll(
          widget.repo.tags!.split(',').map((e) => _Tag(e, 'T')).toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    var timeAgo = '';
    if (widget.repo.updatedAt != null) {
      var d = DateTime.now().difference(widget.repo.updatedAt!);
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
          eventBus.fire(RepoSelectEvent(widget.repo));
          setState(() {
            _selected = true;
          });
        },
        onHover: (value) {
          setState(() {
            _showDelIcon = !_showDelIcon;
          });
        },
        child: Stack(children: [
          Container(
              decoration: BoxDecoration(
                  border: _selected
                      ? Border(
                          left: BorderSide(width: 5, color: _selectedColor))
                      : null),
              child: Card(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.all(8),
                    title: Text(
                      widget.repo.fullName,
                      style: TextStyle(fontSize: 20, color: _selectedColor),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 10),
                      child: Text(
                        widget.repo.description ?? '',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                    style: ListTileStyle.drawer,
                  ),
                  if (_tags.isNotEmpty) _repoTag(),
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
                        widget.repo.stargzaersCount.toString(),
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
                        widget.repo.forksCount.toString(),
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
              ))),
          Positioned(
            top: 5,
            right: 10,
            child: Visibility(
              visible: _showDelIcon,
              child: InkWell(
                onTap: () {
                  _showDeleteDialog(context);
                },
                child: Container(
                  width: 25,
                  height: 25,
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  child: const Icon(
                    Icons.clear,
                    size: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ]));
  }

  _showDeleteDialog(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text('Are you sure you want to delete this Repo?'),
            actions: [
              TextButton(
                  onPressed: () {
                    var db = context.read<Database>();
                    db.githubStarredDao.deleteRepo(widget.repo.id);
                    var api = context.read<AppStateManager>().api;
                    api
                        .unStarred(widget.repo.owner, widget.repo.name)
                        .then((value) {
                      eventBus.fire(RefreshEvent());
                      eventBus.fire(RepoDeleteEvent(widget.repo));
                    });
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                  child: const Text('YES')),
              TextButton(
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                  child: const Text(
                    'NO',
                    style: TextStyle(color: Colors.grey),
                  )),
            ],
          );
        });
  }

  Widget _repoTag() {
    if (_tags.isEmpty) {
      return Container();
    }
    return Container(
      padding: const EdgeInsets.all(8),
      alignment: Alignment.topLeft,
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: _tags
            .map((e) => Badge(
                toAnimate: false,
                shape: BadgeShape.square,
                padding:
                    const EdgeInsets.only(top: 5, left: 8, bottom: 5, right: 8),
                badgeColor: e.type == 'L'
                    ? Color(languageColor(widget.repo.language))
                    : _selectedColor,
                borderRadius: BorderRadius.circular(10),
                badgeContent: Text(e.name,
                    style: const TextStyle(color: Colors.white, fontSize: 11))))
            .toList(),
      ),
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
}

class _Tag {
  String name;
  String type;
  _Tag(this.name, this.type);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is _Tag) {
      return runtimeType == other.runtimeType &&
          name == other.name &&
          type == other.type;
    }
    return false;
  }

  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + name.hashCode;
    result = 37 * result + type.hashCode;
    return result;
  }
}
