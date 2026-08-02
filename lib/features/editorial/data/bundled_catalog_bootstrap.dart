import 'package:drift/drift.dart';
import 'package:flutter/services.dart';

import '../../../core/database/app_database.dart';
import '../domain/editorial_package.dart';
import 'editorial_importer.dart';

const bundledCatalogPackageAsset = 'editorial/catalog/package.json';
const bundledCatalogAssetRoot = 'editorial/catalog/';
const bundledCatalogPackageId = 'framelab-bundled-catalog';
const bundledCatalogPackageVersion = 1;

typedef BundledTextLoader = Future<String> Function(String key);
typedef BundledBytesLoader = Future<List<int>> Function(String key);

class BundledCatalogBootstrap {
  BundledCatalogBootstrap(
    this.database, {
    BundledTextLoader? textLoader,
    BundledBytesLoader? bytesLoader,
    bool? useInstallCache,
  }) : _textLoader = textLoader ?? rootBundle.loadString,
       _bytesLoader = bytesLoader ?? _rootBundleBytes,
       _useInstallCache =
           useInstallCache ?? (textLoader == null && bytesLoader == null);

  final AppDatabase database;
  final BundledTextLoader _textLoader;
  final BundledBytesLoader _bytesLoader;
  final bool _useInstallCache;

  Future<EditorialImportResult> install() async {
    if (_useInstallCache) {
      final cached = await database
          .customSelect(
            '''
            SELECT package_version, content_count
            FROM bundled_catalog_installations
            WHERE package_id = ?
              AND package_version = ?
              AND (SELECT COUNT(*) FROM content_items) >= content_count
            ''',
            variables: [
              Variable.withString(bundledCatalogPackageId),
              Variable.withInt(bundledCatalogPackageVersion),
            ],
          )
          .getSingleOrNull();
      if (cached != null) {
        return EditorialImportResult(
          inserted: 0,
          updated: 0,
          unchanged: cached.read<int>('content_count'),
        );
      }
    }

    final source = await _textLoader(bundledCatalogPackageAsset);
    final package = EditorialPackage.fromJson(
      source,
      assetLoader: (relativePath) =>
          _bytesLoader('$bundledCatalogAssetRoot$relativePath'),
    );
    if (package.id != bundledCatalogPackageId ||
        package.version != bundledCatalogPackageVersion) {
      throw StateError(
        'Bundled catalog metadata does not match the application constants.',
      );
    }
    final result = await EditorialImporter(database).import(package);
    if (_useInstallCache) {
      await database.customStatement(
        '''
        INSERT INTO bundled_catalog_installations(
          package_id, package_version, content_count, installed_at_utc_ms
        ) VALUES (?, ?, ?, ?)
        ON CONFLICT(package_id) DO UPDATE SET
          package_version = excluded.package_version,
          content_count = excluded.content_count,
          installed_at_utc_ms = excluded.installed_at_utc_ms
        ''',
        [
          package.id,
          package.version,
          package.list('contents').length,
          DateTime.now().toUtc().millisecondsSinceEpoch,
        ],
      );
    }
    return result;
  }

  static Future<List<int>> _rootBundleBytes(String key) async {
    final ByteData data = await rootBundle.load(key);
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }
}
