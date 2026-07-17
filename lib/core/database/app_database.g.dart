// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ContentItemsTable extends ContentItems
    with TableInfo<$ContentItemsTable, ContentItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContentItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _primaryCategoryMeta = const VerificationMeta(
    'primaryCategory',
  );
  @override
  late final GeneratedColumn<String> primaryCategory = GeneratedColumn<String>(
    'primary_category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<String> difficulty = GeneratedColumn<String>(
    'difficulty',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _premiumMeta = const VerificationMeta(
    'premium',
  );
  @override
  late final GeneratedColumn<bool> premium = GeneratedColumn<bool>(
    'premium',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("premium" IN (0, 1))',
    ),
  );
  static const VerificationMeta _canonicalLocaleMeta = const VerificationMeta(
    'canonicalLocale',
  );
  @override
  late final GeneratedColumn<String> canonicalLocale = GeneratedColumn<String>(
    'canonical_locale',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _editorialStatusMeta = const VerificationMeta(
    'editorialStatus',
  );
  @override
  late final GeneratedColumn<String> editorialStatus = GeneratedColumn<String>(
    'editorial_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtUtcMsMeta = const VerificationMeta(
    'createdAtUtcMs',
  );
  @override
  late final GeneratedColumn<int> createdAtUtcMs = GeneratedColumn<int>(
    'created_at_utc_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtUtcMsMeta = const VerificationMeta(
    'updatedAtUtcMs',
  );
  @override
  late final GeneratedColumn<int> updatedAtUtcMs = GeneratedColumn<int>(
    'updated_at_utc_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _publishedAtUtcMsMeta = const VerificationMeta(
    'publishedAtUtcMs',
  );
  @override
  late final GeneratedColumn<int> publishedAtUtcMs = GeneratedColumn<int>(
    'published_at_utc_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    primaryCategory,
    difficulty,
    premium,
    canonicalLocale,
    editorialStatus,
    version,
    createdAtUtcMs,
    updatedAtUtcMs,
    publishedAtUtcMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'content_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContentItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('primary_category')) {
      context.handle(
        _primaryCategoryMeta,
        primaryCategory.isAcceptableOrUnknown(
          data['primary_category']!,
          _primaryCategoryMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_primaryCategoryMeta);
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    } else if (isInserting) {
      context.missing(_difficultyMeta);
    }
    if (data.containsKey('premium')) {
      context.handle(
        _premiumMeta,
        premium.isAcceptableOrUnknown(data['premium']!, _premiumMeta),
      );
    } else if (isInserting) {
      context.missing(_premiumMeta);
    }
    if (data.containsKey('canonical_locale')) {
      context.handle(
        _canonicalLocaleMeta,
        canonicalLocale.isAcceptableOrUnknown(
          data['canonical_locale']!,
          _canonicalLocaleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_canonicalLocaleMeta);
    }
    if (data.containsKey('editorial_status')) {
      context.handle(
        _editorialStatusMeta,
        editorialStatus.isAcceptableOrUnknown(
          data['editorial_status']!,
          _editorialStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_editorialStatusMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('created_at_utc_ms')) {
      context.handle(
        _createdAtUtcMsMeta,
        createdAtUtcMs.isAcceptableOrUnknown(
          data['created_at_utc_ms']!,
          _createdAtUtcMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtUtcMsMeta);
    }
    if (data.containsKey('updated_at_utc_ms')) {
      context.handle(
        _updatedAtUtcMsMeta,
        updatedAtUtcMs.isAcceptableOrUnknown(
          data['updated_at_utc_ms']!,
          _updatedAtUtcMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMsMeta);
    }
    if (data.containsKey('published_at_utc_ms')) {
      context.handle(
        _publishedAtUtcMsMeta,
        publishedAtUtcMs.isAcceptableOrUnknown(
          data['published_at_utc_ms']!,
          _publishedAtUtcMsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ContentItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContentItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      primaryCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}primary_category'],
      )!,
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}difficulty'],
      )!,
      premium: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}premium'],
      )!,
      canonicalLocale: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}canonical_locale'],
      )!,
      editorialStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}editorial_status'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      createdAtUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_utc_ms'],
      )!,
      updatedAtUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_utc_ms'],
      )!,
      publishedAtUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}published_at_utc_ms'],
      ),
    );
  }

  @override
  $ContentItemsTable createAlias(String alias) {
    return $ContentItemsTable(attachedDatabase, alias);
  }
}

