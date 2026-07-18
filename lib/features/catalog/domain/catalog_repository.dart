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
  Future<CatalogPage> getPage({
    required LocaleCode locale,
    String query = '',
    CatalogFilter filter = const CatalogFilter(),
    int limit = 20,
    int offset = 0,
  });
  Future<CatalogDetail?> getPublishedDetailById(
    String id, {
    required LocaleCode locale,
  });
}
