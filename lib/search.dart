import 'package:flutter/material.dart';
import 'package:flutter_github/constants.dart';
import 'package:flutter_github/provider/app_state_manager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'model/github/repo.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<Repo> _list = [];
  late TextEditingController _textEditingController;
  bool _prev = false;
  bool _next = true;
  int _page = 1;
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
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => context.goNamed('Home'),
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: SizedBox(
            width: w * 0.8,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: w * 0.8,
                    child: TextField(
                      controller: _textEditingController,
                      onSubmitted: (value) {
                        _search(value, 1);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Search..',
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
              const SizedBox(
                height: 10,
              ),
              Expanded(
                  child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 10),
                shrinkWrap: true,
                itemCount: _list.length,
                itemBuilder: ((context, index) {
                  var repo = _list[index];
                  return Row(
                    children: [
                      SizedBox(
                        width: w * 0.2,
                        child: InkWell(
                          child: Text(
                            repo.fullName,
                            style: const TextStyle(
                                color: Colors.blue, fontSize: 16),
                          ),
                          onTap: () {
                            launchUrlString(repo.htmlUrl);
                          },
                        ),
                      ),
                      SizedBox(
                        width: w * 0.01,
                      ),
                      Expanded(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ReadMoreText(
                                repo.description ?? '',
                                style: const TextStyle(fontSize: 15),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Wrap(
                                spacing: 4,
                                runSpacing: 4,
                                children: repo.topics
                                    .map((e) => Chip(
                                          label: Text(e),
                                          backgroundColor: const Color.fromARGB(
                                              255, 221, 244, 255),
                                          labelStyle: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 9, 105, 218)),
                                        ))
                                    .toList(),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(children: [
                                const Icon(
                                  FontAwesomeIcons.star,
                                  size: 15,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(repo.stargazersCount.toString()),
                                Container(
                                  width: 15,
                                  height: 15,
                                  margin:
                                      const EdgeInsets.only(left: 10, right: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(50)),
                                      color: Color(
                                          languageColor(repo.language ?? ''))),
                                ),
                                Text(repo.language ?? '')
                              ]),
                            ]),
                      ),
                      SizedBox(
                        width: w * 0.01,
                      ),
                      SizedBox(
                        width: w * 0.05,
                        child: Row(children: [
                          const Icon(
                            FontAwesomeIcons.star,
                            size: 15,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text('Star')
                        ]),
                      )
                    ],
                  );
                }),
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
              )),
              if (_list.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        child: Text(
                          '< Previous',
                          style: TextStyle(
                              fontSize: 18,
                              color: _prev
                                  ? const Color.fromARGB(255, 9, 105, 218)
                                  : const Color.fromARGB(255, 140, 149, 159)),
                        ),
                        onTap: () {
                          if (_prev) {
                            _search(_textEditingController.text, _page - 1);
                          }
                        },
                      ),
                      Container(
                        width: 30,
                        height: 30,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 9, 105, 218),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Text(
                          '$_page',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      InkWell(
                        child: Text(
                          'Next >',
                          style: TextStyle(
                              fontSize: 18,
                              color: _next
                                  ? const Color.fromARGB(255, 9, 105, 218)
                                  : const Color.fromARGB(255, 140, 149, 159)),
                        ),
                        onTap: () {
                          if (_next) {
                            _search(_textEditingController.text, _page + 1);
                          }
                        },
                      ),
                    ],
                  ),
                )
            ])),
      ),
    );
  }

  void _search(String q, int page) {
    showDialog(
        context: context,
        builder: (_) => const Center(
              child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(),
              ),
            ));
    context.read<AppStateManager>().api.search(q, page, size: 10).then((p) {
      setState(() {
        _list.clear();
        if (p.list != null) {
          _list.addAll(p.list!);
          _next = p.hasNext();
          _prev = p.page > 1;
          _page = page;
        }
      });
      Navigator.of(context).pop();
    });
  }
}
