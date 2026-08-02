import 'dart:convert';

import 'editorial_package.dart';

enum EditorialSeverity { error, warning, info }

class EditorialIssue implements Comparable<EditorialIssue> {
  const EditorialIssue(
    this.severity,
    this.code,
    this.path,
    this.message,
    this.fix,
  );
  final EditorialSeverity severity;
  final String code;
  final String path;
  final String message;
  final String fix;

  @override
  int compareTo(EditorialIssue other) => '$path|${severity.name}|$code'
      .compareTo('${other.path}|${other.severity.name}|${other.code}');
}

class EditorialReport {
  EditorialReport({
    required this.packageId,
    required this.counts,
    required List<EditorialIssue> issues,
  }) : issues = List.unmodifiable(issues..sort());
  final String packageId;
  final Map<String, int> counts;
  final List<EditorialIssue> issues;
  bool get isValid =>
      issues.every((issue) => issue.severity != EditorialSeverity.error);
  String render() {
    final out =
        StringBuffer(
          'FrameLab editorial validation\nPackage: ${packageId.isEmpty ? '<unknown>' : packageId}\n',
        )..writeln(
          'Counts: contents=${counts['contents']}, translations=${counts['translations']}, sources=${counts['sources']}, assets=${counts['assets']}',
        );
    for (final issue in issues) {
      out.writeln(
        '${issue.severity.name.toUpperCase()} ${issue.code} ${issue.path}: ${issue.message} Fix: ${issue.fix}',
      );
    }
    out.writeln(
      'Result: ${isValid ? 'VALID' : 'INVALID'} (${issues.where((i) => i.severity == EditorialSeverity.error).length} errors, ${issues.where((i) => i.severity == EditorialSeverity.warning).length} warnings)',
    );
    return out.toString();
  }
}

class EditorialValidator {
  static const supportedLocales = {'en', 'it', 'es', 'fr', 'de', 'pt', 'pt-BR'};
  static const contentTypes = {
    'tip',
    'technique',
    'curiosity',
    'idea',
    'commonMistake',
    'guide',
    'checklist',
    'challenge',
    'glossary',
    'photographicHistory',
  };
  static const editorialStates = {
    'imported',
    'processed',
    'needsReview',
    'approved',
    'published',
    'archived',
  };
  static const translationStates = {
    'missing',
    'generated',
    'needsReview',
    'approved',
    'published',
    'outdated',
  };
  static const licenses = {
    'CC0-1.0',
    'CC-BY-4.0',
    'CC-BY-SA-4.0',
    'FrameLab-Proprietary',
    'Licensed-Agreement',
    'Public-Domain',
  };

