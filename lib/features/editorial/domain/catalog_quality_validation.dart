import 'editorial_package.dart';
import 'editorial_validation.dart';

/// Documented release gates for the bundled catalog. Subjective signals remain
/// warnings; structural publication requirements are blocking errors.
class CatalogQualityValidator {
  CatalogQualityValidator({EditorialValidator? contractValidator})
    : _contractValidator = contractValidator ?? EditorialValidator();

  static const minimumPublishedContents = 30;
  static const minimumBodyCharacters = 180;
  static const maximumBodyCharacters = 1400;
  static const minimumTagsPerContent = 2;
  static const maximumTagsPerContent = 4;
  static const requiredLocales = {'en', 'it', 'es', 'fr', 'de', 'pt', 'pt-BR'};
  static final stableIdPattern = RegExp(
    r'^(seed|editorial)-[a-z0-9]+(?:-[a-z0-9]+)+$',
  );
  static final tagCodePattern = RegExp(r'^[a-z][a-z0-9]*(?:-[a-z0-9]+)*$');
  static final placeholderPattern = RegExp(
    r'(?:^|\s)(todo:|tbd|placeholder|lorem ipsum|fixme)(?:\s|$)',
    caseSensitive: false,
  );

  final EditorialValidator _contractValidator;

  Future<EditorialReport> validate(EditorialPackage package) async {
    final contract = await _contractValidator.validate(package);
    final issues = [...contract.issues];
    void error(String code, String path, String message, String fix) => issues
        .add(EditorialIssue(EditorialSeverity.error, code, path, message, fix));
    void warning(String code, String path, String message, String fix) =>
        issues.add(
          EditorialIssue(EditorialSeverity.warning, code, path, message, fix),
        );
    final contents = package.list('contents');
    final published = <Map<String, Object?>>[];
    final tagUse = <String, int>{};
    final typeCount = <String, int>{};
    final difficultyCount = <String, int>{};
    final titles = <String>{};
    final bodies = <String>{};
    for (var i = 0; i < contents.length; i++) {
      final content = objectAt(contents[i]);
      if (content == null || content['editorialStatus'] != 'published') {
        continue;
      }
      published.add(content);
      final id = content['id'] as String? ?? '';
      if (!stableIdPattern.hasMatch(id)) {
        error(
          'quality.id',
          '\$.contents[$i].id',
          'ID does not follow the stable kebab-case convention.',
          'Use seed-* for migrated identities or editorial-* for new identities.',
        );
      }
      final tags = (content['tags'] as List? ?? const [])
          .whereType<String>()
          .toList();
      if (tags.length < minimumTagsPerContent ||
          tags.length > maximumTagsPerContent) {
        error(
          'quality.tagCount',
          '\$.contents[$i].tags',
          'Published content must have $minimumTagsPerContent–$maximumTagsPerContent useful tags.',
          'Add or remove stable vocabulary tags.',
        );
      }
      for (final tag in tags) {
        tagUse.update(tag, (value) => value + 1, ifAbsent: () => 1);
      }
      typeCount.update(
        content['type'] as String? ?? '',
        (value) => value + 1,
        ifAbsent: () => 1,
      );
      difficultyCount.update(
        content['difficulty'] as String? ?? '',
        (value) => value + 1,
        ifAbsent: () => 1,
      );
      final translations = (content['translations'] as List? ?? const [])
          .map(objectAt)
          .whereType<Map<String, Object?>>()
          .toList();
      final byLocale = {
        for (final value in translations) value['locale']: value,
      };
      for (final locale in requiredLocales) {
        final translation = byLocale[locale];
        if (translation == null || translation['status'] != 'published') {
          error(
            'quality.localeCoverage',
            '\$.contents[$i].translations',
            'Published content is missing published locale $locale.',
            'Add and review the complete $locale translation.',
          );
          continue;
        }
        final title = (translation['title'] as String? ?? '').trim();
        final body = (translation['body'] as String? ?? '').trim();
        if (!titles.add('$locale|${title.toLowerCase()}')) {
          error(
            'quality.duplicateTitle',
            '\$.contents[$i].translations.$locale.title',
            'Title is duplicated in the same locale.',
            'Write a distinct, specific title.',
          );
        }
        if (!bodies.add('$locale|$body')) {
          error(
            'quality.duplicateBody',
            '\$.contents[$i].translations.$locale.body',
            'Body is duplicated verbatim.',
            'Write content-specific instructions.',
          );
        }
        if (body.length < minimumBodyCharacters ||
            body.length > maximumBodyCharacters) {
          error(
            'quality.bodyLength',
            '\$.contents[$i].translations.$locale.body',
            'Body length ${body.length} is outside $minimumBodyCharacters–$maximumBodyCharacters characters.',
            'Provide a concise but actionable explanation.',
          );
        }
        if (placeholderPattern.hasMatch(
          '$title ${translation['summary']} $body',
        )) {
          error(
            'quality.placeholder',
            '\$.contents[$i].translations.$locale',
            'Placeholder marker found.',
            'Replace it with reviewed editorial copy.',
          );
        }
        final english = byLocale['en'];
        if (locale != 'en' && body == english?['body']) {
          warning(
            'quality.suspiciousTranslation',
            '\$.contents[$i].translations.$locale.body',
            'Translation equals the English body.',
            'Review and localize the text naturally.',
          );
        }
      }
    }
    if (published.length < minimumPublishedContents) {
      error(
        'quality.minimumContents',
        r'$.contents',
        'Only ${published.length} published contents; at least $minimumPublishedContents are required.',
        'Add reviewed, fully localized contents.',
      );
    }
    for (final requiredType in ['tip', 'curiosity', 'idea']) {
      if ((typeCount[requiredType] ?? 0) < 8) {
        error(
          'quality.typeDistribution',
          r'$.contents',
          'Type $requiredType is underrepresented.',
          'Publish at least 8 entries for each core type.',
        );
      }
    }
    if ((difficultyCount['beginner'] ?? 0) < 8 ||
        (difficultyCount['intermediate'] ?? 0) < 8) {
      error(
        'quality.difficultyDistribution',
        r'$.contents',
        'Beginner and intermediate levels both need at least 8 entries.',
        'Rebalance difficulty metadata.',
      );
    }
    final declaredTags = package.list('tags');
    for (var i = 0; i < declaredTags.length; i++) {
      final tag = objectAt(declaredTags[i]);
      final id = tag?['id'] as String? ?? '';
      final code = tag?['code'] as String? ?? '';
      if (!tagCodePattern.hasMatch(code)) {
        error(
          'quality.tagFormat',
          '\$.tags[$i].code',
          'Tag code is not normalized kebab-case.',
          'Use a lowercase stable code.',
        );
      }
      if (!tagUse.containsKey(id)) {
        error(
          'quality.orphanTag',
          '\$.tags[$i].id',
          'Tag is unused by published content.',
          'Use the tag or remove it.',
        );
      }
    }
    return EditorialReport(
      packageId: package.id,
      counts: {...contract.counts, 'published': published.length},
      issues: issues,
    );
  }
}
