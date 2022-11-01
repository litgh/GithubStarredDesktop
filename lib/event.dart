import 'package:event_bus/event_bus.dart';
import 'package:flutter_github/database/database.dart';

import 'model/github/repo.dart';

var eventBus = EventBus();

class TagFilterEvent {
  String tag;
  TagFilterEvent(this.tag);
}

class LanguageFilterEvent {
  String language;
  LanguageFilterEvent(this.language);
}

class RepoSelectEvent {
  GithubStarredData repo;
  RepoSelectEvent(this.repo);
}

class AllStarsEvent {}

class UntaggedStarsEvent {}

class AddTagEvent {}

class RemoveTagEvent {}
