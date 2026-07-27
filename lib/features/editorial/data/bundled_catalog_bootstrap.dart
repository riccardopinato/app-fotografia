import 'package:flutter/services.dart';

import '../../../core/database/app_database.dart';
import '../domain/editorial_package.dart';
import 'editorial_importer.dart';

const bundledCatalogPackageAsset = 'editorial/catalog/package.json';
const bundledCatalogAssetRoot = 'editorial/catalog/';

typedef BundledTextLoader = Future<String> Function(String key);
typedef BundledBytesLoader = Future<List<int>> Function(String key);

class BundledCatalogBootstrap {
  BundledCatalogBootstrap(
    this.database, {
    BundledTextLoader? textLoader,
    BundledBytesLoader? bytesLoader,
  }) : _textLoader = textLoader ?? rootBundle.loadString,
       _bytesLoader = bytesLoader ?? _rootBundleBytes;

  final AppDatabase database;
  final BundledTextLoader _textLoader;
  final BundledBytesLoader _bytesLoader;

  Future<EditorialImportResult> install() async {
    final source = await _textLoader(bundledCatalogPackageAsset);
    final package = EditorialPackage.fromJson(
      source,
      assetLoader: (relativePath) =>
          _bytesLoader('$bundledCatalogAssetRoot$relativePath'),
    );
    return EditorialImporter(database).import(package);
  }

  static Future<List<int>> _rootBundleBytes(String key) async {
    final ByteData data = await rootBundle.load(key);
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }
}
