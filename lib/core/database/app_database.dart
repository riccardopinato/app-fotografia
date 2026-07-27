import 'dart:convert';

import 'package:drift/drift.dart';

import 'database_connection.dart';
part 'app_database.g.dart';

class ContentItems extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()();
  TextColumn get primaryCategory => text()();
  TextColumn get difficulty => text()();
  BoolColumn get premium => boolean()();
  TextColumn get canonicalLocale => text()();
  TextColumn get editorialStatus => text()();
  IntColumn get version => integer()();
  IntColumn get createdAtUtcMs => integer()();
  IntColumn get updatedAtUtcMs => integer()();
  IntColumn get publishedAtUtcMs => integer().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

class ContentTranslations extends Table {
  TextColumn get id => text()();
  TextColumn get contentId =>
      text().references(ContentItems, #id, onDelete: KeyAction.cascade)();
  TextColumn get locale =>
      text().check(const CustomExpression("length(locale) > 0"))();
  TextColumn get title => text()();
  TextColumn get summary => text()();
  TextColumn get body => text()();
  TextColumn get translationStatus => text()();
  TextColumn get translationMethod => text()();
  IntColumn get sourceVersion => integer()();
  IntColumn get reviewedAtUtcMs => integer().nullable()();
  IntColumn get createdAtUtcMs => integer()();
  IntColumn get updatedAtUtcMs => integer()();
  @override
  Set<Column> get primaryKey => {id};
  @override
  List<Set<Column>> get uniqueKeys => [
    {contentId, locale},
  ];
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY(content_id) REFERENCES content_items(id) ON DELETE CASCADE',
  ];
}

class ContentSources extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get author => text().nullable()();
  TextColumn get publisher => text().nullable()();
  IntColumn get publicationYear => integer().nullable()();
  TextColumn get sourceUri => text().nullable()();
  TextColumn get originalLocale => text()();
  TextColumn get licenseType => text()();
  TextColumn get licenseReference => text().nullable()();
  TextColumn get attributionText => text().nullable()();
  TextColumn get rightsStatus => text()();
  IntColumn get createdAtUtcMs => integer()();
  IntColumn get updatedAtUtcMs => integer()();
  @override
  Set<Column> get primaryKey => {id};
}

class ContentItemSources extends Table {
  TextColumn get contentId =>
      text().references(ContentItems, #id, onDelete: KeyAction.cascade)();
  TextColumn get sourceId =>
      text().references(ContentSources, #id, onDelete: KeyAction.restrict)();
  @override
  Set<Column> get primaryKey => {contentId, sourceId};
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY(content_id) REFERENCES content_items(id) ON DELETE CASCADE',
    'FOREIGN KEY(source_id) REFERENCES content_sources(id) ON DELETE RESTRICT',
  ];
}

class Tags extends Table {
  TextColumn get id => text()();
  TextColumn get code => text()();
  @override
  Set<Column> get primaryKey => {id};
  @override
  List<Set<Column>> get uniqueKeys => [
    {code},
  ];
}

class TagTranslations extends Table {
  TextColumn get tagId =>
      text().references(Tags, #id, onDelete: KeyAction.cascade)();
  TextColumn get locale => text()();
  TextColumn get label => text()();
  @override
  Set<Column> get primaryKey => {tagId, locale};
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY(tag_id) REFERENCES tags(id) ON DELETE CASCADE',
  ];
}

class ContentItemTags extends Table {
  TextColumn get contentId =>
      text().references(ContentItems, #id, onDelete: KeyAction.cascade)();
  TextColumn get tagId =>
      text().references(Tags, #id, onDelete: KeyAction.restrict)();
  @override
  Set<Column> get primaryKey => {contentId, tagId};
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY(content_id) REFERENCES content_items(id) ON DELETE CASCADE',
    'FOREIGN KEY(tag_id) REFERENCES tags(id) ON DELETE RESTRICT',
  ];
}

class UserProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get skillLevel => text()();
  // Retained for the v1 migration. New code uses languageMode/selectedLocale.
  TextColumn get preferredLocale => text()();
  TextColumn get languageMode => text().withDefault(const Constant('device'))();
  TextColumn get selectedLocale => text().nullable()();
  TextColumn get preferredTopics => text()
      .map(const ProfileStringListConverter())
      .withDefault(const Constant('[]'))();
  TextColumn get cameraBodies => text()
      .map(const ProfileStringListConverter())
      .withDefault(const Constant('[]'))();
  TextColumn get lenses => text()
      .map(const ProfileStringListConverter())
      .withDefault(const Constant('[]'))();
  TextColumn get smartphones => text()
      .map(const ProfileStringListConverter())
      .withDefault(const Constant('[]'))();
  TextColumn get learningGoals => text()
      .map(const ProfileStringListConverter())
      .withDefault(const Constant('[]'))();
  TextColumn get themePreference => text()();
  IntColumn get createdAtUtcMs => integer()();
  IntColumn get updatedAtUtcMs => integer()();
  @override
  Set<Column> get primaryKey => {id};
}

class Collections extends Table {
  TextColumn get id => text()();
  TextColumn get name =>
      text().check(const CustomExpression('length(trim(name)) > 0'))();
  IntColumn get createdAtUtcMs => integer()();
  IntColumn get updatedAtUtcMs => integer()();
  @override
  Set<Column> get primaryKey => {id};
}

class SavedItems extends Table {
  TextColumn get id => text()();
  TextColumn get contentId =>
      text().references(ContentItems, #id, onDelete: KeyAction.cascade)();
  TextColumn get collectionId => text().nullable().references(
    Collections,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get note => text().nullable()();
  TextColumn get status => text()();
  IntColumn get savedAtUtcMs => integer()();
  IntColumn get updatedAtUtcMs => integer()();
  @override
  Set<Column> get primaryKey => {id};
  @override
  List<Set<Column>> get uniqueKeys => [
    {contentId},
  ];
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY(content_id) REFERENCES content_items(id) ON DELETE CASCADE',
    'FOREIGN KEY(collection_id) REFERENCES collections(id) ON DELETE SET NULL',
  ];
}

class ProfileStringListConverter extends TypeConverter<List<String>, String> {
  const ProfileStringListConverter();

