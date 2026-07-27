import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/editorial_package.dart';
import '../domain/editorial_validation.dart';

class EditorialImportException implements Exception {
  const EditorialImportException(this.report);
  final EditorialReport report;
  @override
  String toString() => report.render();
}

class EditorialImportResult {
  const EditorialImportResult({
    required this.inserted,
    required this.updated,
    required this.unchanged,
  });
  final int inserted;
  final int updated;
  final int unchanged;
}

/// Validates first, then applies only catalog tables in one Drift transaction.
/// Personal tables are never deleted or rewritten.
class EditorialImporter {
  EditorialImporter(this.database, {EditorialValidator? validator})
    : validator = validator ?? EditorialValidator();
  final AppDatabase database;
  final EditorialValidator validator;

  Future<EditorialImportResult> import(EditorialPackage package) async {
    final report = await validator.validate(package);
    if (!report.isValid) throw EditorialImportException(report);
    final contents = package
        .list('contents')
        .map(objectAt)
        .whereType<Map<String, Object?>>()
        .toList();
    final versionIssues = <EditorialIssue>[];
    var inserted = 0, updated = 0, unchanged = 0;
    for (var i = 0; i < contents.length; i++) {
      final row =
          await (database.select(database.contentItems)
                ..where((t) => t.id.equals(contents[i]['id']! as String)))
              .getSingleOrNull();
      if (row == null) {
        inserted++;
        continue;
      }
      final incoming = contents[i]['version']! as int;
      if (incoming < row.version) {
        versionIssues.add(
          EditorialIssue(
            EditorialSeverity.error,
            'content.downgrade',
            '\$.contents[$i].version',
            'Incoming version $incoming is older than installed version ${row.version}.',
            'Increase the version or remove this content from the package.',
          ),
        );
      } else if (incoming == row.version) {
        unchanged++;
      } else {
        updated++;
      }
    }
    if (versionIssues.isNotEmpty) {
      throw EditorialImportException(
        EditorialReport(
          packageId: package.id,
          counts: report.counts,
          issues: [...report.issues, ...versionIssues],
        ),
      );
    }
    final now = DateTime.parse(
      package.string('generatedAt'),
    ).toUtc().millisecondsSinceEpoch;
    await database.transaction(() async {
      for (final source
          in package
              .list('sources')
              .map(objectAt)
              .whereType<Map<String, Object?>>()) {
        await database
            .into(database.contentSources)
            .insertOnConflictUpdate(
              ContentSourcesCompanion.insert(
                id: source['id']! as String,
                title: source['title']! as String,
                author: Value(source['author'] as String?),
                publisher: Value(source['publisher'] as String?),
                publicationYear: Value(source['publicationYear'] as int?),
                sourceUri: Value(source['url'] as String?),
                originalLocale: source['originalLocale']! as String,
                licenseType: source['licenseType']! as String,
                licenseReference: Value(source['licenseUrl'] as String?),
                attributionText: Value(source['attributionText'] as String?),
                rightsStatus: source['rightsStatus']! as String,
                createdAtUtcMs: now,
                updatedAtUtcMs: now,
              ),
            );
      }
      for (final tag
          in package
              .list('tags')
              .map(objectAt)
              .whereType<Map<String, Object?>>()) {
        await database
            .into(database.tags)
            .insertOnConflictUpdate(
              TagsCompanion.insert(
                id: tag['id']! as String,
                code: tag['code']! as String,
              ),
            );
        final labels = objectAt(tag['labels']) ?? const <String, Object?>{};
        for (final entry in labels.entries) {
          await database
              .into(database.tagTranslations)
              .insertOnConflictUpdate(
                TagTranslationsCompanion.insert(
                  tagId: tag['id']! as String,
                  locale: entry.key,
                  label: entry.value! as String,
                ),
              );
        }
      }
      for (final content in contents) {
        final id = content['id']! as String;
        final existing = await (database.select(
          database.contentItems,
        )..where((t) => t.id.equals(id))).getSingleOrNull();
        final version = content['version']! as int;
        if (existing != null && existing.version == version) continue;
        await database
            .into(database.contentItems)
            .insertOnConflictUpdate(
              ContentItemsCompanion.insert(
                id: id,
                type: content['type']! as String,
                primaryCategory: content['category']! as String,
                difficulty: content['difficulty']! as String,
                premium: content['premium'] as bool? ?? false,
                canonicalLocale: content['canonicalLocale']! as String,
                editorialStatus: content['editorialStatus']! as String,
                version: version,
                createdAtUtcMs: existing?.createdAtUtcMs ?? now,
                updatedAtUtcMs: now,
                publishedAtUtcMs: Value(
                  content['editorialStatus'] == 'published' ? now : null,
                ),
              ),
            );
        await (database.delete(
          database.contentItemSources,
        )..where((t) => t.contentId.equals(id))).go();
        for (final sourceId
            in (content['sourceIds']! as List).whereType<String>()) {
          await database
              .into(database.contentItemSources)
              .insert(
                ContentItemSourcesCompanion.insert(
                  contentId: id,
                  sourceId: sourceId,
                ),
              );
        }
        await (database.delete(
          database.contentItemTags,
        )..where((t) => t.contentId.equals(id))).go();
        for (final tagId in (content['tags']! as List).whereType<String>()) {
          await database
              .into(database.contentItemTags)
              .insert(
                ContentItemTagsCompanion.insert(contentId: id, tagId: tagId),
              );
        }
        for (final translation
            in (content['translations']! as List)
                .map(objectAt)
                .whereType<Map<String, Object?>>()) {
          final locale = translation['locale']! as String;
          final old =
              await (database.select(database.contentTranslations)..where(
                    (t) => t.contentId.equals(id) & t.locale.equals(locale),
                  ))
                  .getSingleOrNull();
          await database
              .into(database.contentTranslations)
              .insertOnConflictUpdate(
                ContentTranslationsCompanion.insert(
                  id: old?.id ?? '$id-$locale',
                  contentId: id,
                  locale: locale,
                  title: translation['title']! as String,
                  summary: translation['summary']! as String,
                  body: translation['body']! as String,
                  translationStatus: translation['status']! as String,
                  translationMethod: translation['method']! as String,
                  sourceVersion: translation['sourceVersion']! as int,
                  reviewedAtUtcMs: Value(
                    translation['reviewedAt'] == null
                        ? null
                        : DateTime.parse(
                            translation['reviewedAt']! as String,
                          ).toUtc().millisecondsSinceEpoch,
                  ),
                  createdAtUtcMs: old?.createdAtUtcMs ?? now,
                  updatedAtUtcMs: now,
                ),
              );
        }
      }
    });
    return EditorialImportResult(
      inserted: inserted,
      updated: updated,
      unchanged: unchanged,
    );
  }
}
