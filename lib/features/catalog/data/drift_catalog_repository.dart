import '../../../core/database/app_database.dart' as db;
import 'package:drift/drift.dart'
    show Join, JoinedSelectStatement, innerJoin, leftOuterJoin;
import '../domain/catalog_models.dart';
import '../domain/catalog_repository.dart';
import 'catalog_mapper.dart';

class DriftCatalogRepository implements CatalogRepository {
  DriftCatalogRepository(this._database);
  final db.AppDatabase _database;

  @override
  Stream<List<LocalizedContent>> watchPublished({
    required LocaleCode locale,
    CatalogFilter filter = const CatalogFilter(),
  }) => _publishedQuery(
    locale,
    filter,
  ).watch().asyncMap((_) => getPublished(locale: locale, filter: filter));

  @override
  Future<List<LocalizedContent>> getPublished({
    required LocaleCode locale,
    CatalogFilter filter = const CatalogFilter(),
  }) async {
    final rows = await _publishedQuery(locale, filter).get();
    final translations = <String, List<db.ContentTranslation>>{};
    final items = <String, ContentItem>{};
    for (final row in rows) {
      final item = contentItemFromRow(row.readTable(_database.contentItems));
      items[item.id] = item;
      translations
          .putIfAbsent(item.id, () => [])
          .add(row.readTable(_database.contentTranslations));
    }
    final tags = await _tagsFor(items.keys);
    final result = <LocalizedContent>[];
    for (final item in items.values) {
      final translation = _resolveRows(translations[item.id]!, locale);
      if (translation != null) {
        result.add(
          LocalizedContent(
            item: item,
            translation: translation,
            tags: tags[item.id] ?? const [],
          ),
        );
      }
    }
    result.sort((a, b) {
      final byTitle = a.translation.title.compareTo(b.translation.title);
      return byTitle != 0 ? byTitle : a.item.id.compareTo(b.item.id);
    });
    return result;
  }

  @override
  Future<LocalizedContent?> getPublishedById(
    String id, {
    required LocaleCode locale,
  }) => getPublished(locale: locale).then(
    (items) => items
        .where((item) => item.item.id == id)
        .cast<LocalizedContent?>()
        .firstOrNull,
  );

  @override
  Future<CatalogResultPage> getPage({
    required LocaleCode locale,
    CatalogQuery query = const CatalogQuery(),
  }) async {
    final all = await getPublished(locale: locale, filter: query.filter);
    final needle = _searchKey(query.search);
    final matching = needle.isEmpty
        ? all
        : all.where((content) {
            final text = [
              content.translation.title,
              content.translation.summary,
              content.translation.body,
              ...content.tags.map((tag) => tag.code),
            ].map(_searchKey).join(' ');
            return text.contains(needle);
          }).toList();
    if (query.sort == CatalogSort.relevance && needle.isNotEmpty) {
      matching.sort((a, b) {
        final scoreA = _score(a, needle);
        final scoreB = _score(b, needle);
        return scoreA != scoreB
            ? scoreB.compareTo(scoreA)
            : a.item.id.compareTo(b.item.id);
      });
    }
    final start = query.offset.clamp(0, matching.length);
    final end = (start + query.limit + 1).clamp(start, matching.length);
    final slice = matching.sublist(start, end);
    return CatalogResultPage(
      items: slice.take(query.limit).toList(),
      hasMore: slice.length > query.limit,
    );
  }

  String _searchKey(String value) => value
      .toLowerCase()
      .replaceAll(RegExp('[àáâäãå]'), 'a')
      .replaceAll(RegExp('[èéêë]'), 'e')
      .replaceAll(RegExp('[ìíîï]'), 'i')
      .replaceAll(RegExp('[òóôöõ]'), 'o')
      .replaceAll(RegExp('[ùúûü]'), 'u')
      .replaceAll('ç', 'c');

  int _score(LocalizedContent content, String needle) {
    if (_searchKey(content.translation.title).contains(needle)) return 3;
    if (_searchKey(content.translation.summary).contains(needle)) return 2;
    return 1;
  }

  JoinedSelectStatement _publishedQuery(
    LocaleCode locale,
    CatalogFilter filter,
  ) {
    final candidates = LocaleCode.fallbackChain(
      locale,
    ).map((value) => value.value).toList();
    final joins = <Join>[
      innerJoin(
        _database.contentTranslations,
        _database.contentTranslations.contentId.equalsExp(
          _database.contentItems.id,
        ),
      ),
      innerJoin(
        _database.contentItemSources,
        _database.contentItemSources.contentId.equalsExp(
          _database.contentItems.id,
        ),
      ),
      innerJoin(
        _database.contentSources,
        _database.contentSources.id.equalsExp(
          _database.contentItemSources.sourceId,
        ),
      ),
      leftOuterJoin(
        _database.contentItemTags,
        _database.contentItemTags.contentId.equalsExp(
          _database.contentItems.id,
        ),
      ),
      leftOuterJoin(
        _database.tags,
        _database.tags.id.equalsExp(_database.contentItemTags.tagId),
      ),
    ];
    final query = _database.select(_database.contentItems).join(joins)
      ..where(
        _database.contentItems.editorialStatus.equals(
          EditorialStatus.published.name,
        ),
      )
      ..where(
        _database.contentTranslations.translationStatus.equals(
          TranslationStatus.published.name,
        ),
      )
      ..where(_database.contentTranslations.locale.isIn(candidates))
      ..where(
        _database.contentSources.rightsStatus.equals(
          RightsStatus.publishable.name,
        ),
      )
      ..where(_database.contentSources.licenseType.isNotValue(''));
    if (filter.type != null) {
      query.where(_database.contentItems.type.equals(filter.type!.name));
    }
    if (filter.category != null) {
      query.where(
        _database.contentItems.primaryCategory.equals(filter.category!),
      );
    }
    if (filter.difficulty != null) {
      query.where(
        _database.contentItems.difficulty.equals(filter.difficulty!.name),
      );
    }
    if (filter.premium != null) {
      query.where(_database.contentItems.premium.equals(filter.premium!));
    }
    if (filter.tagCode != null) {
      query.where(_database.tags.code.equals(filter.tagCode!));
    }
    return query;
  }

  ContentTranslation? _resolveRows(
    List<db.ContentTranslation> rows,
    LocaleCode locale,
  ) {
    for (final candidate in LocaleCode.fallbackChain(locale)) {
      for (final row in rows) {
        if (row.locale == candidate.value) {
          final translation = contentTranslationFromRow(row);
          if (translation.isPublishable) return translation;
        }
      }
    }
    return null;
  }

  Future<Map<String, List<Tag>>> _tagsFor(Iterable<String> contentIds) async {
    if (contentIds.isEmpty) return {};
    final query = _database.select(_database.contentItemTags).join([
      innerJoin(
        _database.tags,
        _database.tags.id.equalsExp(_database.contentItemTags.tagId),
      ),
    ])..where(_database.contentItemTags.contentId.isIn(contentIds));
    final result = <String, List<Tag>>{};
    for (final row in await query.get()) {
      result
          .putIfAbsent(
            row.readTable(_database.contentItemTags).contentId,
            () => [],
          )
          .add(
            Tag(
              id: row.readTable(_database.tags).id,
              code: row.readTable(_database.tags).code,
            ),
          );
    }
    return result;
  }
}
