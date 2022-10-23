import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_github/event.dart';
import 'package:flutter_github/provider/app_state_manager.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';

class Readme extends StatefulWidget {
  Readme({Key? key}) : super(key: key);

  @override
  _ReadmeState createState() => _ReadmeState();
}

class _ReadmeState extends State<Readme> {
  String readme = '';

  @override
  void initState() {
    super.initState();
    var api = context.read<AppStateManager>().api;
    eventBus.on<RepoSelectEvent>().listen((event) async {
      var md = await api.readme(event.owner, event.repo);
      md = md.replaceAll(RegExp(r'\n'), '');
      print(md);
      setState(() {
        readme = utf8.decode(base64.decode(md));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return (readme.isEmpty)
        ? Expanded(
            child: Container(
            alignment: Alignment.center,
            child: const Text('No Repo Selected'),
          ))
        : Expanded(child: Markdown(data: readme));
  }
}
