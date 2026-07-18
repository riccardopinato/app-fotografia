import 'package:uuid/uuid.dart';

enum ContentType {
  tip,
  technique,
  curiosity,
  idea,
  commonMistake,
  guide,
  checklist,
  challenge,
  glossary,
  photographicHistory,
}

enum Difficulty { beginner, intermediate, advanced }

enum EditorialStatus {
  imported,
  processed,
  needsReview,
  approved,
  published,
  archived,
}

enum TranslationStatus {
  missing,
  generated,
  needsReview,
  approved,
  published,
  outdated,
}

enum TranslationMethod { original, machine, human, machineReviewed }

enum RightsStatus { unknown, publishable, restricted }

class LocaleCode {
  const LocaleCode(this.value) : assert(value != '');
  final String value;
  String get language => value.split('-').first.toLowerCase();
  static List<LocaleCode> fallbackChain(LocaleCode requested) {
    final result = <LocaleCode>[requested];
    if (requested.value.contains('-')) {
      result.add(LocaleCode(requested.language));
    }
    if (!result.any((locale) => locale.value == 'en')) {
      result.add(const LocaleCode('en'));
    }
    return result;
  }

  @override
  bool operator ==(Object other) => other is LocaleCode && other.value == value;
  @override
  int get hashCode => value.hashCode;
}

class ContentItem {
  const ContentItem({
    required this.id,
    required this.type,
    required this.primaryCategory,
    required this.difficulty,
    required this.premium,
    required this.canonicalLocale,
    required this.editorialStatus,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
    this.publishedAt,
  });
  final String id;
  final ContentType type;
  final String primaryCategory;
  final Difficulty difficulty;
  final bool premium;
  final LocaleCode canonicalLocale;
  final EditorialStatus editorialStatus;
  final int version;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? publishedAt;
}

class ContentTranslation {
  const ContentTranslation({
    required this.id,
    required this.contentId,
    required this.locale,
    required this.title,
    required this.summary,
    required this.body,
    required this.status,
    required this.method,
    required this.sourceVersion,
    required this.createdAt,
    required this.updatedAt,
    this.reviewedAt,
  });
  final String id;
  final String contentId;
  final LocaleCode locale;
  final String title;
  final String summary;
  final String body;
  final TranslationStatus status;
  final TranslationMethod method;
  final int sourceVersion;
  final DateTime? reviewedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  bool get isPublishable =>
      status == TranslationStatus.published &&
      title.trim().isNotEmpty &&
      body.trim().isNotEmpty;
}

class ContentSource {
  const ContentSource({
    required this.id,
    required this.title,
    required this.originalLocale,
    required this.licenseType,
    required this.rightsStatus,
    required this.createdAt,
    required this.updatedAt,
    this.author,
    this.publisher,
    this.publicationYear,
    this.sourceUri,
    this.licenseReference,
    this.attributionText,
  });
  final String id;
  final String title;
  final String? author;
  final String? publisher;
  final int? publicationYear;
  final String? sourceUri;
  final LocaleCode originalLocale;
  final String licenseType;
  final String? licenseReference;
  final String? attributionText;
  final RightsStatus rightsStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  bool get isPublishable =>
      rightsStatus == RightsStatus.publishable && licenseType.trim().isNotEmpty;
}

class Tag {
  const Tag({required this.id, required this.code});
  final String id;
  final String code;
}

class LocalizedContent {
  const LocalizedContent({
    required this.item,
    required this.translation,
    required this.tags,
  });
  final ContentItem item;
  final ContentTranslation translation;
  final List<Tag> tags;
}

class CatalogFilter {
  const CatalogFilter({
    this.type,
    this.category,
    this.difficulty,
    this.premium,
    this.tagCode,
  });
  final ContentType? type;
  final String? category;
  final Difficulty? difficulty;
  final bool? premium;
  final String? tagCode;
}

enum CatalogSort { editorial, relevance }

class CatalogQuery {
  const CatalogQuery({
    this.search = '',
    this.filter = const CatalogFilter(),
    this.sort = CatalogSort.editorial,
    this.offset = 0,
    this.limit = 20,
  });
  final String search;
  final CatalogFilter filter;
  final CatalogSort sort;
  final int offset;
  final int limit;
}

class CatalogResultPage {
  const CatalogResultPage({required this.items, required this.hasMore});
  final List<LocalizedContent> items;
  final bool hasMore;
}

String newUuid() => const Uuid().v4();
