import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/catalog_models.dart';

/// Versioned, deterministic, local editorial seed. A future v2 adds new
/// records or updates only these fixed IDs inside the transaction below.
abstract final class FrameLabSeed {
  static const version = 1;
  static const sourceId = '10000000-0000-4000-8000-000000000001';

  static Future<void> install(
    AppDatabase database,
  ) => database.transaction(() async {
    const now = 1735689600000;
    await database
        .into(database.contentSources)
        .insertOnConflictUpdate(
          ContentSourcesCompanion.insert(
            id: sourceId,
            title: 'FrameLab Editorial',
            author: const Value('FrameLab'),
            publisher: const Value('FrameLab'),
            originalLocale: 'en',
            licenseType: 'proprietary-original',
            attributionText: const Value('Original FrameLab editorial content'),
            rightsStatus: RightsStatus.publishable.name,
            createdAtUtcMs: now,
            updatedAtUtcMs: now,
          ),
        );
    for (var index = 0; index < _entries.length; index++) {
      final entry = _entries[index];
      final id =
          '10000000-0000-4000-8000-${(index + 10).toString().padLeft(12, '0')}';
      await database
          .into(database.contentItems)
          .insertOnConflictUpdate(
            ContentItemsCompanion.insert(
              id: id,
              type: entry.type.name,
              primaryCategory: entry.category,
              difficulty: entry.difficulty.name,
              premium: false,
              canonicalLocale: 'en',
              editorialStatus: EditorialStatus.published.name,
              version: version,
              createdAtUtcMs: now,
              updatedAtUtcMs: now,
              publishedAtUtcMs: const Value(now),
            ),
          );
      await database
          .into(database.contentItemSources)
          .insertOnConflictUpdate(
            ContentItemSourcesCompanion.insert(
              contentId: id,
              sourceId: sourceId,
            ),
          );
      await database
          .into(database.contentTranslations)
          .insertOnConflictUpdate(
            ContentTranslationsCompanion.insert(
              id: '$id-en',
              contentId: id,
              locale: 'en',
              title: entry.title,
              summary: entry.summary,
              body: entry.body,
              translationStatus: TranslationStatus.published.name,
              translationMethod: TranslationMethod.original.name,
              sourceVersion: version,
              reviewedAtUtcMs: const Value(now),
              createdAtUtcMs: now,
              updatedAtUtcMs: now,
            ),
          );
      for (final tag in entry.tags) {
        await database
            .into(database.tags)
            .insertOnConflictUpdate(
              TagsCompanion.insert(id: 'tag-$tag', code: tag),
            );
        await database
            .into(database.contentItemTags)
            .insertOnConflictUpdate(
              ContentItemTagsCompanion.insert(contentId: id, tagId: 'tag-$tag'),
            );
      }
    }
  });
}

class _SeedEntry {
  const _SeedEntry(
    this.type,
    this.category,
    this.difficulty,
    this.title,
    this.summary,
    this.body,
    this.tags,
  );
  final ContentType type;
  final String category;
  final Difficulty difficulty;
  final String title;
  final String summary;
  final String body;
  final List<String> tags;
}

const _entries = [
  _SeedEntry(
    ContentType.tip,
    'portrait',
    Difficulty.beginner,
    'Find the portrait light',
    'Turn a face toward soft window light.',
    'Start with the subject near a window and turn their face slowly. Watch for a gentle shadow on the far cheek, then simplify the background before pressing the shutter.',
    ['portrait', 'lighting'],
  ),
  _SeedEntry(
    ContentType.technique,
    'exposure',
    Difficulty.beginner,
    'Read exposure as a trade-off',
    'Balance aperture, shutter speed, and ISO.',
    'Choose the shutter speed that protects the motion first. Then choose aperture for depth of field and raise ISO only as far as the available light requires.',
    ['exposure', 'technique'],
  ),
  _SeedEntry(
    ContentType.curiosity,
    'landscape',
    Difficulty.beginner,
    'Edges shape a landscape',
    'The frame edge can strengthen a quiet scene.',
    'Before taking a landscape photograph, inspect every edge. Move a step or change focal length until bright distractions and cut-off objects no longer pull attention away.',
    ['landscape', 'composition'],
  ),
  _SeedEntry(
    ContentType.idea,
    'street',
    Difficulty.intermediate,
    'Walk one block twice',
    'Use a repeat route to notice changing gestures.',
    'Walk one short block, then return by the same route. On the second pass, wait for one gesture, reflection, or color relationship that was not visible before.',
    ['street', 'composition'],
  ),
  _SeedEntry(
    ContentType.commonMistake,
    'macro',
    Difficulty.beginner,
    'Do not chase focus by leaning',
    'Macro depth of field is thinner than it looks.',
    'Rest the camera or your elbows when possible. Set focus deliberately, then move the camera by millimetres only after checking the most important detail.',
    ['macro', 'focus'],
  ),
  _SeedEntry(
    ContentType.guide,
    'night',
    Difficulty.intermediate,
    'A calm night exposure',
    'Build a stable night photograph step by step.',
    'Mount the camera securely, use a short self-timer, and review highlights after each frame. Begin at a moderate ISO and lengthen the exposure before accepting noisy shadows.',
    ['night', 'exposure'],
  ),
  _SeedEntry(
    ContentType.checklist,
    'gear',
    Difficulty.beginner,
    'Before leaving for a shoot',
    'A compact preparation checklist.',
    'Charge batteries. Clear a card. Pack one lens that suits the purpose. Check the weather and choose one simple intention for the session.',
    ['gear', 'checklist'],
  ),
  _SeedEntry(
    ContentType.challenge,
    'composition',
    Difficulty.beginner,
    'Three-frame composition challenge',
    'Make three frames without changing your subject.',
    'Photograph one subject three times: wide, close, and from a lower viewpoint. Compare which frame gives the subject the clearest role and why.',
    ['composition', 'challenge'],
  ),
  _SeedEntry(
    ContentType.glossary,
    'exposure',
    Difficulty.beginner,
    'Exposure compensation',
    'A direct way to brighten or darken an automatic exposure.',
    'Exposure compensation tells an automatic mode to place the result brighter or darker than its meter suggests. Use it when a bright or dark scene fools the meter.',
    ['exposure', 'glossary'],
  ),
  _SeedEntry(
    ContentType.photographicHistory,
    'street',
    Difficulty.intermediate,
    'The small-camera shift',
    'Portable cameras changed how photographers could work.',
    'As cameras became smaller, photographers could react more quickly in public spaces. The lesson remains practical: choose equipment that lets you stay attentive to the scene.',
    ['street', 'history', 'gear'],
  ),
];
