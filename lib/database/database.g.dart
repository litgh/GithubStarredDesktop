// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// DriftDatabaseGenerator
// **************************************************************************

// ignore_for_file: type=lint
class GithubStarredData extends DataClass
    implements Insertable<GithubStarredData> {
  final int id;
  final String name;
  final String fullName;
  final String htmlUrl;
  final String? description;
  final String? language;
  final String owner;
  final int forksCount;
  final int stargzaersCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const GithubStarredData(
      {required this.id,
      required this.name,
      required this.fullName,
      required this.htmlUrl,
      this.description,
      this.language,
      required this.owner,
      required this.forksCount,
      required this.stargzaersCount,
      this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['full_name'] = Variable<String>(fullName);
    map['html_url'] = Variable<String>(htmlUrl);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || language != null) {
      map['language'] = Variable<String>(language);
    }
    map['owner'] = Variable<String>(owner);
    map['forks_count'] = Variable<int>(forksCount);
    map['stargazers_count'] = Variable<int>(stargzaersCount);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  GithubStarredCompanion toCompanion(bool nullToAbsent) {
    return GithubStarredCompanion(
      id: Value(id),
      name: Value(name),
      fullName: Value(fullName),
      htmlUrl: Value(htmlUrl),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      language: language == null && nullToAbsent
          ? const Value.absent()
          : Value(language),
      owner: Value(owner),
      forksCount: Value(forksCount),
      stargzaersCount: Value(stargzaersCount),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory GithubStarredData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GithubStarredData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      fullName: serializer.fromJson<String>(json['fullName']),
      htmlUrl: serializer.fromJson<String>(json['htmlUrl']),
      description: serializer.fromJson<String?>(json['description']),
      language: serializer.fromJson<String?>(json['language']),
      owner: serializer.fromJson<String>(json['owner']),
      forksCount: serializer.fromJson<int>(json['forksCount']),
      stargzaersCount: serializer.fromJson<int>(json['stargzaersCount']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'fullName': serializer.toJson<String>(fullName),
      'htmlUrl': serializer.toJson<String>(htmlUrl),
      'description': serializer.toJson<String?>(description),
      'language': serializer.toJson<String?>(language),
      'owner': serializer.toJson<String>(owner),
      'forksCount': serializer.toJson<int>(forksCount),
      'stargzaersCount': serializer.toJson<int>(stargzaersCount),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  GithubStarredData copyWith(
          {int? id,
          String? name,
          String? fullName,
          String? htmlUrl,
          Value<String?> description = const Value.absent(),
          Value<String?> language = const Value.absent(),
          String? owner,
          int? forksCount,
          int? stargzaersCount,
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      GithubStarredData(
        id: id ?? this.id,
        name: name ?? this.name,
        fullName: fullName ?? this.fullName,
        htmlUrl: htmlUrl ?? this.htmlUrl,
        description: description.present ? description.value : this.description,
        language: language.present ? language.value : this.language,
        owner: owner ?? this.owner,
        forksCount: forksCount ?? this.forksCount,
        stargzaersCount: stargzaersCount ?? this.stargzaersCount,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('GithubStarredData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('fullName: $fullName, ')
          ..write('htmlUrl: $htmlUrl, ')
          ..write('description: $description, ')
          ..write('language: $language, ')
          ..write('owner: $owner, ')
          ..write('forksCount: $forksCount, ')
          ..write('stargzaersCount: $stargzaersCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, fullName, htmlUrl, description,
      language, owner, forksCount, stargzaersCount, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GithubStarredData &&
          other.id == this.id &&
          other.name == this.name &&
          other.fullName == this.fullName &&
          other.htmlUrl == this.htmlUrl &&
          other.description == this.description &&
          other.language == this.language &&
          other.owner == this.owner &&
          other.forksCount == this.forksCount &&
          other.stargzaersCount == this.stargzaersCount &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class GithubStarredCompanion extends UpdateCompanion<GithubStarredData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> fullName;
  final Value<String> htmlUrl;
  final Value<String?> description;
  final Value<String?> language;
  final Value<String> owner;
  final Value<int> forksCount;
  final Value<int> stargzaersCount;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  const GithubStarredCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.fullName = const Value.absent(),
    this.htmlUrl = const Value.absent(),
    this.description = const Value.absent(),
    this.language = const Value.absent(),
    this.owner = const Value.absent(),
    this.forksCount = const Value.absent(),
    this.stargzaersCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  GithubStarredCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String fullName,
    required String htmlUrl,
    this.description = const Value.absent(),
    this.language = const Value.absent(),
    required String owner,
    required int forksCount,
    required int stargzaersCount,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : name = Value(name),
        fullName = Value(fullName),
        htmlUrl = Value(htmlUrl),
        owner = Value(owner),
        forksCount = Value(forksCount),
        stargzaersCount = Value(stargzaersCount);
  static Insertable<GithubStarredData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? fullName,
    Expression<String>? htmlUrl,
    Expression<String>? description,
    Expression<String>? language,
    Expression<String>? owner,
    Expression<int>? forksCount,
    Expression<int>? stargzaersCount,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (fullName != null) 'full_name': fullName,
      if (htmlUrl != null) 'html_url': htmlUrl,
      if (description != null) 'description': description,
      if (language != null) 'language': language,
      if (owner != null) 'owner': owner,
      if (forksCount != null) 'forks_count': forksCount,
      if (stargzaersCount != null) 'stargazers_count': stargzaersCount,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  GithubStarredCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? fullName,
      Value<String>? htmlUrl,
      Value<String?>? description,
      Value<String?>? language,
      Value<String>? owner,
      Value<int>? forksCount,
      Value<int>? stargzaersCount,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt}) {
    return GithubStarredCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      fullName: fullName ?? this.fullName,
      htmlUrl: htmlUrl ?? this.htmlUrl,
      description: description ?? this.description,
      language: language ?? this.language,
      owner: owner ?? this.owner,
      forksCount: forksCount ?? this.forksCount,
      stargzaersCount: stargzaersCount ?? this.stargzaersCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (htmlUrl.present) {
      map['html_url'] = Variable<String>(htmlUrl.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (owner.present) {
      map['owner'] = Variable<String>(owner.value);
    }
    if (forksCount.present) {
      map['forks_count'] = Variable<int>(forksCount.value);
    }
    if (stargzaersCount.present) {
      map['stargazers_count'] = Variable<int>(stargzaersCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GithubStarredCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('fullName: $fullName, ')
          ..write('htmlUrl: $htmlUrl, ')
          ..write('description: $description, ')
          ..write('language: $language, ')
          ..write('owner: $owner, ')
          ..write('forksCount: $forksCount, ')
          ..write('stargzaersCount: $stargzaersCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $GithubStarredTable extends GithubStarred
    with TableInfo<$GithubStarredTable, GithubStarredData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GithubStarredTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  final VerificationMeta _fullNameMeta = const VerificationMeta('fullName');
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
      'full_name', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  final VerificationMeta _htmlUrlMeta = const VerificationMeta('htmlUrl');
  @override
  late final GeneratedColumn<String> htmlUrl = GeneratedColumn<String>(
      'html_url', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 512),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  final VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  final VerificationMeta _languageMeta = const VerificationMeta('language');
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
      'language', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  final VerificationMeta _ownerMeta = const VerificationMeta('owner');
  @override
  late final GeneratedColumn<String> owner = GeneratedColumn<String>(
      'owner', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 512),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  final VerificationMeta _forksCountMeta = const VerificationMeta('forksCount');
  @override
  late final GeneratedColumn<int> forksCount = GeneratedColumn<int>(
      'forks_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  final VerificationMeta _stargzaersCountMeta =
      const VerificationMeta('stargzaersCount');
  @override
  late final GeneratedColumn<int> stargzaersCount = GeneratedColumn<int>(
      'stargazers_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        fullName,
        htmlUrl,
        description,
        language,
        owner,
        forksCount,
        stargzaersCount,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? 'github_starred';
  @override
  String get actualTableName => 'github_starred';
  @override
  VerificationContext validateIntegrity(Insertable<GithubStarredData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(_fullNameMeta,
          fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta));
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('html_url')) {
      context.handle(_htmlUrlMeta,
          htmlUrl.isAcceptableOrUnknown(data['html_url']!, _htmlUrlMeta));
    } else if (isInserting) {
      context.missing(_htmlUrlMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('language')) {
      context.handle(_languageMeta,
          language.isAcceptableOrUnknown(data['language']!, _languageMeta));
    }
    if (data.containsKey('owner')) {
      context.handle(
          _ownerMeta, owner.isAcceptableOrUnknown(data['owner']!, _ownerMeta));
    } else if (isInserting) {
      context.missing(_ownerMeta);
    }
    if (data.containsKey('forks_count')) {
      context.handle(
          _forksCountMeta,
          forksCount.isAcceptableOrUnknown(
              data['forks_count']!, _forksCountMeta));
    } else if (isInserting) {
      context.missing(_forksCountMeta);
    }
    if (data.containsKey('stargazers_count')) {
      context.handle(
          _stargzaersCountMeta,
          stargzaersCount.isAcceptableOrUnknown(
              data['stargazers_count']!, _stargzaersCountMeta));
    } else if (isInserting) {
      context.missing(_stargzaersCountMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GithubStarredData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GithubStarredData(
      id: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      fullName: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}full_name'])!,
      htmlUrl: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}html_url'])!,
      description: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      language: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}language']),
      owner: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}owner'])!,
      forksCount: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}forks_count'])!,
      stargzaersCount: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}stargazers_count'])!,
      createdAt: attachedDatabase.options.types
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.options.types
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $GithubStarredTable createAlias(String alias) {
    return $GithubStarredTable(attachedDatabase, alias);
  }
}

class GithubRepoTopic extends DataClass implements Insertable<GithubRepoTopic> {
  final int id;
  final String name;
  final int githubStarredId;
  const GithubRepoTopic(
      {required this.id, required this.name, required this.githubStarredId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['github_starred_id'] = Variable<int>(githubStarredId);
    return map;
  }

  GithubRepoTopicsCompanion toCompanion(bool nullToAbsent) {
    return GithubRepoTopicsCompanion(
      id: Value(id),
      name: Value(name),
      githubStarredId: Value(githubStarredId),
    );
  }

  factory GithubRepoTopic.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GithubRepoTopic(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      githubStarredId: serializer.fromJson<int>(json['githubStarredId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'githubStarredId': serializer.toJson<int>(githubStarredId),
    };
  }

  GithubRepoTopic copyWith({int? id, String? name, int? githubStarredId}) =>
      GithubRepoTopic(
        id: id ?? this.id,
        name: name ?? this.name,
        githubStarredId: githubStarredId ?? this.githubStarredId,
      );
  @override
  String toString() {
    return (StringBuffer('GithubRepoTopic(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('githubStarredId: $githubStarredId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, githubStarredId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GithubRepoTopic &&
          other.id == this.id &&
          other.name == this.name &&
          other.githubStarredId == this.githubStarredId);
}

class GithubRepoTopicsCompanion extends UpdateCompanion<GithubRepoTopic> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> githubStarredId;
  const GithubRepoTopicsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.githubStarredId = const Value.absent(),
  });
  GithubRepoTopicsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int githubStarredId,
  })  : name = Value(name),
        githubStarredId = Value(githubStarredId);
  static Insertable<GithubRepoTopic> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? githubStarredId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (githubStarredId != null) 'github_starred_id': githubStarredId,
    });
  }

  GithubRepoTopicsCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<int>? githubStarredId}) {
    return GithubRepoTopicsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      githubStarredId: githubStarredId ?? this.githubStarredId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (githubStarredId.present) {
      map['github_starred_id'] = Variable<int>(githubStarredId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GithubRepoTopicsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('githubStarredId: $githubStarredId')
          ..write(')'))
        .toString();
  }
}

class $GithubRepoTopicsTable extends GithubRepoTopics
    with TableInfo<$GithubRepoTopicsTable, GithubRepoTopic> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GithubRepoTopicsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 64),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  final VerificationMeta _githubStarredIdMeta =
      const VerificationMeta('githubStarredId');
  @override
  late final GeneratedColumn<int> githubStarredId = GeneratedColumn<int>(
      'github_starred_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, githubStarredId];
  @override
  String get aliasedName => _alias ?? 'github_repo_topics';
  @override
  String get actualTableName => 'github_repo_topics';
  @override
  VerificationContext validateIntegrity(Insertable<GithubRepoTopic> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('github_starred_id')) {
      context.handle(
          _githubStarredIdMeta,
          githubStarredId.isAcceptableOrUnknown(
              data['github_starred_id']!, _githubStarredIdMeta));
    } else if (isInserting) {
      context.missing(_githubStarredIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GithubRepoTopic map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GithubRepoTopic(
      id: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      githubStarredId: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}github_starred_id'])!,
    );
  }

  @override
  $GithubRepoTopicsTable createAlias(String alias) {
    return $GithubRepoTopicsTable(attachedDatabase, alias);
  }
}

class GithubStarredTag extends DataClass
    implements Insertable<GithubStarredTag> {
  final int id;
  final String name;
  final int githubStarredId;
  const GithubStarredTag(
      {required this.id, required this.name, required this.githubStarredId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['github_starred_id'] = Variable<int>(githubStarredId);
    return map;
  }

  GithubStarredTagsCompanion toCompanion(bool nullToAbsent) {
    return GithubStarredTagsCompanion(
      id: Value(id),
      name: Value(name),
      githubStarredId: Value(githubStarredId),
    );
  }

  factory GithubStarredTag.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GithubStarredTag(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      githubStarredId: serializer.fromJson<int>(json['githubStarredId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'githubStarredId': serializer.toJson<int>(githubStarredId),
    };
  }

  GithubStarredTag copyWith({int? id, String? name, int? githubStarredId}) =>
      GithubStarredTag(
        id: id ?? this.id,
        name: name ?? this.name,
        githubStarredId: githubStarredId ?? this.githubStarredId,
      );
  @override
  String toString() {
    return (StringBuffer('GithubStarredTag(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('githubStarredId: $githubStarredId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, githubStarredId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GithubStarredTag &&
          other.id == this.id &&
          other.name == this.name &&
          other.githubStarredId == this.githubStarredId);
}

class GithubStarredTagsCompanion extends UpdateCompanion<GithubStarredTag> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> githubStarredId;
  const GithubStarredTagsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.githubStarredId = const Value.absent(),
  });
  GithubStarredTagsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int githubStarredId,
  })  : name = Value(name),
        githubStarredId = Value(githubStarredId);
  static Insertable<GithubStarredTag> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? githubStarredId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (githubStarredId != null) 'github_starred_id': githubStarredId,
    });
  }

  GithubStarredTagsCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<int>? githubStarredId}) {
    return GithubStarredTagsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      githubStarredId: githubStarredId ?? this.githubStarredId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (githubStarredId.present) {
      map['github_starred_id'] = Variable<int>(githubStarredId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GithubStarredTagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('githubStarredId: $githubStarredId')
          ..write(')'))
        .toString();
  }
}

class $GithubStarredTagsTable extends GithubStarredTags
    with TableInfo<$GithubStarredTagsTable, GithubStarredTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GithubStarredTagsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 64),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  final VerificationMeta _githubStarredIdMeta =
      const VerificationMeta('githubStarredId');
  @override
  late final GeneratedColumn<int> githubStarredId = GeneratedColumn<int>(
      'github_starred_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, githubStarredId];
  @override
  String get aliasedName => _alias ?? 'github_starred_tags';
  @override
  String get actualTableName => 'github_starred_tags';
  @override
  VerificationContext validateIntegrity(Insertable<GithubStarredTag> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('github_starred_id')) {
      context.handle(
          _githubStarredIdMeta,
          githubStarredId.isAcceptableOrUnknown(
              data['github_starred_id']!, _githubStarredIdMeta));
    } else if (isInserting) {
      context.missing(_githubStarredIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GithubStarredTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GithubStarredTag(
      id: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      githubStarredId: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}github_starred_id'])!,
    );
  }

  @override
  $GithubStarredTagsTable createAlias(String alias) {
    return $GithubStarredTagsTable(attachedDatabase, alias);
  }
}