  @override
  List<String> fromSql(String fromDb) {
    try {
      final decoded = jsonDecode(fromDb);
      final values = switch (decoded) {
        {'version': 1, 'values': final List<dynamic> values} => values,
        // Accept the early v2 array representation so existing local data
        // remains readable when this converter format evolves.
        final List<dynamic> values => values,
        _ => const <dynamic>[],
      };
      return List.unmodifiable(_normalise(values.whereType<String>()));
    } on FormatException {
      return const [];
    }
  }

  @override
  String toSql(List<String> value) =>
      jsonEncode({'version': 1, 'values': _normalise(value)});
}

List<String> normaliseProfileValues(Iterable<String> values) =>
    List.unmodifiable(_normalise(values));

List<String> _normalise(Iterable<String> values) =>
    values
        .map((value) => value.trim().toLowerCase())
        .where((value) => RegExp(r'^[a-z0-9-]+$').hasMatch(value))
        .toSet()
        .toList()
      ..sort();

@DriftDatabase(
  tables: [
    ContentItems,
    ContentTranslations,
    ContentSources,
    ContentItemSources,
    Tags,
    TagTranslations,
    ContentItemTags,
    UserProfiles,
    Collections,
    SavedItems,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'framelab_local'));
  @override
  int get schemaVersion => 4;
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      for (final statement in _schemaObjects) {
        await customStatement(statement);
      }
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(userProfiles, userProfiles.languageMode);
        await m.addColumn(userProfiles, userProfiles.selectedLocale);
        await m.addColumn(userProfiles, userProfiles.preferredTopics);
        await m.addColumn(userProfiles, userProfiles.cameraBodies);
        await m.addColumn(userProfiles, userProfiles.lenses);
        await m.addColumn(userProfiles, userProfiles.smartphones);
        await m.addColumn(userProfiles, userProfiles.learningGoals);
        await customStatement('''
          UPDATE user_profiles
          SET language_mode = 'manual', selected_locale = preferred_locale
          WHERE preferred_locale IS NOT NULL AND preferred_locale != ''
        ''');
      }
      if (from < 3) {
        for (final statement in _searchSchemaObjects) {
          await customStatement(statement);
        }
        await customStatement(_rebuildSearchIndex);
      }
      if (from < 4) {
        await m.createTable(collections);
        await m.createTable(savedItems);
        for (final statement in _librarySchemaIndexes) {
          await customStatement(statement);
        }
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}

const _schemaIndexes = <String>[
  'CREATE INDEX content_items_editorial_status_idx ON content_items(editorial_status)',
  'CREATE INDEX content_items_type_idx ON content_items(type)',
  'CREATE INDEX content_items_category_idx ON content_items(primary_category)',
  'CREATE INDEX content_items_difficulty_idx ON content_items(difficulty)',
  'CREATE INDEX content_items_premium_idx ON content_items(premium)',
  'CREATE INDEX content_translations_status_idx ON content_translations(translation_status)',
  'CREATE INDEX content_item_sources_source_idx ON content_item_sources(source_id)',
  'CREATE INDEX content_item_tags_tag_idx ON content_item_tags(tag_id)',
  'CREATE INDEX content_sources_rights_status_idx ON content_sources(rights_status)',
  ..._librarySchemaIndexes,
];

const _librarySchemaIndexes = <String>[
  'CREATE INDEX saved_items_collection_id_idx ON saved_items(collection_id)',
  'CREATE INDEX saved_items_status_idx ON saved_items(status)',
  'CREATE INDEX saved_items_updated_at_idx ON saved_items(updated_at_utc_ms DESC, content_id ASC)',
];

// FTS5 is available in SQLite bundled by Drift; unicode61 folds case and Latin
// diacritics. Triggers rebuild only affected content rows, including tag labels.
const _reindexContentSql =
    "DELETE FROM content_search WHERE content_id = :content_id; "
    "INSERT INTO content_search "
    "SELECT c.id, group_concat(t.title, ' '), group_concat(t.summary, ' '), "
    "group_concat(t.body, ' '), "
    "coalesce((SELECT group_concat(tt.label, ' ') FROM content_item_tags x "
    "JOIN tag_translations tt ON tt.tag_id = x.tag_id "
    "WHERE x.content_id = c.id), ''), "
    "coalesce((SELECT group_concat(g.code, ' ') FROM content_item_tags x "
    "JOIN tags g ON g.id = x.tag_id WHERE x.content_id = c.id), '') "
    "FROM content_items c LEFT JOIN content_translations t ON t.content_id = c.id "
    "WHERE c.id = :content_id GROUP BY c.id";

String _contentTrigger(
  String name,
  String timing,
  String table,
  String contentIdExpression,
) =>
    'CREATE TRIGGER $name $timing ON $table BEGIN '
    '${_reindexContentSql.replaceAll(':content_id', contentIdExpression)}; END';

String _tagTrigger(
  String name,
  String timing,
  String table,
  String tagIdExpression,
) =>
    'CREATE TRIGGER $name $timing ON $table BEGIN '
    'DELETE FROM content_search WHERE content_id IN '
    '(SELECT content_id FROM content_item_tags WHERE tag_id = $tagIdExpression); '
    'INSERT INTO content_search '
    "SELECT c.id, group_concat(t.title, ' '), group_concat(t.summary, ' '), "
    "group_concat(t.body, ' '), "
    "coalesce((SELECT group_concat(tt.label, ' ') FROM content_item_tags x "
    "JOIN tag_translations tt ON tt.tag_id = x.tag_id "
    "WHERE x.content_id = c.id), ''), "
    "coalesce((SELECT group_concat(g.code, ' ') FROM content_item_tags x "
    "JOIN tags g ON g.id = x.tag_id WHERE x.content_id = c.id), '') "
    'FROM content_items c LEFT JOIN content_translations t ON t.content_id = c.id '
    'WHERE c.id IN (SELECT content_id FROM content_item_tags WHERE tag_id = $tagIdExpression) '
    'GROUP BY c.id; END';

const _searchTableSql =
    'CREATE VIRTUAL TABLE content_search USING fts5('
    'content_id UNINDEXED, title, summary, body, tags, tag_codes, '
    'tokenize="unicode61 remove_diacritics 2")';

final _searchSchemaObjects = <String>[
  _searchTableSql,
  _contentTrigger(
    'content_search_translations_ai',
    'AFTER INSERT',
    'content_translations',
    'NEW.content_id',
  ),
  _contentTrigger(
    'content_search_translations_au',
    'AFTER UPDATE',
    'content_translations',
    'NEW.content_id',
  ),
  _contentTrigger(
    'content_search_translations_ad',
    'AFTER DELETE',
    'content_translations',
    'OLD.content_id',
  ),
  _contentTrigger(
    'content_search_content_tags_ai',
    'AFTER INSERT',
    'content_item_tags',
    'NEW.content_id',
  ),
  _contentTrigger(
    'content_search_content_tags_ad',
    'AFTER DELETE',
    'content_item_tags',
    'OLD.content_id',
  ),
  _contentTrigger(
    'content_search_content_tags_au',
    'AFTER UPDATE',
    'content_item_tags',
    'NEW.content_id',
  ),
  _tagTrigger('content_search_tags_au', 'AFTER UPDATE', 'tags', 'NEW.id'),
  _tagTrigger(
    'content_search_tag_translations_ai',
    'AFTER INSERT',
    'tag_translations',
    'NEW.tag_id',
  ),
  _tagTrigger(
    'content_search_tag_translations_au',
    'AFTER UPDATE',
    'tag_translations',
    'NEW.tag_id',
  ),
  _tagTrigger(
    'content_search_tag_translations_ad',
    'AFTER DELETE',
    'tag_translations',
    'OLD.tag_id',
  ),
];
final _schemaObjects = <String>[..._schemaIndexes, ..._searchSchemaObjects];
const _rebuildSearchIndex =
    '''DELETE FROM content_search; INSERT INTO content_search SELECT c.id, group_concat(t.title,' '), group_concat(t.summary,' '), group_concat(t.body,' '), coalesce((SELECT group_concat(tt.label,' ') FROM content_item_tags x JOIN tag_translations tt ON tt.tag_id=x.tag_id WHERE x.content_id=c.id),''), coalesce((SELECT group_concat(g.code,' ') FROM content_item_tags x JOIN tags g ON g.id=x.tag_id WHERE x.content_id=c.id),'') FROM content_items c LEFT JOIN content_translations t ON t.content_id=c.id GROUP BY c.id;''';