  Future<EditorialReport> validate(EditorialPackage package) async {
    final issues = <EditorialIssue>[];
    void error(String code, String path, String message, String fix) => issues
        .add(EditorialIssue(EditorialSeverity.error, code, path, message, fix));
    void warning(String code, String path, String message, String fix) =>
        issues.add(
          EditorialIssue(EditorialSeverity.warning, code, path, message, fix),
        );
    if (package.string('formatVersion') != '1.0') {
      error(
        'format.unsupported',
        r'$.formatVersion',
        'Unsupported contract version.',
        'Use formatVersion "1.0".',
      );
    }
    for (final key in ['packageId', 'generatedAt', 'baseLocale']) {
      if (package.string(key).trim().isEmpty) {
        error(
          'field.required',
          '\$.$key',
          'Required string is empty.',
          'Provide a non-empty $key.',
        );
      }
    }
    if (package.version < 1) {
      error(
        'field.required',
        r'$.packageVersion',
        'Package version must be positive.',
        'Use an integer greater than zero.',
      );
    }
    final declaredLocales = package
        .list('locales')
        .whereType<String>()
        .toList();
    for (var i = 0; i < declaredLocales.length; i++) {
      if (!supportedLocales.contains(declaredLocales[i])) {
        error(
          'locale.unsupported',
          '\$.locales[$i]',
          'Locale ${declaredLocales[i]} is not supported.',
          'Use a launch locale.',
        );
      }
    }
    final sources = package.list('sources');
    final sourceIds = _uniqueIds(sources, r'$.sources', error);
    for (var i = 0; i < sources.length; i++) {
      final source = objectAt(sources[i]);
      if (source == null) {
        error(
          'field.object',
          '\$.sources[$i]',
          'Source must be an object.',
          'Replace it with a source object.',
        );
        continue;
      }
      _required(
        source,
        [
          'id',
          'title',
          'originalLocale',
          'licenseType',
          'rightsStatus',
          'sourceType',
          'verificationStatus',
        ],
        '\$.sources[$i]',
        error,
      );
      final license = source['licenseType'];
      if (license is String && !licenses.contains(license)) {
        error(
          'rights.license',
          '\$.sources[$i].licenseType',
          'License is missing or unrecognized.',
          'Use a documented supported license.',
        );
      }
      if (source['rightsStatus'] == 'publishable' &&
          (source['attributionRequired'] == true) &&
          _blank(source['attributionText'])) {
        error(
          'rights.attribution',
          '\$.sources[$i].attributionText',
          'Required attribution is missing.',
          'Add the exact required attribution.',
        );
      }
    }
    final tags = package.list('tags');
    final tagIds = _uniqueIds(tags, r'$.tags', error);
    final assets = package.list('assets');
    final assetIds = _uniqueIds(assets, r'$.assets', error);
    final checksums = <String>{};
    for (var i = 0; i < assets.length; i++) {
      final asset = objectAt(assets[i]);
      if (asset == null) continue;
      _required(
        asset,
        [
          'id',
          'path',
          'mimeType',
          'width',
          'height',
          'byteSize',
          'checksum',
          'credit',
          'sourceId',
          'licenseType',
          'role',
          'editorialStatus',
        ],
        '\$.assets[$i]',
        error,
      );
      final relative = asset['path'] as String? ?? '';
      final safe =
          relative.isNotEmpty &&
          !relative.startsWith('/') &&
          !relative.startsWith('\\') &&
          !relative.split(RegExp(r'[/\\]')).contains('..');
      if (!safe) {
        error(
          'asset.path',
          '\$.assets[$i].path',
          'Asset path is unsafe.',
          'Use a relative path inside the package without "..".',
        );
        continue;
      }
      if (!await package.assetExists(relative)) {
        error(
          'asset.missing',
          '\$.assets[$i].path',
          'Referenced asset does not exist.',
          'Add the file inside the package.',
        );
        continue;
      }
      final bytes = await package.readAsset(relative);
      final mimeType = asset['mimeType'];
      if (mimeType == 'image/svg+xml') {
        if (!relative.toLowerCase().endsWith('.svg')) {
          error(
            'asset.mime',
            '\$.assets[$i].mimeType',
            'SVG MIME type does not match the file extension.',
            'Use a .svg file or correct the declared MIME type.',
          );
        }
        final markup = utf8.decode(bytes, allowMalformed: true).toLowerCase();
        final resources = markup.replaceAll(
          'xmlns="http://www.w3.org/2000/svg"',
          '',
        );
        if (!markup.trimLeft().startsWith('<svg') ||
            markup.contains('<script') ||
            resources.contains('http://') ||
            resources.contains('https://') ||
            markup.contains('xlink:href')) {
          error(
            'asset.svgUnsafe',
            '\$.assets[$i].path',
            'SVG is not static and self-contained.',
            'Remove scripts, external links and remote resources.',
          );
        }
      }
      if ((asset['width'] is! int || (asset['width'] as int) <= 0) ||
          (asset['height'] is! int || (asset['height'] as int) <= 0)) {
        error(
          'asset.dimensions',
          '\$.assets[$i]',
          'Asset dimensions must be positive integers.',
          'Declare the intrinsic pixel dimensions.',
        );
      }
      if (asset['byteSize'] != bytes.length) {
        error(
          'asset.size',
          '\$.assets[$i].byteSize',
          'Declared byte size does not match.',
          'Set byteSize to ${bytes.length}.',
        );
      }
      final checksum = 'fnv1a64:${_fnv1a64(bytes)}';
      if (asset['checksum'] != checksum) {
        error(
          'asset.checksum',
          '\$.assets[$i].checksum',
          'Checksum does not match.',
          'Set checksum to $checksum.',
        );
      }
      if (!checksums.add(checksum)) {
        warning(
          'asset.duplicateChecksum',
          '\$.assets[$i].checksum',
          'Another asset has identical bytes.',
          'Reuse one stable asset ID when appropriate.',
        );
      }
      if (!sourceIds.contains(asset['sourceId'])) {
        error(
          'reference.source',
          '\$.assets[$i].sourceId',
          'Asset source cannot be resolved.',
          'Reference an existing source ID.',
        );
      }
      if (!licenses.contains(asset['licenseType'])) {
        error(
          'rights.license',
          '\$.assets[$i].licenseType',
          'Asset license is unrecognized.',
          'Use a supported verified license.',
        );
      }
      final alt = asset['altTexts'];
      if (alt is! Map || _blank(alt[package.baseLocale])) {
        error(
          'translation.required',
          '\$.assets[$i].altTexts.${package.baseLocale}',
          'Base-locale alternative text is missing.',
          'Add non-empty alternative text.',
        );
      }
    }
    final contents = package.list('contents');
    final contentIds = _uniqueIds(contents, r'$.contents', error);
    final seenTranslations = <String>{};
    var translationCount = 0;
    final usedAssets = <String>{};
    for (var i = 0; i < contents.length; i++) {
      final content = objectAt(contents[i]);
      if (content == null) continue;
      _required(
        content,
        [
          'id',
          'type',
          'editorialStatus',
          'canonicalLocale',
          'version',
          'category',
          'difficulty',
          'tags',
          'sourceIds',
          'translations',
        ],
        '\$.contents[$i]',
        error,
      );
      if (!contentTypes.contains(content['type'])) {
        error(
          'content.type',
          '\$.contents[$i].type',
          'Unsupported editorial type.',
          'Use a type supported by the catalog domain.',
        );
      }
      if (!editorialStates.contains(content['editorialStatus'])) {
        error(
          'content.status',
          '\$.contents[$i].editorialStatus',
          'Invalid editorial status.',
          'Use a supported editorial status.',
        );
      }
      if (content['version'] is! int || (content['version'] as int) < 1) {
        error(
          'content.version',
          '\$.contents[$i].version',
          'Content version must be positive.',
          'Use an integer greater than zero.',
        );
      }
      for (final sourceId
          in (content['sourceIds'] is List
              ? content['sourceIds'] as List
              : const [])) {
        if (!sourceIds.contains(sourceId)) {
          error(
            'reference.source',
            '\$.contents[$i].sourceIds',
            'Source $sourceId cannot be resolved.',
            'Declare the source in sources.',
          );
        }
      }
      for (final tag
          in (content['tags'] is List ? content['tags'] as List : const [])) {
        if (!tagIds.contains(tag)) {
          error(
            'reference.tag',
            '\$.contents[$i].tags',
            'Tag $tag cannot be resolved.',
            'Declare the tag in tags.',
          );
        }
      }
      final cover = content['coverAssetId'];
      if (cover is String) {
        usedAssets.add(cover);
        if (!assetIds.contains(cover)) {
          error(
            'reference.asset',
            '\$.contents[$i].coverAssetId',
            'Cover asset cannot be resolved.',
            'Declare the asset or remove the reference.',
          );
        }
      }
      final translations = content['translations'] is List
          ? content['translations'] as List
          : const [];
      var usable = false;
      for (var t = 0; t < translations.length; t++) {
        translationCount++;
        final tr = objectAt(translations[t]);
        if (tr == null) continue;
        _required(
          tr,
          [
            'locale',
            'title',
            'summary',
            'body',
            'status',
            'method',
            'sourceVersion',
            'searchTerms',
          ],
          '\$.contents[$i].translations[$t]',
          error,
        );
        final locale = tr['locale'];
        if (locale is String && !supportedLocales.contains(locale)) {
          error(
            'locale.unsupported',
            '\$.contents[$i].translations[$t].locale',
            'Translation locale is unsupported.',
            'Use a launch locale.',
          );
        }
        final key = '${content['id']}|$locale';
        if (!seenTranslations.add(key)) {
          error(
            'translation.duplicate',
            '\$.contents[$i].translations[$t]',
            'Duplicate content/locale translation.',
            'Keep one translation per content and locale.',
          );
        }
        if (!translationStates.contains(tr['status'])) {
          error(
            'translation.status',
            '\$.contents[$i].translations[$t].status',
            'Invalid translation status.',
            'Use a supported translation status.',
          );
        }
        final sourceVersion = tr['sourceVersion'];
        if (sourceVersion is! int || sourceVersion < 1) {
          error(
            'translation.version',
            '\$.contents[$i].translations[$t].sourceVersion',
            'Translation source version must be a positive integer.',
            'Use the version of the containing content.',
          );
        } else if (content['version'] is int &&
            sourceVersion != content['version']) {
          error(
            'translation.outdated',
            '\$.contents[$i].translations[$t].sourceVersion',
            'Translation targets content v$sourceVersion, not v${content['version']}.',
            'Review the translation and set sourceVersion to ${content['version']}.',
          );
        }
        final partial = [
          'title',
          'summary',
          'body',
        ].where((field) => _blank(tr[field])).toList();
        if (partial.isNotEmpty) {
          error(
            'translation.partial',
            '\$.contents[$i].translations[$t]',
            'Localized fields are empty: ${partial.join(', ')}.',
            'Complete all localized fields or remove the translation.',
          );
        }
        if (locale == content['canonicalLocale'] && partial.isEmpty) {
          usable = true;
        }
      }
      if (!usable) {
        error(
          'translation.required',
          '\$.contents[$i].translations',
          'No complete canonical translation exists.',
          'Add a complete translation for ${content['canonicalLocale']}.',
        );
      }
    }
    // Optional top-level translations are rejected when orphaned, allowing future contract evolution without ambiguity.
    final externalTranslations = package.list('translations');
    for (var i = 0; i < externalTranslations.length; i++) {
      final tr = objectAt(externalTranslations[i]);
      if (tr != null && !contentIds.contains(tr['contentId'])) {
        error(
          'translation.orphan',
          '\$.translations[$i].contentId',
          'Translation points to unknown content.',
          'Reference an existing content ID or remove it.',
        );
      }
    }
    for (var i = 0; i < assets.length; i++) {
      final id = objectAt(assets[i])?['id'];
      if (id is String && !usedAssets.contains(id)) {
        warning(
          'asset.orphan',
          '\$.assets[$i]',
          'Asset is not referenced by content.',
          'Reference it or remove it from the package.',
        );
      }
    }
    return EditorialReport(
      packageId: package.id,
      counts: {
        'contents': contents.length,
        'translations': translationCount + externalTranslations.length,
        'sources': sources.length,
        'assets': assets.length,
      },
      issues: issues,
    );
  }