class GithubTag extends DataClass implements Insertable<GithubTag> {
  final int id;
  final String name;
  final int count;
  const GithubTag({required this.id, required this.name, required this.count});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['count'] = Variable<int>(count);
    return map;
  }

  GithubTagsCompanion toCompanion(bool nullToAbsent) {
    return GithubTagsCompanion(
      id: Value(id),
      name: Value(name),
      count: Value(count),
    );
  }

  factory GithubTag.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GithubTag(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      count: serializer.fromJson<int>(json['count']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'count': serializer.toJson<int>(count),
    };
  }

  GithubTag copyWith({int? id, String? name, int? count}) => GithubTag(
        id: id ?? this.id,
        name: name ?? this.name,
        count: count ?? this.count,
      );
  @override
  String toString() {
    return (StringBuffer('GithubTag(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('count: $count')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, count);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GithubTag &&
          other.id == this.id &&
          other.name == this.name &&
          other.count == this.count);
}

class GithubTagsCompanion extends UpdateCompanion<GithubTag> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> count;
  const GithubTagsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.count = const Value.absent(),
  });
  GithubTagsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int count,
  })  : name = Value(name),
        count = Value(count);
  static Insertable<GithubTag> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? count,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (count != null) 'count': count,
    });
  }

  GithubTagsCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<int>? count}) {
    return GithubTagsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      count: count ?? this.count,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GithubTagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('count: $count')
          ..write(')'))
        .toString();
  }
}

