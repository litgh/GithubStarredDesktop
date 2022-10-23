import 'package:event_bus/event_bus.dart';

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
  String owner;
  String repo;
  RepoSelectEvent(this.owner, this.repo);
}
