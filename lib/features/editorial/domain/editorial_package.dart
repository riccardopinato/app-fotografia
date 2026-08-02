import 'dart:convert';
import 'dart:io';

/// Parsed, immutable boundary between editorial JSON and persistence.
typedef EditorialAssetLoader = Future<List<int>> Function(String relativePath);

class EditorialPackage {
  EditorialPackage._(this.root, this.directory, this._assetLoader);

  final Map<String, Object?> root;
  final Directory? directory;
  final EditorialAssetLoader? _assetLoader;

  static Future<EditorialPackage> load(File file) async {
    final decoded = jsonDecode(await file.readAsString());
    if (decoded is! Map<String, Object?>) {
      throw const FormatException('The package root must be a JSON object.');
    }
    return EditorialPackage._(decoded, file.parent, null);
  }

  static EditorialPackage fromJson(
    String source, {
    required EditorialAssetLoader assetLoader,
  }) {
    final decoded = jsonDecode(source);
    if (decoded is! Map<String, Object?>) {
      throw const FormatException('The package root must be a JSON object.');
    }
    return EditorialPackage._(decoded, null, assetLoader);
  }

  Future<List<int>> readAsset(String relativePath) async {
    if (_assetLoader != null) return _assetLoader(relativePath);
    return File('${directory!.path}/$relativePath').readAsBytes();
  }

  Future<bool> assetExists(String relativePath) async {
    if (_assetLoader != null) {
      try {
        await _assetLoader(relativePath);
        return true;
      } on Object {
        return false;
      }
    }
    return File('${directory!.path}/$relativePath').exists();
  }

  String get id => string('packageId');
  int get version => integer('packageVersion');
  String get baseLocale => string('baseLocale');
  List<Object?> list(String key) =>
      root[key] is List ? root[key]! as List : const [];
  String string(String key) => root[key] is String ? root[key]! as String : '';
  int integer(String key) => root[key] is int ? root[key]! as int : 0;
}

Map<String, Object?>? objectAt(Object? value) =>
    value is Map<String, Object?> ? value : null;