class $GithubTagsTable extends GithubTags
    with TableInfo<$GithubTagsTable, GithubTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GithubTagsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  final VerificationMeta _countMeta = const VerificationMeta('count');
  @override
  late final GeneratedColumn<int> count = GeneratedColumn<int>(
      'count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, count];
  @override
  String get aliasedName => _alias ?? 'github_tags';
  @override
  String get actualTableName => 'github_tags';
  @override
  VerificationContext validateIntegrity(Insertable<GithubTag> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('count')) {
      context.handle(
          _countMeta, count.isAcceptableOrUnknown(data['count']!, _countMeta));
    } else if (isInserting) {
      context.missing(_countMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GithubTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GithubTag(
      id: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      count: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}count'])!,
    );
  }

  @override
  $GithubTagsTable createAlias(String alias) {
    return $GithubTagsTable(attachedDatabase, alias);
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(e);
  _$Database.connect(DatabaseConnection c) : super.connect(c);
  late final $GithubStarredTable githubStarred = $GithubStarredTable(this);
  late final $GithubRepoTopicsTable githubRepoTopics =
      $GithubRepoTopicsTable(this);
  late final $GithubStarredTagsTable githubStarredTags =
      $GithubStarredTagsTable(this);
  late final $GithubTagsTable githubTags = $GithubTagsTable(this);
  late final GithubTagsDao githubTagsDao = GithubTagsDao(this as Database);
  late final GithubStarredDao githubStarredDao =
      GithubStarredDao(this as Database);
  @override
  Iterable<TableInfo<Table, dynamic>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [githubStarred, githubRepoTopics, githubStarredTags, githubTags];
}
