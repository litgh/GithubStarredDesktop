import 'package:event_bus/event_bus.dart';
import 'package:flutter_github/database/database.dart';

var eventBus = EventBus();

class RefreshEvent {}

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

class RepoDeleteEvent {
  GithubStarredData repo;
  RepoDeleteEvent(this.repo);
}

class AllStarsEvent {}

class UntaggedStarsEvent {}

class AddTagEvent {
  GithubStarredData repo;
  GithubStarredTag tag;
  AddTagEvent(this.repo, this.tag);
}

class RemoveTagEvent {
  GithubStarredData repo;
  GithubStarredTag tag;
  RemoveTagEvent(this.repo, this.tag);
}
