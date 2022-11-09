import 'package:flutter/material.dart';
import 'package:flutter_github/constants.dart';
import 'package:flutter_github/provider/app_state_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'model/github/repo.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<Repo> _list = [];
  late TextEditingController _textEditingController;
  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => context.goNamed('Home'),
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: SizedBox(
            width: 600,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _textEditingController,
                      onSubmitted: (value) async {
                        var p = await context
                            .read<AppStateManager>()
                            .api
                            .search(value, 1);
                        setState(() {
                          _list.clear();
                          if (p.list != null) {
                            _list.addAll(p.list!);
                          }
                        });
                      },
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.search),
                        contentPadding: EdgeInsets.only(left: 10),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                  child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 10),
                shrinkWrap: true,
                itemCount: _list.length,
                itemBuilder: ((context, index) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(
                          _list[index].fullName,
                          style: TextStyle(fontSize: 20, color: Colors.blue),
                        ),
                        subtitle: Text(
                          _list[index].description ?? '',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_border,
                            size: 20,
                          ),
                          Text(_list[index].stargazersCount.toString()),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Color(
                                    languageColor(_list[index].language ?? '')),
                              )),
                          SizedBox(
                            width: 5,
                          ),
                          Text(_list[index].language ?? '')
                        ],
                      )
                    ],
                  );
                }),
                separatorBuilder: (BuildContext context, int index) {
                  return Divider();
                },
              ))
            ])),
      ),
    );
  }
}