  static Set<Object?> _uniqueIds(
    List<Object?> values,
    String path,
    void Function(String, String, String, String) error,
  ) {
    final ids = <Object?>{};
    for (var i = 0; i < values.length; i++) {
      final id = objectAt(values[i])?['id'];
      if (id is! String || id.trim().isEmpty) {
        error(
          'id.empty',
          '$path[$i].id',
          'Stable ID is empty.',
          'Provide a non-empty stable editorial ID.',
        );
      } else if (!ids.add(id)) {
        error(
          'id.duplicate',
          '$path[$i].id',
          'Stable ID $id is duplicated.',
          'Keep each ID unique.',
        );
      }
    }
    return ids;
  }

  static void _required(
    Map<String, Object?> value,
    List<String> keys,
    String path,
    void Function(String, String, String, String) error,
  ) {
    for (final key in keys) {
      if (!value.containsKey(key) || value[key] == null || _blank(value[key])) {
        error(
          'field.required',
          '$path.$key',
          'Required field is missing or empty.',
          'Provide $key.',
        );
      }
    }
  }

  static bool _blank(Object? value) => value is String && value.trim().isEmpty;
  static String _fnv1a64(List<int> bytes) {
    var hash = BigInt.parse('cbf29ce484222325', radix: 16);
    final prime = BigInt.parse('100000001b3', radix: 16);
    final mask = BigInt.parse('ffffffffffffffff', radix: 16);
    for (final byte in bytes) {
      hash ^= BigInt.from(byte);
      hash = (hash * prime) & mask;
    }
    return hash.toRadixString(16).padLeft(16, '0');
  }
}
