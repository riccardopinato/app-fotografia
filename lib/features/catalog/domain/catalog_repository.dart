import 'catalog_models.dart';

abstract interface class CatalogRepository {
  Stream<List<LocalizedContent>> watchPublished({
    required LocaleCode locale,
    CatalogFilter filter = const CatalogFilter(),
  });
  Future<List<LocalizedContent>> getPublished({
    required LocaleCode locale,
    CatalogFilter filter = const CatalogFilter(),
  });
  Future<LocalizedContent?> getPublishedById(
    String id, {
    required LocaleCode locale,
  });
  Future<CatalogResultPage> getPage({
    required LocaleCode locale,
    CatalogQuery query = const CatalogQuery(),
  });
}