class ContentItem extends DataClass implements Insertable<ContentItem> {
  final String id;
  final String type;
  final String primaryCategory;
  final String difficulty;
  final bool premium;
  final String canonicalLocale;
  final String editorialStatus;
  final int version;
  final int createdAtUtcMs;
  final int updatedAtUtcMs;
  final int? publishedAtUtcMs;
  const ContentItem({
    required this.id,
    required this.type,
    required this.primaryCategory,
    required this.difficulty,
    required this.premium,
    required this.canonicalLocale,
    required this.editorialStatus,
    required this.version,
    required this.createdAtUtcMs,
    required this.updatedAtUtcMs,
    this.publishedAtUtcMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['primary_category'] = Variable<String>(primaryCategory);
    map['difficulty'] = Variable<String>(difficulty);
    map['premium'] = Variable<bool>(premium);
    map['canonical_locale'] = Variable<String>(canonicalLocale);
    map['editorial_status'] = Variable<String>(editorialStatus);
    map['version'] = Variable<int>(version);
    map['created_at_utc_ms'] = Variable<int>(createdAtUtcMs);
    map['updated_at_utc_ms'] = Variable<int>(updatedAtUtcMs);
    if (!nullToAbsent || publishedAtUtcMs != null) {
      map['published_at_utc_ms'] = Variable<int>(publishedAtUtcMs);
    }
    return map;
  }

  ContentItemsCompanion toCompanion(bool nullToAbsent) {
    return ContentItemsCompanion(
      id: Value(id),
      type: Value(type),
      primaryCategory: Value(primaryCategory),
      difficulty: Value(difficulty),
      premium: Value(premium),
      canonicalLocale: Value(canonicalLocale),
      editorialStatus: Value(editorialStatus),
      version: Value(version),
      createdAtUtcMs: Value(createdAtUtcMs),
      updatedAtUtcMs: Value(updatedAtUtcMs),
      publishedAtUtcMs: publishedAtUtcMs == null && nullToAbsent
          ? const Value.absent()
          : Value(publishedAtUtcMs),
    );
  }

  factory ContentItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContentItem(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      primaryCategory: serializer.fromJson<String>(json['primaryCategory']),
      difficulty: serializer.fromJson<String>(json['difficulty']),
      premium: serializer.fromJson<bool>(json['premium']),
      canonicalLocale: serializer.fromJson<String>(json['canonicalLocale']),
      editorialStatus: serializer.fromJson<String>(json['editorialStatus']),
      version: serializer.fromJson<int>(json['version']),
      createdAtUtcMs: serializer.fromJson<int>(json['createdAtUtcMs']),
      updatedAtUtcMs: serializer.fromJson<int>(json['updatedAtUtcMs']),
      publishedAtUtcMs: serializer.fromJson<int?>(json['publishedAtUtcMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'primaryCategory': serializer.toJson<String>(primaryCategory),
      'difficulty': serializer.toJson<String>(difficulty),
      'premium': serializer.toJson<bool>(premium),
      'canonicalLocale': serializer.toJson<String>(canonicalLocale),
      'editorialStatus': serializer.toJson<String>(editorialStatus),
      'version': serializer.toJson<int>(version),
      'createdAtUtcMs': serializer.toJson<int>(createdAtUtcMs),
      'updatedAtUtcMs': serializer.toJson<int>(updatedAtUtcMs),
      'publishedAtUtcMs': serializer.toJson<int?>(publishedAtUtcMs),
    };
  }

  ContentItem copyWith({
    String? id,
    String? type,
    String? primaryCategory,
    String? difficulty,
    bool? premium,
    String? canonicalLocale,
    String? editorialStatus,
    int? version,
    int? createdAtUtcMs,
    int? updatedAtUtcMs,
    Value<int?> publishedAtUtcMs = const Value.absent(),
  }) => ContentItem(
    id: id ?? this.id,
    type: type ?? this.type,
    primaryCategory: primaryCategory ?? this.primaryCategory,
    difficulty: difficulty ?? this.difficulty,
    premium: premium ?? this.premium,
    canonicalLocale: canonicalLocale ?? this.canonicalLocale,
    editorialStatus: editorialStatus ?? this.editorialStatus,
    version: version ?? this.version,
    createdAtUtcMs: createdAtUtcMs ?? this.createdAtUtcMs,
    updatedAtUtcMs: updatedAtUtcMs ?? this.updatedAtUtcMs,
    publishedAtUtcMs: publishedAtUtcMs.present
        ? publishedAtUtcMs.value
        : this.publishedAtUtcMs,
  );
  ContentItem copyWithCompanion(ContentItemsCompanion data) {
    return ContentItem(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      primaryCategory: data.primaryCategory.present
          ? data.primaryCategory.value
          : this.primaryCategory,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      premium: data.premium.present ? data.premium.value : this.premium,
      canonicalLocale: data.canonicalLocale.present
          ? data.canonicalLocale.value
          : this.canonicalLocale,
      editorialStatus: data.editorialStatus.present
          ? data.editorialStatus.value
          : this.editorialStatus,
      version: data.version.present ? data.version.value : this.version,
      createdAtUtcMs: data.createdAtUtcMs.present
          ? data.createdAtUtcMs.value
          : this.createdAtUtcMs,
      updatedAtUtcMs: data.updatedAtUtcMs.present
          ? data.updatedAtUtcMs.value
          : this.updatedAtUtcMs,
      publishedAtUtcMs: data.publishedAtUtcMs.present
          ? data.publishedAtUtcMs.value
          : this.publishedAtUtcMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContentItem(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('primaryCategory: $primaryCategory, ')
          ..write('difficulty: $difficulty, ')
          ..write('premium: $premium, ')
          ..write('canonicalLocale: $canonicalLocale, ')
          ..write('editorialStatus: $editorialStatus, ')
          ..write('version: $version, ')
          ..write('createdAtUtcMs: $createdAtUtcMs, ')
          ..write('updatedAtUtcMs: $updatedAtUtcMs, ')
          ..write('publishedAtUtcMs: $publishedAtUtcMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    primaryCategory,
    difficulty,
    premium,
    canonicalLocale,
    editorialStatus,
    version,
    createdAtUtcMs,
    updatedAtUtcMs,
    publishedAtUtcMs,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContentItem &&
          other.id == this.id &&
          other.type == this.type &&
          other.primaryCategory == this.primaryCategory &&
          other.difficulty == this.difficulty &&
          other.premium == this.premium &&
          other.canonicalLocale == this.canonicalLocale &&
          other.editorialStatus == this.editorialStatus &&
          other.version == this.version &&
          other.createdAtUtcMs == this.createdAtUtcMs &&
          other.updatedAtUtcMs == this.updatedAtUtcMs &&
          other.publishedAtUtcMs == this.publishedAtUtcMs);
}

class ContentItemsCompanion extends UpdateCompanion<ContentItem> {
  final Value<String> id;
  final Value<String> type;
  final Value<String> primaryCategory;
  final Value<String> difficulty;
  final Value<bool> premium;
  final Value<String> canonicalLocale;
  final Value<String> editorialStatus;
  final Value<int> version;
  final Value<int> createdAtUtcMs;
  final Value<int> updatedAtUtcMs;
  final Value<int?> publishedAtUtcMs;
  final Value<int> rowid;
  const ContentItemsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.primaryCategory = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.premium = const Value.absent(),
    this.canonicalLocale = const Value.absent(),
    this.editorialStatus = const Value.absent(),
    this.version = const Value.absent(),
    this.createdAtUtcMs = const Value.absent(),
    this.updatedAtUtcMs = const Value.absent(),
    this.publishedAtUtcMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContentItemsCompanion.insert({
    required String id,
    required String type,
    required String primaryCategory,
    required String difficulty,
    required bool premium,
    required String canonicalLocale,
    required String editorialStatus,
    required int version,
    required int createdAtUtcMs,
    required int updatedAtUtcMs,
    this.publishedAtUtcMs = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       primaryCategory = Value(primaryCategory),
       difficulty = Value(difficulty),
       premium = Value(premium),
       canonicalLocale = Value(canonicalLocale),
       editorialStatus = Value(editorialStatus),
       version = Value(version),
       createdAtUtcMs = Value(createdAtUtcMs),
       updatedAtUtcMs = Value(updatedAtUtcMs);
  static Insertable<ContentItem> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<String>? primaryCategory,
    Expression<String>? difficulty,
    Expression<bool>? premium,
    Expression<String>? canonicalLocale,
    Expression<String>? editorialStatus,
    Expression<int>? version,
    Expression<int>? createdAtUtcMs,
    Expression<int>? updatedAtUtcMs,
    Expression<int>? publishedAtUtcMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (primaryCategory != null) 'primary_category': primaryCategory,
      if (difficulty != null) 'difficulty': difficulty,
      if (premium != null) 'premium': premium,
      if (canonicalLocale != null) 'canonical_locale': canonicalLocale,
      if (editorialStatus != null) 'editorial_status': editorialStatus,
      if (version != null) 'version': version,
      if (createdAtUtcMs != null) 'created_at_utc_ms': createdAtUtcMs,
      if (updatedAtUtcMs != null) 'updated_at_utc_ms': updatedAtUtcMs,
      if (publishedAtUtcMs != null) 'published_at_utc_ms': publishedAtUtcMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContentItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? type,
    Value<String>? primaryCategory,
    Value<String>? difficulty,
    Value<bool>? premium,
    Value<String>? canonicalLocale,
    Value<String>? editorialStatus,
    Value<int>? version,
    Value<int>? createdAtUtcMs,
    Value<int>? updatedAtUtcMs,
    Value<int?>? publishedAtUtcMs,
    Value<int>? rowid,
  }) {
    return ContentItemsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      primaryCategory: primaryCategory ?? this.primaryCategory,
      difficulty: difficulty ?? this.difficulty,
      premium: premium ?? this.premium,
      canonicalLocale: canonicalLocale ?? this.canonicalLocale,
      editorialStatus: editorialStatus ?? this.editorialStatus,
      version: version ?? this.version,
      createdAtUtcMs: createdAtUtcMs ?? this.createdAtUtcMs,
      updatedAtUtcMs: updatedAtUtcMs ?? this.updatedAtUtcMs,
      publishedAtUtcMs: publishedAtUtcMs ?? this.publishedAtUtcMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (primaryCategory.present) {
      map['primary_category'] = Variable<String>(primaryCategory.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(difficulty.value);
    }
    if (premium.present) {
      map['premium'] = Variable<bool>(premium.value);
    }
    if (canonicalLocale.present) {
      map['canonical_locale'] = Variable<String>(canonicalLocale.value);
    }
    if (editorialStatus.present) {
      map['editorial_status'] = Variable<String>(editorialStatus.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (createdAtUtcMs.present) {
      map['created_at_utc_ms'] = Variable<int>(createdAtUtcMs.value);
    }
    if (updatedAtUtcMs.present) {
      map['updated_at_utc_ms'] = Variable<int>(updatedAtUtcMs.value);
    }
    if (publishedAtUtcMs.present) {
      map['published_at_utc_ms'] = Variable<int>(publishedAtUtcMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContentItemsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('primaryCategory: $primaryCategory, ')
          ..write('difficulty: $difficulty, ')
          ..write('premium: $premium, ')
          ..write('canonicalLocale: $canonicalLocale, ')
          ..write('editorialStatus: $editorialStatus, ')
          ..write('version: $version, ')
          ..write('createdAtUtcMs: $createdAtUtcMs, ')
          ..write('updatedAtUtcMs: $updatedAtUtcMs, ')
          ..write('publishedAtUtcMs: $publishedAtUtcMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContentTranslationsTable extends ContentTranslations
    with TableInfo<$ContentTranslationsTable, ContentTranslation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContentTranslationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentIdMeta = const VerificationMeta(
    'contentId',
  );
  @override
  late final GeneratedColumn<String> contentId = GeneratedColumn<String>(
    'content_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localeMeta = const VerificationMeta('locale');
  @override
  late final GeneratedColumn<String> locale = GeneratedColumn<String>(
    'locale',
    aliasedName,
    false,
    check: () => const CustomExpression("length(locale) > 0"),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _translationStatusMeta = const VerificationMeta(
    'translationStatus',
  );
  @override
  late final GeneratedColumn<String> translationStatus =
      GeneratedColumn<String>(
        'translation_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _translationMethodMeta = const VerificationMeta(
    'translationMethod',
  );
  @override
  late final GeneratedColumn<String> translationMethod =
      GeneratedColumn<String>(
        'translation_method',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _sourceVersionMeta = const VerificationMeta(
    'sourceVersion',
  );
  @override
  late final GeneratedColumn<int> sourceVersion = GeneratedColumn<int>(
    'source_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reviewedAtUtcMsMeta = const VerificationMeta(
    'reviewedAtUtcMs',
  );
  @override
  late final GeneratedColumn<int> reviewedAtUtcMs = GeneratedColumn<int>(
    'reviewed_at_utc_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtUtcMsMeta = const VerificationMeta(
    'createdAtUtcMs',
  );
  @override
  late final GeneratedColumn<int> createdAtUtcMs = GeneratedColumn<int>(
    'created_at_utc_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtUtcMsMeta = const VerificationMeta(
    'updatedAtUtcMs',
  );
  @override
  late final GeneratedColumn<int> updatedAtUtcMs = GeneratedColumn<int>(
    'updated_at_utc_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    contentId,
    locale,
    title,
    summary,
    body,
    translationStatus,
    translationMethod,
    sourceVersion,
    reviewedAtUtcMs,
    createdAtUtcMs,
    updatedAtUtcMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'content_translations';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContentTranslation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('content_id')) {
      context.handle(
        _contentIdMeta,
        contentId.isAcceptableOrUnknown(data['content_id']!, _contentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_contentIdMeta);
    }
    if (data.containsKey('locale')) {
      context.handle(
        _localeMeta,
        locale.isAcceptableOrUnknown(data['locale']!, _localeMeta),
      );
    } else if (isInserting) {
      context.missing(_localeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    } else if (isInserting) {
      context.missing(_summaryMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('translation_status')) {
      context.handle(
        _translationStatusMeta,
        translationStatus.isAcceptableOrUnknown(
          data['translation_status']!,
          _translationStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_translationStatusMeta);
    }
    if (data.containsKey('translation_method')) {
      context.handle(
        _translationMethodMeta,
        translationMethod.isAcceptableOrUnknown(
          data['translation_method']!,
          _translationMethodMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_translationMethodMeta);
    }
    if (data.containsKey('source_version')) {
      context.handle(
        _sourceVersionMeta,
        sourceVersion.isAcceptableOrUnknown(
          data['source_version']!,
          _sourceVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceVersionMeta);
    }
    if (data.containsKey('reviewed_at_utc_ms')) {
      context.handle(
        _reviewedAtUtcMsMeta,
        reviewedAtUtcMs.isAcceptableOrUnknown(
          data['reviewed_at_utc_ms']!,
          _reviewedAtUtcMsMeta,
        ),
      );
    }
    if (data.containsKey('created_at_utc_ms')) {
      context.handle(
        _createdAtUtcMsMeta,
        createdAtUtcMs.isAcceptableOrUnknown(
          data['created_at_utc_ms']!,
          _createdAtUtcMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtUtcMsMeta);
    }
    if (data.containsKey('updated_at_utc_ms')) {
      context.handle(
        _updatedAtUtcMsMeta,
        updatedAtUtcMs.isAcceptableOrUnknown(
          data['updated_at_utc_ms']!,
          _updatedAtUtcMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {contentId, locale},
  ];
  @override
  ContentTranslation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContentTranslation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      contentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_id'],
      )!,
      locale: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locale'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      translationStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translation_status'],
      )!,
      translationMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translation_method'],
      )!,
      sourceVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}source_version'],
      )!,
      reviewedAtUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reviewed_at_utc_ms'],
      ),
      createdAtUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_utc_ms'],
      )!,
      updatedAtUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_utc_ms'],
      )!,
    );
  }

  @override
  $ContentTranslationsTable createAlias(String alias) {
    return $ContentTranslationsTable(attachedDatabase, alias);
  }
}

class ContentTranslation extends DataClass
    implements Insertable<ContentTranslation> {
  final String id;
  final String contentId;
  final String locale;
  final String title;
  final String summary;
  final String body;
  final String translationStatus;
  final String translationMethod;
  final int sourceVersion;
  final int? reviewedAtUtcMs;
  final int createdAtUtcMs;
  final int updatedAtUtcMs;
  const ContentTranslation({
    required this.id,
    required this.contentId,
    required this.locale,
    required this.title,
    required this.summary,
    required this.body,
    required this.translationStatus,
    required this.translationMethod,
    required this.sourceVersion,
    this.reviewedAtUtcMs,
    required this.createdAtUtcMs,
    required this.updatedAtUtcMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['content_id'] = Variable<String>(contentId);
    map['locale'] = Variable<String>(locale);
    map['title'] = Variable<String>(title);
    map['summary'] = Variable<String>(summary);
    map['body'] = Variable<String>(body);
    map['translation_status'] = Variable<String>(translationStatus);
    map['translation_method'] = Variable<String>(translationMethod);
    map['source_version'] = Variable<int>(sourceVersion);
    if (!nullToAbsent || reviewedAtUtcMs != null) {
      map['reviewed_at_utc_ms'] = Variable<int>(reviewedAtUtcMs);
    }
    map['created_at_utc_ms'] = Variable<int>(createdAtUtcMs);
    map['updated_at_utc_ms'] = Variable<int>(updatedAtUtcMs);
    return map;
  }

  ContentTranslationsCompanion toCompanion(bool nullToAbsent) {
    return ContentTranslationsCompanion(
      id: Value(id),
      contentId: Value(contentId),
      locale: Value(locale),
      title: Value(title),
      summary: Value(summary),
      body: Value(body),
      translationStatus: Value(translationStatus),
      translationMethod: Value(translationMethod),
      sourceVersion: Value(sourceVersion),
      reviewedAtUtcMs: reviewedAtUtcMs == null && nullToAbsent
          ? const Value.absent()
          : Value(reviewedAtUtcMs),
      createdAtUtcMs: Value(createdAtUtcMs),
      updatedAtUtcMs: Value(updatedAtUtcMs),
    );
  }

  factory ContentTranslation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContentTranslation(
      id: serializer.fromJson<String>(json['id']),
      contentId: serializer.fromJson<String>(json['contentId']),
      locale: serializer.fromJson<String>(json['locale']),
      title: serializer.fromJson<String>(json['title']),
      summary: serializer.fromJson<String>(json['summary']),
      body: serializer.fromJson<String>(json['body']),
      translationStatus: serializer.fromJson<String>(json['translationStatus']),
      translationMethod: serializer.fromJson<String>(json['translationMethod']),
      sourceVersion: serializer.fromJson<int>(json['sourceVersion']),
      reviewedAtUtcMs: serializer.fromJson<int?>(json['reviewedAtUtcMs']),
      createdAtUtcMs: serializer.fromJson<int>(json['createdAtUtcMs']),
      updatedAtUtcMs: serializer.fromJson<int>(json['updatedAtUtcMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'contentId': serializer.toJson<String>(contentId),
      'locale': serializer.toJson<String>(locale),
      'title': serializer.toJson<String>(title),
      'summary': serializer.toJson<String>(summary),
      'body': serializer.toJson<String>(body),
      'translationStatus': serializer.toJson<String>(translationStatus),
      'translationMethod': serializer.toJson<String>(translationMethod),
      'sourceVersion': serializer.toJson<int>(sourceVersion),
      'reviewedAtUtcMs': serializer.toJson<int?>(reviewedAtUtcMs),
      'createdAtUtcMs': serializer.toJson<int>(createdAtUtcMs),
      'updatedAtUtcMs': serializer.toJson<int>(updatedAtUtcMs),
    };
  }

  ContentTranslation copyWith({
    String? id,
    String? contentId,
    String? locale,
    String? title,
    String? summary,
    String? body,
    String? translationStatus,
    String? translationMethod,
    int? sourceVersion,
    Value<int?> reviewedAtUtcMs = const Value.absent(),
    int? createdAtUtcMs,
    int? updatedAtUtcMs,
  }) => ContentTranslation(
    id: id ?? this.id,
    contentId: contentId ?? this.contentId,
    locale: locale ?? this.locale,
    title: title ?? this.title,
    summary: summary ?? this.summary,
    body: body ?? this.body,
    translationStatus: translationStatus ?? this.translationStatus,
    translationMethod: translationMethod ?? this.translationMethod,
    sourceVersion: sourceVersion ?? this.sourceVersion,
    reviewedAtUtcMs: reviewedAtUtcMs.present
        ? reviewedAtUtcMs.value
        : this.reviewedAtUtcMs,
    createdAtUtcMs: createdAtUtcMs ?? this.createdAtUtcMs,
    updatedAtUtcMs: updatedAtUtcMs ?? this.updatedAtUtcMs,
  );
  ContentTranslation copyWithCompanion(ContentTranslationsCompanion data) {
    return ContentTranslation(
      id: data.id.present ? data.id.value : this.id,
      contentId: data.contentId.present ? data.contentId.value : this.contentId,
      locale: data.locale.present ? data.locale.value : this.locale,
      title: data.title.present ? data.title.value : this.title,
      summary: data.summary.present ? data.summary.value : this.summary,
      body: data.body.present ? data.body.value : this.body,
      translationStatus: data.translationStatus.present
          ? data.translationStatus.value
          : this.translationStatus,
      translationMethod: data.translationMethod.present
          ? data.translationMethod.value
          : this.translationMethod,
      sourceVersion: data.sourceVersion.present
          ? data.sourceVersion.value
          : this.sourceVersion,
      reviewedAtUtcMs: data.reviewedAtUtcMs.present
          ? data.reviewedAtUtcMs.value
          : this.reviewedAtUtcMs,
      createdAtUtcMs: data.createdAtUtcMs.present
          ? data.createdAtUtcMs.value
          : this.createdAtUtcMs,
      updatedAtUtcMs: data.updatedAtUtcMs.present
          ? data.updatedAtUtcMs.value
          : this.updatedAtUtcMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContentTranslation(')
          ..write('id: $id, ')
          ..write('contentId: $contentId, ')
          ..write('locale: $locale, ')
          ..write('title: $title, ')
          ..write('summary: $summary, ')
          ..write('body: $body, ')
          ..write('translationStatus: $translationStatus, ')
          ..write('translationMethod: $translationMethod, ')
          ..write('sourceVersion: $sourceVersion, ')
          ..write('reviewedAtUtcMs: $reviewedAtUtcMs, ')
          ..write('createdAtUtcMs: $createdAtUtcMs, ')
          ..write('updatedAtUtcMs: $updatedAtUtcMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    contentId,
    locale,
    title,
    summary,
    body,
    translationStatus,
    translationMethod,
    sourceVersion,
    reviewedAtUtcMs,
    createdAtUtcMs,
    updatedAtUtcMs,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContentTranslation &&
          other.id == this.id &&
          other.contentId == this.contentId &&
          other.locale == this.locale &&
          other.title == this.title &&
          other.summary == this.summary &&
          other.body == this.body &&
          other.translationStatus == this.translationStatus &&
          other.translationMethod == this.translationMethod &&
          other.sourceVersion == this.sourceVersion &&
          other.reviewedAtUtcMs == this.reviewedAtUtcMs &&
          other.createdAtUtcMs == this.createdAtUtcMs &&
          other.updatedAtUtcMs == this.updatedAtUtcMs);
}

class ContentTranslationsCompanion extends UpdateCompanion<ContentTranslation> {
  final Value<String> id;
  final Value<String> contentId;
  final Value<String> locale;
  final Value<String> title;
  final Value<String> summary;
  final Value<String> body;
  final Value<String> translationStatus;
  final Value<String> translationMethod;
  final Value<int> sourceVersion;
  final Value<int?> reviewedAtUtcMs;
  final Value<int> createdAtUtcMs;
  final Value<int> updatedAtUtcMs;
  final Value<int> rowid;
  const ContentTranslationsCompanion({
    this.id = const Value.absent(),
    this.contentId = const Value.absent(),
    this.locale = const Value.absent(),
    this.title = const Value.absent(),
    this.summary = const Value.absent(),
    this.body = const Value.absent(),
    this.translationStatus = const Value.absent(),
    this.translationMethod = const Value.absent(),
    this.sourceVersion = const Value.absent(),
    this.reviewedAtUtcMs = const Value.absent(),
    this.createdAtUtcMs = const Value.absent(),
    this.updatedAtUtcMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContentTranslationsCompanion.insert({
    required String id,
    required String contentId,
    required String locale,
    required String title,
    required String summary,
    required String body,
    required String translationStatus,
    required String translationMethod,
    required int sourceVersion,
    this.reviewedAtUtcMs = const Value.absent(),
    required int createdAtUtcMs,
    required int updatedAtUtcMs,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       contentId = Value(contentId),
       locale = Value(locale),
       title = Value(title),
       summary = Value(summary),
       body = Value(body),
       translationStatus = Value(translationStatus),
       translationMethod = Value(translationMethod),
       sourceVersion = Value(sourceVersion),
       createdAtUtcMs = Value(createdAtUtcMs),
       updatedAtUtcMs = Value(updatedAtUtcMs);
  static Insertable<ContentTranslation> custom({
    Expression<String>? id,
    Expression<String>? contentId,
    Expression<String>? locale,
    Expression<String>? title,
    Expression<String>? summary,
    Expression<String>? body,
    Expression<String>? translationStatus,
    Expression<String>? translationMethod,
    Expression<int>? sourceVersion,
    Expression<int>? reviewedAtUtcMs,
    Expression<int>? createdAtUtcMs,
    Expression<int>? updatedAtUtcMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (contentId != null) 'content_id': contentId,
      if (locale != null) 'locale': locale,
      if (title != null) 'title': title,
      if (summary != null) 'summary': summary,
      if (body != null) 'body': body,
      if (translationStatus != null) 'translation_status': translationStatus,
      if (translationMethod != null) 'translation_method': translationMethod,
      if (sourceVersion != null) 'source_version': sourceVersion,
      if (reviewedAtUtcMs != null) 'reviewed_at_utc_ms': reviewedAtUtcMs,
      if (createdAtUtcMs != null) 'created_at_utc_ms': createdAtUtcMs,
      if (updatedAtUtcMs != null) 'updated_at_utc_ms': updatedAtUtcMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContentTranslationsCompanion copyWith({
    Value<String>? id,
    Value<String>? contentId,
    Value<String>? locale,
    Value<String>? title,
    Value<String>? summary,
    Value<String>? body,
    Value<String>? translationStatus,
    Value<String>? translationMethod,
    Value<int>? sourceVersion,
    Value<int?>? reviewedAtUtcMs,
    Value<int>? createdAtUtcMs,
    Value<int>? updatedAtUtcMs,
    Value<int>? rowid,
  }) {
    return ContentTranslationsCompanion(
      id: id ?? this.id,
      contentId: contentId ?? this.contentId,
      locale: locale ?? this.locale,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      body: body ?? this.body,
      translationStatus: translationStatus ?? this.translationStatus,
      translationMethod: translationMethod ?? this.translationMethod,
      sourceVersion: sourceVersion ?? this.sourceVersion,
      reviewedAtUtcMs: reviewedAtUtcMs ?? this.reviewedAtUtcMs,
      createdAtUtcMs: createdAtUtcMs ?? this.createdAtUtcMs,
      updatedAtUtcMs: updatedAtUtcMs ?? this.updatedAtUtcMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (contentId.present) {
      map['content_id'] = Variable<String>(contentId.value);
    }
    if (locale.present) {
      map['locale'] = Variable<String>(locale.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (translationStatus.present) {
      map['translation_status'] = Variable<String>(translationStatus.value);
    }
    if (translationMethod.present) {
      map['translation_method'] = Variable<String>(translationMethod.value);
    }
    if (sourceVersion.present) {
      map['source_version'] = Variable<int>(sourceVersion.value);
    }
    if (reviewedAtUtcMs.present) {
      map['reviewed_at_utc_ms'] = Variable<int>(reviewedAtUtcMs.value);
    }
    if (createdAtUtcMs.present) {
      map['created_at_utc_ms'] = Variable<int>(createdAtUtcMs.value);
    }
    if (updatedAtUtcMs.present) {
      map['updated_at_utc_ms'] = Variable<int>(updatedAtUtcMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContentTranslationsCompanion(')
          ..write('id: $id, ')
          ..write('contentId: $contentId, ')
          ..write('locale: $locale, ')
          ..write('title: $title, ')
          ..write('summary: $summary, ')
          ..write('body: $body, ')
          ..write('translationStatus: $translationStatus, ')
          ..write('translationMethod: $translationMethod, ')
          ..write('sourceVersion: $sourceVersion, ')
          ..write('reviewedAtUtcMs: $reviewedAtUtcMs, ')
          ..write('createdAtUtcMs: $createdAtUtcMs, ')
          ..write('updatedAtUtcMs: $updatedAtUtcMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContentSourcesTable extends ContentSources
    with TableInfo<$ContentSourcesTable, ContentSource> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContentSourcesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
    'author',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _publisherMeta = const VerificationMeta(
    'publisher',
  );
  @override
  late final GeneratedColumn<String> publisher = GeneratedColumn<String>(
    'publisher',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _publicationYearMeta = const VerificationMeta(
    'publicationYear',
  );
  @override
  late final GeneratedColumn<int> publicationYear = GeneratedColumn<int>(
    'publication_year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceUriMeta = const VerificationMeta(
    'sourceUri',
  );
  @override
  late final GeneratedColumn<String> sourceUri = GeneratedColumn<String>(
    'source_uri',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _originalLocaleMeta = const VerificationMeta(
    'originalLocale',
  );
  @override
  late final GeneratedColumn<String> originalLocale = GeneratedColumn<String>(
    'original_locale',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _licenseTypeMeta = const VerificationMeta(
    'licenseType',
  );
  @override
  late final GeneratedColumn<String> licenseType = GeneratedColumn<String>(
    'license_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _licenseReferenceMeta = const VerificationMeta(
    'licenseReference',
  );
  @override
  late final GeneratedColumn<String> licenseReference = GeneratedColumn<String>(
    'license_reference',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _attributionTextMeta = const VerificationMeta(
    'attributionText',
  );
  @override
  late final GeneratedColumn<String> attributionText = GeneratedColumn<String>(
    'attribution_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rightsStatusMeta = const VerificationMeta(
    'rightsStatus',
  );
  @override
  late final GeneratedColumn<String> rightsStatus = GeneratedColumn<String>(
    'rights_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtUtcMsMeta = const VerificationMeta(
    'createdAtUtcMs',
  );
  @override
  late final GeneratedColumn<int> createdAtUtcMs = GeneratedColumn<int>(
    'created_at_utc_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtUtcMsMeta = const VerificationMeta(
    'updatedAtUtcMs',
  );
  @override
  late final GeneratedColumn<int> updatedAtUtcMs = GeneratedColumn<int>(
    'updated_at_utc_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    author,
    publisher,
    publicationYear,
    sourceUri,
    originalLocale,
    licenseType,
    licenseReference,
    attributionText,
    rightsStatus,
    createdAtUtcMs,
    updatedAtUtcMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'content_sources';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContentSource> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('author')) {
      context.handle(
        _authorMeta,
        author.isAcceptableOrUnknown(data['author']!, _authorMeta),
      );
    }
    if (data.containsKey('publisher')) {
      context.handle(
        _publisherMeta,
        publisher.isAcceptableOrUnknown(data['publisher']!, _publisherMeta),
      );
    }
    if (data.containsKey('publication_year')) {
      context.handle(
        _publicationYearMeta,
        publicationYear.isAcceptableOrUnknown(
          data['publication_year']!,
          _publicationYearMeta,
        ),
      );
    }
    if (data.containsKey('source_uri')) {
      context.handle(
        _sourceUriMeta,
        sourceUri.isAcceptableOrUnknown(data['source_uri']!, _sourceUriMeta),
      );
    }
    if (data.containsKey('original_locale')) {
      context.handle(
        _originalLocaleMeta,
        originalLocale.isAcceptableOrUnknown(
          data['original_locale']!,
          _originalLocaleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originalLocaleMeta);
    }
    if (data.containsKey('license_type')) {
      context.handle(
        _licenseTypeMeta,
        licenseType.isAcceptableOrUnknown(
          data['license_type']!,
          _licenseTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_licenseTypeMeta);
    }
    if (data.containsKey('license_reference')) {
      context.handle(
        _licenseReferenceMeta,
        licenseReference.isAcceptableOrUnknown(
          data['license_reference']!,
          _licenseReferenceMeta,
        ),
      );
    }
    if (data.containsKey('attribution_text')) {
      context.handle(
        _attributionTextMeta,
        attributionText.isAcceptableOrUnknown(
          data['attribution_text']!,
          _attributionTextMeta,
        ),
      );
    }
    if (data.containsKey('rights_status')) {
      context.handle(
        _rightsStatusMeta,
        rightsStatus.isAcceptableOrUnknown(
          data['rights_status']!,
          _rightsStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rightsStatusMeta);
    }
    if (data.containsKey('created_at_utc_ms')) {
      context.handle(
        _createdAtUtcMsMeta,
        createdAtUtcMs.isAcceptableOrUnknown(
          data['created_at_utc_ms']!,
          _createdAtUtcMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtUtcMsMeta);
    }
    if (data.containsKey('updated_at_utc_ms')) {
      context.handle(
        _updatedAtUtcMsMeta,
        updatedAtUtcMs.isAcceptableOrUnknown(
          data['updated_at_utc_ms']!,
          _updatedAtUtcMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ContentSource map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContentSource(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      author: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author'],
      ),
      publisher: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}publisher'],
      ),
      publicationYear: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}publication_year'],
      ),
      sourceUri: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_uri'],
      ),
      originalLocale: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_locale'],
      )!,
      licenseType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}license_type'],
      )!,
      licenseReference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}license_reference'],
      ),
      attributionText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attribution_text'],
      ),
      rightsStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rights_status'],
      )!,
      createdAtUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_utc_ms'],
      )!,
      updatedAtUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_utc_ms'],
      )!,
    );
  }

  @override
  $ContentSourcesTable createAlias(String alias) {
    return $ContentSourcesTable(attachedDatabase, alias);
  }
}

class ContentSource extends DataClass implements Insertable<ContentSource> {
  final String id;
  final String title;
  final String? author;
  final String? publisher;
  final int? publicationYear;
  final String? sourceUri;
  final String originalLocale;
  final String licenseType;
  final String? licenseReference;
  final String? attributionText;
  final String rightsStatus;
  final int createdAtUtcMs;
  final int updatedAtUtcMs;
  const ContentSource({
    required this.id,
    required this.title,
    this.author,
    this.publisher,
    this.publicationYear,
    this.sourceUri,
    required this.originalLocale,
    required this.licenseType,
    this.licenseReference,
    this.attributionText,
    required this.rightsStatus,
    required this.createdAtUtcMs,
    required this.updatedAtUtcMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || author != null) {
      map['author'] = Variable<String>(author);
    }
    if (!nullToAbsent || publisher != null) {
      map['publisher'] = Variable<String>(publisher);
    }
    if (!nullToAbsent || publicationYear != null) {
      map['publication_year'] = Variable<int>(publicationYear);
    }
    if (!nullToAbsent || sourceUri != null) {
      map['source_uri'] = Variable<String>(sourceUri);
    }
    map['original_locale'] = Variable<String>(originalLocale);
    map['license_type'] = Variable<String>(licenseType);
    if (!nullToAbsent || licenseReference != null) {
      map['license_reference'] = Variable<String>(licenseReference);
    }
    if (!nullToAbsent || attributionText != null) {
      map['attribution_text'] = Variable<String>(attributionText);
    }
    map['rights_status'] = Variable<String>(rightsStatus);
    map['created_at_utc_ms'] = Variable<int>(createdAtUtcMs);
    map['updated_at_utc_ms'] = Variable<int>(updatedAtUtcMs);
    return map;
  }

  ContentSourcesCompanion toCompanion(bool nullToAbsent) {
    return ContentSourcesCompanion(
      id: Value(id),
      title: Value(title),
      author: author == null && nullToAbsent
          ? const Value.absent()
          : Value(author),
      publisher: publisher == null && nullToAbsent
          ? const Value.absent()
          : Value(publisher),
      publicationYear: publicationYear == null && nullToAbsent
          ? const Value.absent()
          : Value(publicationYear),
      sourceUri: sourceUri == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceUri),
      originalLocale: Value(originalLocale),
      licenseType: Value(licenseType),
      licenseReference: licenseReference == null && nullToAbsent
          ? const Value.absent()
          : Value(licenseReference),
      attributionText: attributionText == null && nullToAbsent
          ? const Value.absent()
          : Value(attributionText),
      rightsStatus: Value(rightsStatus),
      createdAtUtcMs: Value(createdAtUtcMs),
      updatedAtUtcMs: Value(updatedAtUtcMs),
    );
  }

  factory ContentSource.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContentSource(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      author: serializer.fromJson<String?>(json['author']),
      publisher: serializer.fromJson<String?>(json['publisher']),
      publicationYear: serializer.fromJson<int?>(json['publicationYear']),
      sourceUri: serializer.fromJson<String?>(json['sourceUri']),
      originalLocale: serializer.fromJson<String>(json['originalLocale']),
      licenseType: serializer.fromJson<String>(json['licenseType']),
      licenseReference: serializer.fromJson<String?>(json['licenseReference']),
      attributionText: serializer.fromJson<String?>(json['attributionText']),
      rightsStatus: serializer.fromJson<String>(json['rightsStatus']),
      createdAtUtcMs: serializer.fromJson<int>(json['createdAtUtcMs']),
      updatedAtUtcMs: serializer.fromJson<int>(json['updatedAtUtcMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'author': serializer.toJson<String?>(author),
      'publisher': serializer.toJson<String?>(publisher),
      'publicationYear': serializer.toJson<int?>(publicationYear),
      'sourceUri': serializer.toJson<String?>(sourceUri),
      'originalLocale': serializer.toJson<String>(originalLocale),
      'licenseType': serializer.toJson<String>(licenseType),
      'licenseReference': serializer.toJson<String?>(licenseReference),
      'attributionText': serializer.toJson<String?>(attributionText),
      'rightsStatus': serializer.toJson<String>(rightsStatus),
      'createdAtUtcMs': serializer.toJson<int>(createdAtUtcMs),
      'updatedAtUtcMs': serializer.toJson<int>(updatedAtUtcMs),
    };
  }

  ContentSource copyWith({
    String? id,
    String? title,
    Value<String?> author = const Value.absent(),
    Value<String?> publisher = const Value.absent(),
    Value<int?> publicationYear = const Value.absent(),
    Value<String?> sourceUri = const Value.absent(),
    String? originalLocale,
    String? licenseType,
    Value<String?> licenseReference = const Value.absent(),
    Value<String?> attributionText = const Value.absent(),
    String? rightsStatus,
    int? createdAtUtcMs,
    int? updatedAtUtcMs,
  }) => ContentSource(
    id: id ?? this.id,
    title: title ?? this.title,
    author: author.present ? author.value : this.author,
    publisher: publisher.present ? publisher.value : this.publisher,
    publicationYear: publicationYear.present
        ? publicationYear.value
        : this.publicationYear,
    sourceUri: sourceUri.present ? sourceUri.value : this.sourceUri,
    originalLocale: originalLocale ?? this.originalLocale,
    licenseType: licenseType ?? this.licenseType,
    licenseReference: licenseReference.present
        ? licenseReference.value
        : this.licenseReference,
    attributionText: attributionText.present
        ? attributionText.value
        : this.attributionText,
    rightsStatus: rightsStatus ?? this.rightsStatus,
    createdAtUtcMs: createdAtUtcMs ?? this.createdAtUtcMs,
    updatedAtUtcMs: updatedAtUtcMs ?? this.updatedAtUtcMs,
  );
  ContentSource copyWithCompanion(ContentSourcesCompanion data) {
    return ContentSource(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      author: data.author.present ? data.author.value : this.author,
      publisher: data.publisher.present ? data.publisher.value : this.publisher,
      publicationYear: data.publicationYear.present
          ? data.publicationYear.value
          : this.publicationYear,
      sourceUri: data.sourceUri.present ? data.sourceUri.value : this.sourceUri,
      originalLocale: data.originalLocale.present
          ? data.originalLocale.value
          : this.originalLocale,
      licenseType: data.licenseType.present
          ? data.licenseType.value
          : this.licenseType,
      licenseReference: data.licenseReference.present
          ? data.licenseReference.value
          : this.licenseReference,
      attributionText: data.attributionText.present
          ? data.attributionText.value
          : this.attributionText,
      rightsStatus: data.rightsStatus.present
          ? data.rightsStatus.value
          : this.rightsStatus,
      createdAtUtcMs: data.createdAtUtcMs.present
          ? data.createdAtUtcMs.value
          : this.createdAtUtcMs,
      updatedAtUtcMs: data.updatedAtUtcMs.present
          ? data.updatedAtUtcMs.value
          : this.updatedAtUtcMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContentSource(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('publisher: $publisher, ')
          ..write('publicationYear: $publicationYear, ')
          ..write('sourceUri: $sourceUri, ')
          ..write('originalLocale: $originalLocale, ')
          ..write('licenseType: $licenseType, ')
          ..write('licenseReference: $licenseReference, ')
          ..write('attributionText: $attributionText, ')
          ..write('rightsStatus: $rightsStatus, ')
          ..write('createdAtUtcMs: $createdAtUtcMs, ')
          ..write('updatedAtUtcMs: $updatedAtUtcMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    author,
    publisher,
    publicationYear,
    sourceUri,
    originalLocale,
    licenseType,
    licenseReference,
    attributionText,
    rightsStatus,
    createdAtUtcMs,
    updatedAtUtcMs,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContentSource &&
          other.id == this.id &&
          other.title == this.title &&
          other.author == this.author &&
          other.publisher == this.publisher &&
          other.publicationYear == this.publicationYear &&
          other.sourceUri == this.sourceUri &&
          other.originalLocale == this.originalLocale &&
          other.licenseType == this.licenseType &&
          other.licenseReference == this.licenseReference &&
          other.attributionText == this.attributionText &&
          other.rightsStatus == this.rightsStatus &&
          other.createdAtUtcMs == this.createdAtUtcMs &&
          other.updatedAtUtcMs == this.updatedAtUtcMs);
}

class ContentSourcesCompanion extends UpdateCompanion<ContentSource> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> author;
  final Value<String?> publisher;
  final Value<int?> publicationYear;
  final Value<String?> sourceUri;
  final Value<String> originalLocale;
  final Value<String> licenseType;
  final Value<String?> licenseReference;
  final Value<String?> attributionText;
  final Value<String> rightsStatus;
  final Value<int> createdAtUtcMs;
  final Value<int> updatedAtUtcMs;
  final Value<int> rowid;
  const ContentSourcesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.author = const Value.absent(),
    this.publisher = const Value.absent(),
    this.publicationYear = const Value.absent(),
    this.sourceUri = const Value.absent(),
    this.originalLocale = const Value.absent(),
    this.licenseType = const Value.absent(),
    this.licenseReference = const Value.absent(),
    this.attributionText = const Value.absent(),
    this.rightsStatus = const Value.absent(),
    this.createdAtUtcMs = const Value.absent(),
    this.updatedAtUtcMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContentSourcesCompanion.insert({
    required String id,
    required String title,
    this.author = const Value.absent(),
    this.publisher = const Value.absent(),
    this.publicationYear = const Value.absent(),
    this.sourceUri = const Value.absent(),
    required String originalLocale,
    required String licenseType,
    this.licenseReference = const Value.absent(),
    this.attributionText = const Value.absent(),
    required String rightsStatus,
    required int createdAtUtcMs,
    required int updatedAtUtcMs,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       originalLocale = Value(originalLocale),
       licenseType = Value(licenseType),
       rightsStatus = Value(rightsStatus),
       createdAtUtcMs = Value(createdAtUtcMs),
       updatedAtUtcMs = Value(updatedAtUtcMs);
  static Insertable<ContentSource> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? author,
    Expression<String>? publisher,
    Expression<int>? publicationYear,
    Expression<String>? sourceUri,
    Expression<String>? originalLocale,
    Expression<String>? licenseType,
    Expression<String>? licenseReference,
    Expression<String>? attributionText,
    Expression<String>? rightsStatus,
    Expression<int>? createdAtUtcMs,
    Expression<int>? updatedAtUtcMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (author != null) 'author': author,
      if (publisher != null) 'publisher': publisher,
      if (publicationYear != null) 'publication_year': publicationYear,
      if (sourceUri != null) 'source_uri': sourceUri,
      if (originalLocale != null) 'original_locale': originalLocale,
      if (licenseType != null) 'license_type': licenseType,
      if (licenseReference != null) 'license_reference': licenseReference,
      if (attributionText != null) 'attribution_text': attributionText,
      if (rightsStatus != null) 'rights_status': rightsStatus,
      if (createdAtUtcMs != null) 'created_at_utc_ms': createdAtUtcMs,
      if (updatedAtUtcMs != null) 'updated_at_utc_ms': updatedAtUtcMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContentSourcesCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? author,
    Value<String?>? publisher,
    Value<int?>? publicationYear,
    Value<String?>? sourceUri,
    Value<String>? originalLocale,
    Value<String>? licenseType,
    Value<String?>? licenseReference,
    Value<String?>? attributionText,
    Value<String>? rightsStatus,
    Value<int>? createdAtUtcMs,
    Value<int>? updatedAtUtcMs,
    Value<int>? rowid,
  }) {
    return ContentSourcesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      publisher: publisher ?? this.publisher,
      publicationYear: publicationYear ?? this.publicationYear,
      sourceUri: sourceUri ?? this.sourceUri,
      originalLocale: originalLocale ?? this.originalLocale,
      licenseType: licenseType ?? this.licenseType,
      licenseReference: licenseReference ?? this.licenseReference,
      attributionText: attributionText ?? this.attributionText,
      rightsStatus: rightsStatus ?? this.rightsStatus,
      createdAtUtcMs: createdAtUtcMs ?? this.createdAtUtcMs,
      updatedAtUtcMs: updatedAtUtcMs ?? this.updatedAtUtcMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (publisher.present) {
      map['publisher'] = Variable<String>(publisher.value);
    }
    if (publicationYear.present) {
      map['publication_year'] = Variable<int>(publicationYear.value);
    }
    if (sourceUri.present) {
      map['source_uri'] = Variable<String>(sourceUri.value);
    }
    if (originalLocale.present) {
      map['original_locale'] = Variable<String>(originalLocale.value);
    }
    if (licenseType.present) {
      map['license_type'] = Variable<String>(licenseType.value);
    }
    if (licenseReference.present) {
      map['license_reference'] = Variable<String>(licenseReference.value);
    }
    if (attributionText.present) {
      map['attribution_text'] = Variable<String>(attributionText.value);
    }
    if (rightsStatus.present) {
      map['rights_status'] = Variable<String>(rightsStatus.value);
    }
    if (createdAtUtcMs.present) {
      map['created_at_utc_ms'] = Variable<int>(createdAtUtcMs.value);
    }
    if (updatedAtUtcMs.present) {
      map['updated_at_utc_ms'] = Variable<int>(updatedAtUtcMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContentSourcesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('publisher: $publisher, ')
          ..write('publicationYear: $publicationYear, ')
          ..write('sourceUri: $sourceUri, ')
          ..write('originalLocale: $originalLocale, ')
          ..write('licenseType: $licenseType, ')
          ..write('licenseReference: $licenseReference, ')
          ..write('attributionText: $attributionText, ')
          ..write('rightsStatus: $rightsStatus, ')
          ..write('createdAtUtcMs: $createdAtUtcMs, ')
          ..write('updatedAtUtcMs: $updatedAtUtcMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContentItemSourcesTable extends ContentItemSources
    with TableInfo<$ContentItemSourcesTable, ContentItemSource> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContentItemSourcesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _contentIdMeta = const VerificationMeta(
    'contentId',
  );
  @override
  late final GeneratedColumn<String> contentId = GeneratedColumn<String>(
    'content_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [contentId, sourceId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'content_item_sources';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContentItemSource> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('content_id')) {
      context.handle(
        _contentIdMeta,
        contentId.isAcceptableOrUnknown(data['content_id']!, _contentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_contentIdMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {contentId, sourceId};
  @override
  ContentItemSource map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContentItemSource(
      contentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_id'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      )!,
    );
  }

  @override
  $ContentItemSourcesTable createAlias(String alias) {
    return $ContentItemSourcesTable(attachedDatabase, alias);
  }
}

class ContentItemSource extends DataClass
    implements Insertable<ContentItemSource> {
  final String contentId;
  final String sourceId;
  const ContentItemSource({required this.contentId, required this.sourceId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['content_id'] = Variable<String>(contentId);
    map['source_id'] = Variable<String>(sourceId);
    return map;
  }

  ContentItemSourcesCompanion toCompanion(bool nullToAbsent) {
    return ContentItemSourcesCompanion(
      contentId: Value(contentId),
      sourceId: Value(sourceId),
    );
  }

  factory ContentItemSource.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContentItemSource(
      contentId: serializer.fromJson<String>(json['contentId']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'contentId': serializer.toJson<String>(contentId),
      'sourceId': serializer.toJson<String>(sourceId),
    };
  }

  ContentItemSource copyWith({String? contentId, String? sourceId}) =>
      ContentItemSource(
        contentId: contentId ?? this.contentId,
        sourceId: sourceId ?? this.sourceId,
      );
  ContentItemSource copyWithCompanion(ContentItemSourcesCompanion data) {
    return ContentItemSource(
      contentId: data.contentId.present ? data.contentId.value : this.contentId,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContentItemSource(')
          ..write('contentId: $contentId, ')
          ..write('sourceId: $sourceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(contentId, sourceId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContentItemSource &&
          other.contentId == this.contentId &&
          other.sourceId == this.sourceId);
}

class ContentItemSourcesCompanion extends UpdateCompanion<ContentItemSource> {
  final Value<String> contentId;
  final Value<String> sourceId;
  final Value<int> rowid;
  const ContentItemSourcesCompanion({
    this.contentId = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContentItemSourcesCompanion.insert({
    required String contentId,
    required String sourceId,
    this.rowid = const Value.absent(),
  }) : contentId = Value(contentId),
       sourceId = Value(sourceId);
  static Insertable<ContentItemSource> custom({
    Expression<String>? contentId,
    Expression<String>? sourceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (contentId != null) 'content_id': contentId,
      if (sourceId != null) 'source_id': sourceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContentItemSourcesCompanion copyWith({
    Value<String>? contentId,
    Value<String>? sourceId,
    Value<int>? rowid,
  }) {
    return ContentItemSourcesCompanion(
      contentId: contentId ?? this.contentId,
      sourceId: sourceId ?? this.sourceId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (contentId.present) {
      map['content_id'] = Variable<String>(contentId.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContentItemSourcesCompanion(')
          ..write('contentId: $contentId, ')
          ..write('sourceId: $sourceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, Tag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, code];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {code},
  ];
  @override
  Tag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tag(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class Tag extends DataClass implements Insertable<Tag> {
  final String id;
  final String code;
  const Tag({required this.id, required this.code});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['code'] = Variable<String>(code);
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(id: Value(id), code: Value(code));
  }

  factory Tag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tag(
      id: serializer.fromJson<String>(json['id']),
      code: serializer.fromJson<String>(json['code']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'code': serializer.toJson<String>(code),
    };
  }

  Tag copyWith({String? id, String? code}) =>
      Tag(id: id ?? this.id, code: code ?? this.code);
  Tag copyWithCompanion(TagsCompanion data) {
    return Tag(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tag(')
          ..write('id: $id, ')
          ..write('code: $code')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, code);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tag && other.id == this.id && other.code == this.code);
}

class TagsCompanion extends UpdateCompanion<Tag> {
  final Value<String> id;
  final Value<String> code;
  final Value<int> rowid;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TagsCompanion.insert({
    required String id,
    required String code,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       code = Value(code);
  static Insertable<Tag> custom({
    Expression<String>? id,
    Expression<String>? code,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TagsCompanion copyWith({
    Value<String>? id,
    Value<String>? code,
    Value<int>? rowid,
  }) {
    return TagsCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TagTranslationsTable extends TagTranslations
    with TableInfo<$TagTranslationsTable, TagTranslation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagTranslationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<String> tagId = GeneratedColumn<String>(
    'tag_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localeMeta = const VerificationMeta('locale');
  @override
  late final GeneratedColumn<String> locale = GeneratedColumn<String>(
    'locale',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [tagId, locale, label];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tag_translations';
  @override
  VerificationContext validateIntegrity(
    Insertable<TagTranslation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    if (data.containsKey('locale')) {
      context.handle(
        _localeMeta,
        locale.isAcceptableOrUnknown(data['locale']!, _localeMeta),
      );
    } else if (isInserting) {
      context.missing(_localeMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {tagId, locale};
  @override
  TagTranslation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TagTranslation(
      tagId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag_id'],
      )!,
      locale: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locale'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
    );
  }

  @override
  $TagTranslationsTable createAlias(String alias) {
    return $TagTranslationsTable(attachedDatabase, alias);
  }
}

class TagTranslation extends DataClass implements Insertable<TagTranslation> {
  final String tagId;
  final String locale;
  final String label;
  const TagTranslation({
    required this.tagId,
    required this.locale,
    required this.label,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['tag_id'] = Variable<String>(tagId);
    map['locale'] = Variable<String>(locale);
    map['label'] = Variable<String>(label);
    return map;
  }

  TagTranslationsCompanion toCompanion(bool nullToAbsent) {
    return TagTranslationsCompanion(
      tagId: Value(tagId),
      locale: Value(locale),
      label: Value(label),
    );
  }

  factory TagTranslation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TagTranslation(
      tagId: serializer.fromJson<String>(json['tagId']),
      locale: serializer.fromJson<String>(json['locale']),
      label: serializer.fromJson<String>(json['label']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tagId': serializer.toJson<String>(tagId),
      'locale': serializer.toJson<String>(locale),
      'label': serializer.toJson<String>(label),
    };
  }

  TagTranslation copyWith({String? tagId, String? locale, String? label}) =>
      TagTranslation(
        tagId: tagId ?? this.tagId,
        locale: locale ?? this.locale,
        label: label ?? this.label,
      );
  TagTranslation copyWithCompanion(TagTranslationsCompanion data) {
    return TagTranslation(
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
      locale: data.locale.present ? data.locale.value : this.locale,
      label: data.label.present ? data.label.value : this.label,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TagTranslation(')
          ..write('tagId: $tagId, ')
          ..write('locale: $locale, ')
          ..write('label: $label')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(tagId, locale, label);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TagTranslation &&
          other.tagId == this.tagId &&
          other.locale == this.locale &&
          other.label == this.label);
}

class TagTranslationsCompanion extends UpdateCompanion<TagTranslation> {
  final Value<String> tagId;
  final Value<String> locale;
  final Value<String> label;
  final Value<int> rowid;
  const TagTranslationsCompanion({
    this.tagId = const Value.absent(),
    this.locale = const Value.absent(),
    this.label = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TagTranslationsCompanion.insert({
    required String tagId,
    required String locale,
    required String label,
    this.rowid = const Value.absent(),
  }) : tagId = Value(tagId),
       locale = Value(locale),
       label = Value(label);
  static Insertable<TagTranslation> custom({
    Expression<String>? tagId,
    Expression<String>? locale,
    Expression<String>? label,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (tagId != null) 'tag_id': tagId,
      if (locale != null) 'locale': locale,
      if (label != null) 'label': label,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TagTranslationsCompanion copyWith({
    Value<String>? tagId,
    Value<String>? locale,
    Value<String>? label,
    Value<int>? rowid,
  }) {
    return TagTranslationsCompanion(
      tagId: tagId ?? this.tagId,
      locale: locale ?? this.locale,
      label: label ?? this.label,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tagId.present) {
      map['tag_id'] = Variable<String>(tagId.value);
    }
    if (locale.present) {
      map['locale'] = Variable<String>(locale.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagTranslationsCompanion(')
          ..write('tagId: $tagId, ')
          ..write('locale: $locale, ')
          ..write('label: $label, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContentItemTagsTable extends ContentItemTags
    with TableInfo<$ContentItemTagsTable, ContentItemTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContentItemTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _contentIdMeta = const VerificationMeta(
    'contentId',
  );
  @override
  late final GeneratedColumn<String> contentId = GeneratedColumn<String>(
    'content_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<String> tagId = GeneratedColumn<String>(
    'tag_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [contentId, tagId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'content_item_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContentItemTag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('content_id')) {
      context.handle(
        _contentIdMeta,
        contentId.isAcceptableOrUnknown(data['content_id']!, _contentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_contentIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {contentId, tagId};
  @override
  ContentItemTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContentItemTag(
      contentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_id'],
      )!,
      tagId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag_id'],
      )!,
    );
  }

  @override
  $ContentItemTagsTable createAlias(String alias) {
    return $ContentItemTagsTable(attachedDatabase, alias);
  }
}

class ContentItemTag extends DataClass implements Insertable<ContentItemTag> {
  final String contentId;
  final String tagId;
  const ContentItemTag({required this.contentId, required this.tagId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['content_id'] = Variable<String>(contentId);
    map['tag_id'] = Variable<String>(tagId);
    return map;
  }

  ContentItemTagsCompanion toCompanion(bool nullToAbsent) {
    return ContentItemTagsCompanion(
      contentId: Value(contentId),
      tagId: Value(tagId),
    );
  }

  factory ContentItemTag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContentItemTag(
      contentId: serializer.fromJson<String>(json['contentId']),
      tagId: serializer.fromJson<String>(json['tagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'contentId': serializer.toJson<String>(contentId),
      'tagId': serializer.toJson<String>(tagId),
    };
  }

  ContentItemTag copyWith({String? contentId, String? tagId}) => ContentItemTag(
    contentId: contentId ?? this.contentId,
    tagId: tagId ?? this.tagId,
  );
  ContentItemTag copyWithCompanion(ContentItemTagsCompanion data) {
    return ContentItemTag(
      contentId: data.contentId.present ? data.contentId.value : this.contentId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContentItemTag(')
          ..write('contentId: $contentId, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(contentId, tagId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContentItemTag &&
          other.contentId == this.contentId &&
          other.tagId == this.tagId);
}

class ContentItemTagsCompanion extends UpdateCompanion<ContentItemTag> {
  final Value<String> contentId;
  final Value<String> tagId;
  final Value<int> rowid;
  const ContentItemTagsCompanion({
    this.contentId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContentItemTagsCompanion.insert({
    required String contentId,
    required String tagId,
    this.rowid = const Value.absent(),
  }) : contentId = Value(contentId),
       tagId = Value(tagId);
  static Insertable<ContentItemTag> custom({
    Expression<String>? contentId,
    Expression<String>? tagId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (contentId != null) 'content_id': contentId,
      if (tagId != null) 'tag_id': tagId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContentItemTagsCompanion copyWith({
    Value<String>? contentId,
    Value<String>? tagId,
    Value<int>? rowid,
  }) {
    return ContentItemTagsCompanion(
      contentId: contentId ?? this.contentId,
      tagId: tagId ?? this.tagId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (contentId.present) {
      map['content_id'] = Variable<String>(contentId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<String>(tagId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContentItemTagsCompanion(')
          ..write('contentId: $contentId, ')
          ..write('tagId: $tagId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserProfilesTable extends UserProfiles
    with TableInfo<$UserProfilesTable, UserProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _skillLevelMeta = const VerificationMeta(
    'skillLevel',
  );
  @override
  late final GeneratedColumn<String> skillLevel = GeneratedColumn<String>(
    'skill_level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _preferredLocaleMeta = const VerificationMeta(
    'preferredLocale',
  );
  @override
  late final GeneratedColumn<String> preferredLocale = GeneratedColumn<String>(
    'preferred_locale',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _themePreferenceMeta = const VerificationMeta(
    'themePreference',
  );
  @override
  late final GeneratedColumn<String> themePreference = GeneratedColumn<String>(
    'theme_preference',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtUtcMsMeta = const VerificationMeta(
    'createdAtUtcMs',
  );
  @override
  late final GeneratedColumn<int> createdAtUtcMs = GeneratedColumn<int>(
    'created_at_utc_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtUtcMsMeta = const VerificationMeta(
    'updatedAtUtcMs',
  );
  @override
  late final GeneratedColumn<int> updatedAtUtcMs = GeneratedColumn<int>(
    'updated_at_utc_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    skillLevel,
    preferredLocale,
    themePreference,
    createdAtUtcMs,
    updatedAtUtcMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('skill_level')) {
      context.handle(
        _skillLevelMeta,
        skillLevel.isAcceptableOrUnknown(data['skill_level']!, _skillLevelMeta),
      );
    } else if (isInserting) {
      context.missing(_skillLevelMeta);
    }
    if (data.containsKey('preferred_locale')) {
      context.handle(
        _preferredLocaleMeta,
        preferredLocale.isAcceptableOrUnknown(
          data['preferred_locale']!,
          _preferredLocaleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_preferredLocaleMeta);
    }
    if (data.containsKey('theme_preference')) {
      context.handle(
        _themePreferenceMeta,
        themePreference.isAcceptableOrUnknown(
          data['theme_preference']!,
          _themePreferenceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_themePreferenceMeta);
    }
    if (data.containsKey('created_at_utc_ms')) {
      context.handle(
        _createdAtUtcMsMeta,
        createdAtUtcMs.isAcceptableOrUnknown(
          data['created_at_utc_ms']!,
          _createdAtUtcMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtUtcMsMeta);
    }
    if (data.containsKey('updated_at_utc_ms')) {
      context.handle(
        _updatedAtUtcMsMeta,
        updatedAtUtcMs.isAcceptableOrUnknown(
          data['updated_at_utc_ms']!,
          _updatedAtUtcMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      skillLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}skill_level'],
      )!,
      preferredLocale: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preferred_locale'],
      )!,
      themePreference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_preference'],
      )!,
      createdAtUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_utc_ms'],
      )!,
      updatedAtUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_utc_ms'],
      )!,
    );
  }

  @override
  $UserProfilesTable createAlias(String alias) {
    return $UserProfilesTable(attachedDatabase, alias);
  }
}

class UserProfile extends DataClass implements Insertable<UserProfile> {
  final String id;
  final String skillLevel;
  final String preferredLocale;
  final String themePreference;
  final int createdAtUtcMs;
  final int updatedAtUtcMs;
  const UserProfile({
    required this.id,
    required this.skillLevel,
    required this.preferredLocale,
    required this.themePreference,
    required this.createdAtUtcMs,
    required this.updatedAtUtcMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['skill_level'] = Variable<String>(skillLevel);
    map['preferred_locale'] = Variable<String>(preferredLocale);
    map['theme_preference'] = Variable<String>(themePreference);
    map['created_at_utc_ms'] = Variable<int>(createdAtUtcMs);
    map['updated_at_utc_ms'] = Variable<int>(updatedAtUtcMs);
    return map;
  }

  UserProfilesCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesCompanion(
      id: Value(id),
      skillLevel: Value(skillLevel),
      preferredLocale: Value(preferredLocale),
      themePreference: Value(themePreference),
      createdAtUtcMs: Value(createdAtUtcMs),
      updatedAtUtcMs: Value(updatedAtUtcMs),
    );
  }

  factory UserProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfile(
      id: serializer.fromJson<String>(json['id']),
      skillLevel: serializer.fromJson<String>(json['skillLevel']),
      preferredLocale: serializer.fromJson<String>(json['preferredLocale']),
      themePreference: serializer.fromJson<String>(json['themePreference']),
      createdAtUtcMs: serializer.fromJson<int>(json['createdAtUtcMs']),
      updatedAtUtcMs: serializer.fromJson<int>(json['updatedAtUtcMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'skillLevel': serializer.toJson<String>(skillLevel),
      'preferredLocale': serializer.toJson<String>(preferredLocale),
      'themePreference': serializer.toJson<String>(themePreference),
      'createdAtUtcMs': serializer.toJson<int>(createdAtUtcMs),
      'updatedAtUtcMs': serializer.toJson<int>(updatedAtUtcMs),
    };
  }

  UserProfile copyWith({
    String? id,
    String? skillLevel,
    String? preferredLocale,
    String? themePreference,
    int? createdAtUtcMs,
    int? updatedAtUtcMs,
  }) => UserProfile(
    id: id ?? this.id,
    skillLevel: skillLevel ?? this.skillLevel,
    preferredLocale: preferredLocale ?? this.preferredLocale,
    themePreference: themePreference ?? this.themePreference,
    createdAtUtcMs: createdAtUtcMs ?? this.createdAtUtcMs,
    updatedAtUtcMs: updatedAtUtcMs ?? this.updatedAtUtcMs,
  );
  UserProfile copyWithCompanion(UserProfilesCompanion data) {
    return UserProfile(
      id: data.id.present ? data.id.value : this.id,
      skillLevel: data.skillLevel.present
          ? data.skillLevel.value
          : this.skillLevel,
      preferredLocale: data.preferredLocale.present
          ? data.preferredLocale.value
          : this.preferredLocale,
      themePreference: data.themePreference.present
          ? data.themePreference.value
          : this.themePreference,
      createdAtUtcMs: data.createdAtUtcMs.present
          ? data.createdAtUtcMs.value
          : this.createdAtUtcMs,
      updatedAtUtcMs: data.updatedAtUtcMs.present
          ? data.updatedAtUtcMs.value
          : this.updatedAtUtcMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfile(')
          ..write('id: $id, ')
          ..write('skillLevel: $skillLevel, ')
          ..write('preferredLocale: $preferredLocale, ')
          ..write('themePreference: $themePreference, ')
          ..write('createdAtUtcMs: $createdAtUtcMs, ')
          ..write('updatedAtUtcMs: $updatedAtUtcMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    skillLevel,
    preferredLocale,
    themePreference,
    createdAtUtcMs,
    updatedAtUtcMs,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfile &&
          other.id == this.id &&
          other.skillLevel == this.skillLevel &&
          other.preferredLocale == this.preferredLocale &&
          other.themePreference == this.themePreference &&
          other.createdAtUtcMs == this.createdAtUtcMs &&
          other.updatedAtUtcMs == this.updatedAtUtcMs);
}

class UserProfilesCompanion extends UpdateCompanion<UserProfile> {
  final Value<String> id;
  final Value<String> skillLevel;
  final Value<String> preferredLocale;
  final Value<String> themePreference;
  final Value<int> createdAtUtcMs;
  final Value<int> updatedAtUtcMs;
  final Value<int> rowid;
  const UserProfilesCompanion({
    this.id = const Value.absent(),
    this.skillLevel = const Value.absent(),
    this.preferredLocale = const Value.absent(),
    this.themePreference = const Value.absent(),
    this.createdAtUtcMs = const Value.absent(),
    this.updatedAtUtcMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserProfilesCompanion.insert({
    required String id,
    required String skillLevel,
    required String preferredLocale,
    required String themePreference,
    required int createdAtUtcMs,
    required int updatedAtUtcMs,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       skillLevel = Value(skillLevel),
       preferredLocale = Value(preferredLocale),
       themePreference = Value(themePreference),
       createdAtUtcMs = Value(createdAtUtcMs),
       updatedAtUtcMs = Value(updatedAtUtcMs);
  static Insertable<UserProfile> custom({
    Expression<String>? id,
    Expression<String>? skillLevel,
    Expression<String>? preferredLocale,
    Expression<String>? themePreference,
    Expression<int>? createdAtUtcMs,
    Expression<int>? updatedAtUtcMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (skillLevel != null) 'skill_level': skillLevel,
      if (preferredLocale != null) 'preferred_locale': preferredLocale,
      if (themePreference != null) 'theme_preference': themePreference,
      if (createdAtUtcMs != null) 'created_at_utc_ms': createdAtUtcMs,
      if (updatedAtUtcMs != null) 'updated_at_utc_ms': updatedAtUtcMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? skillLevel,
    Value<String>? preferredLocale,
    Value<String>? themePreference,
    Value<int>? createdAtUtcMs,
    Value<int>? updatedAtUtcMs,
    Value<int>? rowid,
  }) {
    return UserProfilesCompanion(
      id: id ?? this.id,
      skillLevel: skillLevel ?? this.skillLevel,
      preferredLocale: preferredLocale ?? this.preferredLocale,
      themePreference: themePreference ?? this.themePreference,
      createdAtUtcMs: createdAtUtcMs ?? this.createdAtUtcMs,
      updatedAtUtcMs: updatedAtUtcMs ?? this.updatedAtUtcMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (skillLevel.present) {
      map['skill_level'] = Variable<String>(skillLevel.value);
    }
    if (preferredLocale.present) {
      map['preferred_locale'] = Variable<String>(preferredLocale.value);
    }
    if (themePreference.present) {
      map['theme_preference'] = Variable<String>(themePreference.value);
    }
    if (createdAtUtcMs.present) {
      map['created_at_utc_ms'] = Variable<int>(createdAtUtcMs.value);
    }
    if (updatedAtUtcMs.present) {
      map['updated_at_utc_ms'] = Variable<int>(updatedAtUtcMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesCompanion(')
          ..write('id: $id, ')
          ..write('skillLevel: $skillLevel, ')
          ..write('preferredLocale: $preferredLocale, ')
          ..write('themePreference: $themePreference, ')
          ..write('createdAtUtcMs: $createdAtUtcMs, ')
          ..write('updatedAtUtcMs: $updatedAtUtcMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ContentItemsTable contentItems = $ContentItemsTable(this);
  late final $ContentTranslationsTable contentTranslations =
      $ContentTranslationsTable(this);
  late final $ContentSourcesTable contentSources = $ContentSourcesTable(this);
  late final $ContentItemSourcesTable contentItemSources =
      $ContentItemSourcesTable(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $TagTranslationsTable tagTranslations = $TagTranslationsTable(
    this,
  );
  late final $ContentItemTagsTable contentItemTags = $ContentItemTagsTable(
    this,
  );
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    contentItems,
    contentTranslations,
    contentSources,
    contentItemSources,
    tags,
    tagTranslations,
    contentItemTags,
    userProfiles,
  ];
}

typedef $$ContentItemsTableCreateCompanionBuilder =
    ContentItemsCompanion Function({
      required String id,
      required String type,
      required String primaryCategory,
      required String difficulty,
      required bool premium,
      required String canonicalLocale,
      required String editorialStatus,
      required int version,
      required int createdAtUtcMs,
      required int updatedAtUtcMs,
      Value<int?> publishedAtUtcMs,
      Value<int> rowid,
    });
typedef $$ContentItemsTableUpdateCompanionBuilder =
    ContentItemsCompanion Function({
      Value<String> id,
      Value<String> type,
      Value<String> primaryCategory,
      Value<String> difficulty,
      Value<bool> premium,
      Value<String> canonicalLocale,
      Value<String> editorialStatus,
      Value<int> version,
      Value<int> createdAtUtcMs,
      Value<int> updatedAtUtcMs,
      Value<int?> publishedAtUtcMs,
      Value<int> rowid,
    });

class $$ContentItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ContentItemsTable> {
  $$ContentItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get primaryCategory => $composableBuilder(
    column: $table.primaryCategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get premium => $composableBuilder(
    column: $table.premium,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get canonicalLocale => $composableBuilder(
    column: $table.canonicalLocale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get editorialStatus => $composableBuilder(
    column: $table.editorialStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtUtcMs => $composableBuilder(
    column: $table.createdAtUtcMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtUtcMs => $composableBuilder(
    column: $table.updatedAtUtcMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get publishedAtUtcMs => $composableBuilder(
    column: $table.publishedAtUtcMs,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ContentItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ContentItemsTable> {
  $$ContentItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get primaryCategory => $composableBuilder(
    column: $table.primaryCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get premium => $composableBuilder(
    column: $table.premium,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get canonicalLocale => $composableBuilder(
    column: $table.canonicalLocale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get editorialStatus => $composableBuilder(
    column: $table.editorialStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtUtcMs => $composableBuilder(
    column: $table.createdAtUtcMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtUtcMs => $composableBuilder(
    column: $table.updatedAtUtcMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get publishedAtUtcMs => $composableBuilder(
    column: $table.publishedAtUtcMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ContentItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContentItemsTable> {
  $$ContentItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get primaryCategory => $composableBuilder(
    column: $table.primaryCategory,
    builder: (column) => column,
  );

  GeneratedColumn<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get premium =>
      $composableBuilder(column: $table.premium, builder: (column) => column);

  GeneratedColumn<String> get canonicalLocale => $composableBuilder(
    column: $table.canonicalLocale,
    builder: (column) => column,
  );

  GeneratedColumn<String> get editorialStatus => $composableBuilder(
    column: $table.editorialStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<int> get createdAtUtcMs => $composableBuilder(
    column: $table.createdAtUtcMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAtUtcMs => $composableBuilder(
    column: $table.updatedAtUtcMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get publishedAtUtcMs => $composableBuilder(
    column: $table.publishedAtUtcMs,
    builder: (column) => column,
  );
}

class $$ContentItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContentItemsTable,
          ContentItem,
          $$ContentItemsTableFilterComposer,
          $$ContentItemsTableOrderingComposer,
          $$ContentItemsTableAnnotationComposer,
          $$ContentItemsTableCreateCompanionBuilder,
          $$ContentItemsTableUpdateCompanionBuilder,
          (
            ContentItem,
            BaseReferences<_$AppDatabase, $ContentItemsTable, ContentItem>,
          ),
          ContentItem,
          PrefetchHooks Function()
        > {
  $$ContentItemsTableTableManager(_$AppDatabase db, $ContentItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContentItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContentItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContentItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> primaryCategory = const Value.absent(),
                Value<String> difficulty = const Value.absent(),
                Value<bool> premium = const Value.absent(),
                Value<String> canonicalLocale = const Value.absent(),
                Value<String> editorialStatus = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> createdAtUtcMs = const Value.absent(),
                Value<int> updatedAtUtcMs = const Value.absent(),
                Value<int?> publishedAtUtcMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContentItemsCompanion(
                id: id,
                type: type,
                primaryCategory: primaryCategory,
                difficulty: difficulty,
                premium: premium,
                canonicalLocale: canonicalLocale,
                editorialStatus: editorialStatus,
                version: version,
                createdAtUtcMs: createdAtUtcMs,
                updatedAtUtcMs: updatedAtUtcMs,
                publishedAtUtcMs: publishedAtUtcMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String type,
                required String primaryCategory,
                required String difficulty,
                required bool premium,
                required String canonicalLocale,
                required String editorialStatus,
                required int version,
                required int createdAtUtcMs,
                required int updatedAtUtcMs,
                Value<int?> publishedAtUtcMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContentItemsCompanion.insert(
                id: id,
                type: type,
                primaryCategory: primaryCategory,
                difficulty: difficulty,
                premium: premium,
                canonicalLocale: canonicalLocale,
                editorialStatus: editorialStatus,
                version: version,
                createdAtUtcMs: createdAtUtcMs,
                updatedAtUtcMs: updatedAtUtcMs,
                publishedAtUtcMs: publishedAtUtcMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ContentItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContentItemsTable,
      ContentItem,
      $$ContentItemsTableFilterComposer,
      $$ContentItemsTableOrderingComposer,
      $$ContentItemsTableAnnotationComposer,
      $$ContentItemsTableCreateCompanionBuilder,
      $$ContentItemsTableUpdateCompanionBuilder,
      (
        ContentItem,
        BaseReferences<_$AppDatabase, $ContentItemsTable, ContentItem>,
      ),
      ContentItem,
      PrefetchHooks Function()
    >;
typedef $$ContentTranslationsTableCreateCompanionBuilder =
    ContentTranslationsCompanion Function({
      required String id,
      required String contentId,
      required String locale,
      required String title,
      required String summary,
      required String body,
      required String translationStatus,
      required String translationMethod,
      required int sourceVersion,
      Value<int?> reviewedAtUtcMs,
      required int createdAtUtcMs,
      required int updatedAtUtcMs,
      Value<int> rowid,
    });
typedef $$ContentTranslationsTableUpdateCompanionBuilder =
    ContentTranslationsCompanion Function({
      Value<String> id,
      Value<String> contentId,
      Value<String> locale,
      Value<String> title,
      Value<String> summary,
      Value<String> body,
      Value<String> translationStatus,
      Value<String> translationMethod,
      Value<int> sourceVersion,
      Value<int?> reviewedAtUtcMs,
      Value<int> createdAtUtcMs,
      Value<int> updatedAtUtcMs,
      Value<int> rowid,
    });

class $$ContentTranslationsTableFilterComposer
    extends Composer<_$AppDatabase, $ContentTranslationsTable> {
  $$ContentTranslationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translationStatus => $composableBuilder(
    column: $table.translationStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translationMethod => $composableBuilder(
    column: $table.translationMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sourceVersion => $composableBuilder(
    column: $table.sourceVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reviewedAtUtcMs => $composableBuilder(
    column: $table.reviewedAtUtcMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtUtcMs => $composableBuilder(
    column: $table.createdAtUtcMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtUtcMs => $composableBuilder(
    column: $table.updatedAtUtcMs,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ContentTranslationsTableOrderingComposer
    extends Composer<_$AppDatabase, $ContentTranslationsTable> {
  $$ContentTranslationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translationStatus => $composableBuilder(
    column: $table.translationStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translationMethod => $composableBuilder(
    column: $table.translationMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sourceVersion => $composableBuilder(
    column: $table.sourceVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reviewedAtUtcMs => $composableBuilder(
    column: $table.reviewedAtUtcMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtUtcMs => $composableBuilder(
    column: $table.createdAtUtcMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtUtcMs => $composableBuilder(
    column: $table.updatedAtUtcMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ContentTranslationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContentTranslationsTable> {
  $$ContentTranslationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get contentId =>
      $composableBuilder(column: $table.contentId, builder: (column) => column);

  GeneratedColumn<String> get locale =>
      $composableBuilder(column: $table.locale, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get translationStatus => $composableBuilder(
    column: $table.translationStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get translationMethod => $composableBuilder(
    column: $table.translationMethod,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sourceVersion => $composableBuilder(
    column: $table.sourceVersion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reviewedAtUtcMs => $composableBuilder(
    column: $table.reviewedAtUtcMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAtUtcMs => $composableBuilder(
    column: $table.createdAtUtcMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAtUtcMs => $composableBuilder(
    column: $table.updatedAtUtcMs,
    builder: (column) => column,
  );
}

class $$ContentTranslationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContentTranslationsTable,
          ContentTranslation,
          $$ContentTranslationsTableFilterComposer,
          $$ContentTranslationsTableOrderingComposer,
          $$ContentTranslationsTableAnnotationComposer,
          $$ContentTranslationsTableCreateCompanionBuilder,
          $$ContentTranslationsTableUpdateCompanionBuilder,
          (
            ContentTranslation,
            BaseReferences<
              _$AppDatabase,
              $ContentTranslationsTable,
              ContentTranslation
            >,
          ),
          ContentTranslation,
          PrefetchHooks Function()
        > {
  $$ContentTranslationsTableTableManager(
    _$AppDatabase db,
    $ContentTranslationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContentTranslationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContentTranslationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ContentTranslationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> contentId = const Value.absent(),
                Value<String> locale = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> summary = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String> translationStatus = const Value.absent(),
                Value<String> translationMethod = const Value.absent(),
                Value<int> sourceVersion = const Value.absent(),
                Value<int?> reviewedAtUtcMs = const Value.absent(),
                Value<int> createdAtUtcMs = const Value.absent(),
                Value<int> updatedAtUtcMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContentTranslationsCompanion(
                id: id,
                contentId: contentId,
                locale: locale,
                title: title,
                summary: summary,
                body: body,
                translationStatus: translationStatus,
                translationMethod: translationMethod,
                sourceVersion: sourceVersion,
                reviewedAtUtcMs: reviewedAtUtcMs,
                createdAtUtcMs: createdAtUtcMs,
                updatedAtUtcMs: updatedAtUtcMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String contentId,
                required String locale,
                required String title,
                required String summary,
                required String body,
                required String translationStatus,
                required String translationMethod,
                required int sourceVersion,
                Value<int?> reviewedAtUtcMs = const Value.absent(),
                required int createdAtUtcMs,
                required int updatedAtUtcMs,
                Value<int> rowid = const Value.absent(),
              }) => ContentTranslationsCompanion.insert(
                id: id,
                contentId: contentId,
                locale: locale,
                title: title,
                summary: summary,
                body: body,
                translationStatus: translationStatus,
                translationMethod: translationMethod,
                sourceVersion: sourceVersion,
                reviewedAtUtcMs: reviewedAtUtcMs,
                createdAtUtcMs: createdAtUtcMs,
                updatedAtUtcMs: updatedAtUtcMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ContentTranslationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContentTranslationsTable,
      ContentTranslation,
      $$ContentTranslationsTableFilterComposer,
      $$ContentTranslationsTableOrderingComposer,
      $$ContentTranslationsTableAnnotationComposer,
      $$ContentTranslationsTableCreateCompanionBuilder,
      $$ContentTranslationsTableUpdateCompanionBuilder,
      (
        ContentTranslation,
        BaseReferences<
          _$AppDatabase,
          $ContentTranslationsTable,
          ContentTranslation
        >,
      ),
      ContentTranslation,
      PrefetchHooks Function()
    >;
typedef $$ContentSourcesTableCreateCompanionBuilder =
    ContentSourcesCompanion Function({
      required String id,
      required String title,
      Value<String?> author,
      Value<String?> publisher,
      Value<int?> publicationYear,
      Value<String?> sourceUri,
      required String originalLocale,
      required String licenseType,
      Value<String?> licenseReference,
      Value<String?> attributionText,
      required String rightsStatus,
      required int createdAtUtcMs,
      required int updatedAtUtcMs,
      Value<int> rowid,
    });
typedef $$ContentSourcesTableUpdateCompanionBuilder =
    ContentSourcesCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String?> author,
      Value<String?> publisher,
      Value<int?> publicationYear,
      Value<String?> sourceUri,
      Value<String> originalLocale,
      Value<String> licenseType,
      Value<String?> licenseReference,
      Value<String?> attributionText,
      Value<String> rightsStatus,
      Value<int> createdAtUtcMs,
      Value<int> updatedAtUtcMs,
      Value<int> rowid,
    });

class $$ContentSourcesTableFilterComposer
    extends Composer<_$AppDatabase, $ContentSourcesTable> {
  $$ContentSourcesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get publisher => $composableBuilder(
    column: $table.publisher,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get publicationYear => $composableBuilder(
    column: $table.publicationYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceUri => $composableBuilder(
    column: $table.sourceUri,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalLocale => $composableBuilder(
    column: $table.originalLocale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get licenseType => $composableBuilder(
    column: $table.licenseType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get licenseReference => $composableBuilder(
    column: $table.licenseReference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get attributionText => $composableBuilder(
    column: $table.attributionText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rightsStatus => $composableBuilder(
    column: $table.rightsStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtUtcMs => $composableBuilder(
    column: $table.createdAtUtcMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtUtcMs => $composableBuilder(
    column: $table.updatedAtUtcMs,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ContentSourcesTableOrderingComposer
    extends Composer<_$AppDatabase, $ContentSourcesTable> {
  $$ContentSourcesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get publisher => $composableBuilder(
    column: $table.publisher,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get publicationYear => $composableBuilder(
    column: $table.publicationYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceUri => $composableBuilder(
    column: $table.sourceUri,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalLocale => $composableBuilder(
    column: $table.originalLocale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get licenseType => $composableBuilder(
    column: $table.licenseType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get licenseReference => $composableBuilder(
    column: $table.licenseReference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get attributionText => $composableBuilder(
    column: $table.attributionText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rightsStatus => $composableBuilder(
    column: $table.rightsStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtUtcMs => $composableBuilder(
    column: $table.createdAtUtcMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtUtcMs => $composableBuilder(
    column: $table.updatedAtUtcMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ContentSourcesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContentSourcesTable> {
  $$ContentSourcesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<String> get publisher =>
      $composableBuilder(column: $table.publisher, builder: (column) => column);

  GeneratedColumn<int> get publicationYear => $composableBuilder(
    column: $table.publicationYear,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceUri =>
      $composableBuilder(column: $table.sourceUri, builder: (column) => column);

  GeneratedColumn<String> get originalLocale => $composableBuilder(
    column: $table.originalLocale,
    builder: (column) => column,
  );

  GeneratedColumn<String> get licenseType => $composableBuilder(
    column: $table.licenseType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get licenseReference => $composableBuilder(
    column: $table.licenseReference,
    builder: (column) => column,
  );

  GeneratedColumn<String> get attributionText => $composableBuilder(
    column: $table.attributionText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rightsStatus => $composableBuilder(
    column: $table.rightsStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAtUtcMs => $composableBuilder(
    column: $table.createdAtUtcMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAtUtcMs => $composableBuilder(
    column: $table.updatedAtUtcMs,
    builder: (column) => column,
  );
}

class $$ContentSourcesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContentSourcesTable,
          ContentSource,
          $$ContentSourcesTableFilterComposer,
          $$ContentSourcesTableOrderingComposer,
          $$ContentSourcesTableAnnotationComposer,
          $$ContentSourcesTableCreateCompanionBuilder,
          $$ContentSourcesTableUpdateCompanionBuilder,
          (
            ContentSource,
            BaseReferences<_$AppDatabase, $ContentSourcesTable, ContentSource>,
          ),
          ContentSource,
          PrefetchHooks Function()
        > {
  $$ContentSourcesTableTableManager(
    _$AppDatabase db,
    $ContentSourcesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContentSourcesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContentSourcesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContentSourcesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> author = const Value.absent(),
                Value<String?> publisher = const Value.absent(),
                Value<int?> publicationYear = const Value.absent(),
                Value<String?> sourceUri = const Value.absent(),
                Value<String> originalLocale = const Value.absent(),
                Value<String> licenseType = const Value.absent(),
                Value<String?> licenseReference = const Value.absent(),
                Value<String?> attributionText = const Value.absent(),
                Value<String> rightsStatus = const Value.absent(),
                Value<int> createdAtUtcMs = const Value.absent(),
                Value<int> updatedAtUtcMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContentSourcesCompanion(
                id: id,
                title: title,
                author: author,
                publisher: publisher,
                publicationYear: publicationYear,
                sourceUri: sourceUri,
                originalLocale: originalLocale,
                licenseType: licenseType,
                licenseReference: licenseReference,
                attributionText: attributionText,
                rightsStatus: rightsStatus,
                createdAtUtcMs: createdAtUtcMs,
                updatedAtUtcMs: updatedAtUtcMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String?> author = const Value.absent(),
                Value<String?> publisher = const Value.absent(),
                Value<int?> publicationYear = const Value.absent(),
                Value<String?> sourceUri = const Value.absent(),
                required String originalLocale,
                required String licenseType,
                Value<String?> licenseReference = const Value.absent(),
                Value<String?> attributionText = const Value.absent(),
                required String rightsStatus,
                required int createdAtUtcMs,
                required int updatedAtUtcMs,
                Value<int> rowid = const Value.absent(),
              }) => ContentSourcesCompanion.insert(
                id: id,
                title: title,
                author: author,
                publisher: publisher,
                publicationYear: publicationYear,
                sourceUri: sourceUri,
                originalLocale: originalLocale,
                licenseType: licenseType,
                licenseReference: licenseReference,
                attributionText: attributionText,
                rightsStatus: rightsStatus,
                createdAtUtcMs: createdAtUtcMs,
                updatedAtUtcMs: updatedAtUtcMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ContentSourcesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContentSourcesTable,
      ContentSource,
      $$ContentSourcesTableFilterComposer,
      $$ContentSourcesTableOrderingComposer,
      $$ContentSourcesTableAnnotationComposer,
      $$ContentSourcesTableCreateCompanionBuilder,
      $$ContentSourcesTableUpdateCompanionBuilder,
      (
        ContentSource,
        BaseReferences<_$AppDatabase, $ContentSourcesTable, ContentSource>,
      ),
      ContentSource,
      PrefetchHooks Function()
    >;
typedef $$ContentItemSourcesTableCreateCompanionBuilder =
    ContentItemSourcesCompanion Function({
      required String contentId,
      required String sourceId,
      Value<int> rowid,
    });
typedef $$ContentItemSourcesTableUpdateCompanionBuilder =
    ContentItemSourcesCompanion Function({
      Value<String> contentId,
      Value<String> sourceId,
      Value<int> rowid,
    });

class $$ContentItemSourcesTableFilterComposer
    extends Composer<_$AppDatabase, $ContentItemSourcesTable> {
  $$ContentItemSourcesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ContentItemSourcesTableOrderingComposer
    extends Composer<_$AppDatabase, $ContentItemSourcesTable> {
  $$ContentItemSourcesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ContentItemSourcesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContentItemSourcesTable> {
  $$ContentItemSourcesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get contentId =>
      $composableBuilder(column: $table.contentId, builder: (column) => column);

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);
}

class $$ContentItemSourcesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContentItemSourcesTable,
          ContentItemSource,
          $$ContentItemSourcesTableFilterComposer,
          $$ContentItemSourcesTableOrderingComposer,
          $$ContentItemSourcesTableAnnotationComposer,
          $$ContentItemSourcesTableCreateCompanionBuilder,
          $$ContentItemSourcesTableUpdateCompanionBuilder,
          (
            ContentItemSource,
            BaseReferences<
              _$AppDatabase,
              $ContentItemSourcesTable,
              ContentItemSource
            >,
          ),
          ContentItemSource,
          PrefetchHooks Function()
        > {
  $$ContentItemSourcesTableTableManager(
    _$AppDatabase db,
    $ContentItemSourcesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContentItemSourcesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContentItemSourcesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContentItemSourcesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> contentId = const Value.absent(),
                Value<String> sourceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContentItemSourcesCompanion(
                contentId: contentId,
                sourceId: sourceId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String contentId,
                required String sourceId,
                Value<int> rowid = const Value.absent(),
              }) => ContentItemSourcesCompanion.insert(
                contentId: contentId,
                sourceId: sourceId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ContentItemSourcesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContentItemSourcesTable,
      ContentItemSource,
      $$ContentItemSourcesTableFilterComposer,
      $$ContentItemSourcesTableOrderingComposer,
      $$ContentItemSourcesTableAnnotationComposer,
      $$ContentItemSourcesTableCreateCompanionBuilder,
      $$ContentItemSourcesTableUpdateCompanionBuilder,
      (
        ContentItemSource,
        BaseReferences<
          _$AppDatabase,
          $ContentItemSourcesTable,
          ContentItemSource
        >,
      ),
      ContentItemSource,
      PrefetchHooks Function()
    >;
typedef $$TagsTableCreateCompanionBuilder =
    TagsCompanion Function({
      required String id,
      required String code,
      Value<int> rowid,
    });
typedef $$TagsTableUpdateCompanionBuilder =
    TagsCompanion Function({
      Value<String> id,
      Value<String> code,
      Value<int> rowid,
    });

class $$TagsTableFilterComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TagsTableOrderingComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);
}

class $$TagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TagsTable,
          Tag,
          $$TagsTableFilterComposer,
          $$TagsTableOrderingComposer,
          $$TagsTableAnnotationComposer,
          $$TagsTableCreateCompanionBuilder,
          $$TagsTableUpdateCompanionBuilder,
          (Tag, BaseReferences<_$AppDatabase, $TagsTable, Tag>),
          Tag,
          PrefetchHooks Function()
        > {
  $$TagsTableTableManager(_$AppDatabase db, $TagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TagsCompanion(id: id, code: code, rowid: rowid),
          createCompanionCallback:
              ({
                required String id,
                required String code,
                Value<int> rowid = const Value.absent(),
              }) => TagsCompanion.insert(id: id, code: code, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TagsTable,
      Tag,
      $$TagsTableFilterComposer,
      $$TagsTableOrderingComposer,
      $$TagsTableAnnotationComposer,
      $$TagsTableCreateCompanionBuilder,
      $$TagsTableUpdateCompanionBuilder,
      (Tag, BaseReferences<_$AppDatabase, $TagsTable, Tag>),
      Tag,
      PrefetchHooks Function()
    >;
typedef $$TagTranslationsTableCreateCompanionBuilder =
    TagTranslationsCompanion Function({
      required String tagId,
      required String locale,
      required String label,
      Value<int> rowid,
    });
typedef $$TagTranslationsTableUpdateCompanionBuilder =
    TagTranslationsCompanion Function({
      Value<String> tagId,
      Value<String> locale,
      Value<String> label,
      Value<int> rowid,
    });

class $$TagTranslationsTableFilterComposer
    extends Composer<_$AppDatabase, $TagTranslationsTable> {
  $$TagTranslationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get tagId => $composableBuilder(
    column: $table.tagId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TagTranslationsTableOrderingComposer
    extends Composer<_$AppDatabase, $TagTranslationsTable> {
  $$TagTranslationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get tagId => $composableBuilder(
    column: $table.tagId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TagTranslationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagTranslationsTable> {
  $$TagTranslationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get tagId =>
      $composableBuilder(column: $table.tagId, builder: (column) => column);

  GeneratedColumn<String> get locale =>
      $composableBuilder(column: $table.locale, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);
}

class $$TagTranslationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TagTranslationsTable,
          TagTranslation,
          $$TagTranslationsTableFilterComposer,
          $$TagTranslationsTableOrderingComposer,
          $$TagTranslationsTableAnnotationComposer,
          $$TagTranslationsTableCreateCompanionBuilder,
          $$TagTranslationsTableUpdateCompanionBuilder,
          (
            TagTranslation,
            BaseReferences<
              _$AppDatabase,
              $TagTranslationsTable,
              TagTranslation
            >,
          ),
          TagTranslation,
          PrefetchHooks Function()
        > {
  $$TagTranslationsTableTableManager(
    _$AppDatabase db,
    $TagTranslationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagTranslationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagTranslationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagTranslationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> tagId = const Value.absent(),
                Value<String> locale = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TagTranslationsCompanion(
                tagId: tagId,
                locale: locale,
                label: label,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String tagId,
                required String locale,
                required String label,
                Value<int> rowid = const Value.absent(),
              }) => TagTranslationsCompanion.insert(
                tagId: tagId,
                locale: locale,
                label: label,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TagTranslationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TagTranslationsTable,
      TagTranslation,
      $$TagTranslationsTableFilterComposer,
      $$TagTranslationsTableOrderingComposer,
      $$TagTranslationsTableAnnotationComposer,
      $$TagTranslationsTableCreateCompanionBuilder,
      $$TagTranslationsTableUpdateCompanionBuilder,
      (
        TagTranslation,
        BaseReferences<_$AppDatabase, $TagTranslationsTable, TagTranslation>,
      ),
      TagTranslation,
      PrefetchHooks Function()
    >;
typedef $$ContentItemTagsTableCreateCompanionBuilder =
    ContentItemTagsCompanion Function({
      required String contentId,
      required String tagId,
      Value<int> rowid,
    });
typedef $$ContentItemTagsTableUpdateCompanionBuilder =
    ContentItemTagsCompanion Function({
      Value<String> contentId,
      Value<String> tagId,
      Value<int> rowid,
    });

class $$ContentItemTagsTableFilterComposer
    extends Composer<_$AppDatabase, $ContentItemTagsTable> {
  $$ContentItemTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tagId => $composableBuilder(
    column: $table.tagId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ContentItemTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $ContentItemTagsTable> {
  $$ContentItemTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagId => $composableBuilder(
    column: $table.tagId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ContentItemTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContentItemTagsTable> {
  $$ContentItemTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get contentId =>
      $composableBuilder(column: $table.contentId, builder: (column) => column);

  GeneratedColumn<String> get tagId =>
      $composableBuilder(column: $table.tagId, builder: (column) => column);
}

class $$ContentItemTagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContentItemTagsTable,
          ContentItemTag,
          $$ContentItemTagsTableFilterComposer,
          $$ContentItemTagsTableOrderingComposer,
          $$ContentItemTagsTableAnnotationComposer,
          $$ContentItemTagsTableCreateCompanionBuilder,
          $$ContentItemTagsTableUpdateCompanionBuilder,
          (
            ContentItemTag,
            BaseReferences<
              _$AppDatabase,
              $ContentItemTagsTable,
              ContentItemTag
            >,
          ),
          ContentItemTag,
          PrefetchHooks Function()
        > {
  $$ContentItemTagsTableTableManager(
    _$AppDatabase db,
    $ContentItemTagsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContentItemTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContentItemTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContentItemTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> contentId = const Value.absent(),
                Value<String> tagId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContentItemTagsCompanion(
                contentId: contentId,
                tagId: tagId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String contentId,
                required String tagId,
                Value<int> rowid = const Value.absent(),
              }) => ContentItemTagsCompanion.insert(
                contentId: contentId,
                tagId: tagId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ContentItemTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContentItemTagsTable,
      ContentItemTag,
      $$ContentItemTagsTableFilterComposer,
      $$ContentItemTagsTableOrderingComposer,
      $$ContentItemTagsTableAnnotationComposer,
      $$ContentItemTagsTableCreateCompanionBuilder,
      $$ContentItemTagsTableUpdateCompanionBuilder,
      (
        ContentItemTag,
        BaseReferences<_$AppDatabase, $ContentItemTagsTable, ContentItemTag>,
      ),
      ContentItemTag,
      PrefetchHooks Function()
    >;
typedef $$UserProfilesTableCreateCompanionBuilder =
    UserProfilesCompanion Function({
      required String id,
      required String skillLevel,
      required String preferredLocale,
      required String themePreference,
      required int createdAtUtcMs,
      required int updatedAtUtcMs,
      Value<int> rowid,
    });
typedef $$UserProfilesTableUpdateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<String> id,
      Value<String> skillLevel,
      Value<String> preferredLocale,
      Value<String> themePreference,
      Value<int> createdAtUtcMs,
      Value<int> updatedAtUtcMs,
      Value<int> rowid,
    });

class $$UserProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get skillLevel => $composableBuilder(
    column: $table.skillLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preferredLocale => $composableBuilder(
    column: $table.preferredLocale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themePreference => $composableBuilder(
    column: $table.themePreference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtUtcMs => $composableBuilder(
    column: $table.createdAtUtcMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtUtcMs => $composableBuilder(
    column: $table.updatedAtUtcMs,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get skillLevel => $composableBuilder(
    column: $table.skillLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferredLocale => $composableBuilder(
    column: $table.preferredLocale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themePreference => $composableBuilder(
    column: $table.themePreference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtUtcMs => $composableBuilder(
    column: $table.createdAtUtcMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtUtcMs => $composableBuilder(
    column: $table.updatedAtUtcMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get skillLevel => $composableBuilder(
    column: $table.skillLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get preferredLocale => $composableBuilder(
    column: $table.preferredLocale,
    builder: (column) => column,
  );

  GeneratedColumn<String> get themePreference => $composableBuilder(
    column: $table.themePreference,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAtUtcMs => $composableBuilder(
    column: $table.createdAtUtcMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAtUtcMs => $composableBuilder(
    column: $table.updatedAtUtcMs,
    builder: (column) => column,
  );
}

class $$UserProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProfilesTable,
          UserProfile,
          $$UserProfilesTableFilterComposer,
          $$UserProfilesTableOrderingComposer,
          $$UserProfilesTableAnnotationComposer,
          $$UserProfilesTableCreateCompanionBuilder,
          $$UserProfilesTableUpdateCompanionBuilder,
          (
            UserProfile,
            BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>,
          ),
          UserProfile,
          PrefetchHooks Function()
        > {
  $$UserProfilesTableTableManager(_$AppDatabase db, $UserProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> skillLevel = const Value.absent(),
                Value<String> preferredLocale = const Value.absent(),
                Value<String> themePreference = const Value.absent(),
                Value<int> createdAtUtcMs = const Value.absent(),
                Value<int> updatedAtUtcMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserProfilesCompanion(
                id: id,
                skillLevel: skillLevel,
                preferredLocale: preferredLocale,
                themePreference: themePreference,
                createdAtUtcMs: createdAtUtcMs,
                updatedAtUtcMs: updatedAtUtcMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String skillLevel,
                required String preferredLocale,
                required String themePreference,
                required int createdAtUtcMs,
                required int updatedAtUtcMs,
                Value<int> rowid = const Value.absent(),
              }) => UserProfilesCompanion.insert(
                id: id,
                skillLevel: skillLevel,
                preferredLocale: preferredLocale,
                themePreference: themePreference,
                createdAtUtcMs: createdAtUtcMs,
                updatedAtUtcMs: updatedAtUtcMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProfilesTable,
      UserProfile,
      $$UserProfilesTableFilterComposer,
      $$UserProfilesTableOrderingComposer,
      $$UserProfilesTableAnnotationComposer,
      $$UserProfilesTableCreateCompanionBuilder,
      $$UserProfilesTableUpdateCompanionBuilder,
      (
        UserProfile,
        BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>,
      ),
      UserProfile,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ContentItemsTableTableManager get contentItems =>
      $$ContentItemsTableTableManager(_db, _db.contentItems);
  $$ContentTranslationsTableTableManager get contentTranslations =>
      $$ContentTranslationsTableTableManager(_db, _db.contentTranslations);
  $$ContentSourcesTableTableManager get contentSources =>
      $$ContentSourcesTableTableManager(_db, _db.contentSources);
  $$ContentItemSourcesTableTableManager get contentItemSources =>
      $$ContentItemSourcesTableTableManager(_db, _db.contentItemSources);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$TagTranslationsTableTableManager get tagTranslations =>
      $$TagTranslationsTableTableManager(_db, _db.tagTranslations);
  $$ContentItemTagsTableTableManager get contentItemTags =>
      $$ContentItemTagsTableTableManager(_db, _db.contentItemTags);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db, _db.userProfiles);
}
