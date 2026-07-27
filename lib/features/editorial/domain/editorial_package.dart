import 'dart:convert';
import 'dart:io';

/// Parsed, immutable boundary between editorial JSON and persistence.
class EditorialPackage {
  EditorialPackage._(this.root, this.directory);

  final Map<String, Object?> root;
  final Directory directory;

  static Future<EditorialPackage> load(File file) async {
    final decoded = jsonDecode(await file.readAsString());
    if (decoded is! Map<String, Object?>) {
      throw const FormatException('The package root must be a JSON object.');
    }
    return EditorialPackage._(decoded, file.parent);
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
