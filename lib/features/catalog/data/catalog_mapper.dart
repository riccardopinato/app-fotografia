import '../../../core/database/app_database.dart' as db;
import '../domain/catalog_models.dart';

DateTime _utc(int value) =>
    DateTime.fromMillisecondsSinceEpoch(value, isUtc: true);
ContentType contentTypeFromDb(String value) => ContentType.values.byName(value);
Difficulty difficultyFromDb(String value) => Difficulty.values.byName(value);
EditorialStatus editorialStatusFromDb(String value) =>
    EditorialStatus.values.byName(value);
TranslationStatus translationStatusFromDb(String value) =>
    TranslationStatus.values.byName(value);
TranslationMethod translationMethodFromDb(String value) =>
    TranslationMethod.values.byName(value);
RightsStatus rightsStatusFromDb(String value) =>
    RightsStatus.values.byName(value);
ContentItem contentItemFromRow(db.ContentItem row) => ContentItem(
  id: row.id,
  type: contentTypeFromDb(row.type),
  primaryCategory: row.primaryCategory,
  difficulty: difficultyFromDb(row.difficulty),
  premium: row.premium,
  canonicalLocale: LocaleCode(row.canonicalLocale),
  editorialStatus: editorialStatusFromDb(row.editorialStatus),
  version: row.version,
  createdAt: _utc(row.createdAtUtcMs),
  updatedAt: _utc(row.updatedAtUtcMs),
  publishedAt: row.publishedAtUtcMs == null
      ? null
      : _utc(row.publishedAtUtcMs!),
);
ContentTranslation contentTranslationFromRow(db.ContentTranslation row) =>
    ContentTranslation(
      id: row.id,
      contentId: row.contentId,
      locale: LocaleCode(row.locale),
      title: row.title,
      summary: row.summary,
      body: row.body,
      status: translationStatusFromDb(row.translationStatus),
      method: translationMethodFromDb(row.translationMethod),
      sourceVersion: row.sourceVersion,
      reviewedAt: row.reviewedAtUtcMs == null
          ? null
          : _utc(row.reviewedAtUtcMs!),
      createdAt: _utc(row.createdAtUtcMs),
      updatedAt: _utc(row.updatedAtUtcMs),
    );
ContentSource contentSourceFromRow(db.ContentSource row) => ContentSource(
  id: row.id,
  title: row.title,
  author: row.author,
  publisher: row.publisher,
  publicationYear: row.publicationYear,
  sourceUri: row.sourceUri,
  originalLocale: LocaleCode(row.originalLocale),
  licenseType: row.licenseType,
  licenseReference: row.licenseReference,
  attributionText: row.attributionText,
  rightsStatus: rightsStatusFromDb(row.rightsStatus),
  createdAt: _utc(row.createdAtUtcMs),
  updatedAt: _utc(row.updatedAtUtcMs),
);
