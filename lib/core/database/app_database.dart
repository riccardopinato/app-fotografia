import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
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
      .map(const StringListConverter())
      .withDefault(const Constant('[]'))();
  TextColumn get cameraBodies => text()
      .map(const StringListConverter())
      .withDefault(const Constant('[]'))();
  TextColumn get lenses => text()
      .map(const StringListConverter())
      .withDefault(const Constant('[]'))();
  TextColumn get smartphones => text()
      .map(const StringListConverter())
      .withDefault(const Constant('[]'))();
  TextColumn get learningGoals => text()
      .map(const StringListConverter())
      .withDefault(const Constant('[]'))();
  TextColumn get themePreference => text()();
  IntColumn get createdAtUtcMs => integer()();
  IntColumn get updatedAtUtcMs => integer()();
  @override
  Set<Column> get primaryKey => {id};
}

class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();

  @override
  List<String> fromSql(String fromDb) => List<String>.unmodifiable(
    (jsonDecode(fromDb) as List<dynamic>).cast<String>(),
  );

  @override
  String toSql(List<String> value) => jsonEncode(value);
}

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
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'framelab_local'));
  @override
  int get schemaVersion => 2;
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      for (final statement in _schemaIndexes) {
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
];
