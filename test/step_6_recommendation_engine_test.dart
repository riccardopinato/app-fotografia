import 'package:flutter_test/flutter_test.dart';
import 'package:framelab/features/catalog/domain/catalog_models.dart';
import 'package:framelab/features/home/domain/recommendation_engine.dart';
import 'package:framelab/features/profile/domain/user_profile.dart';

void main() {
  final now = DateTime(2025);
  LocalizedContent item(
    String id, {
    String tag = 'landscape',
    Difficulty difficulty = Difficulty.beginner,
  }) => LocalizedContent(
    item: ContentItem(
      id: id,
      type: ContentType.idea,
      primaryCategory: tag,
      difficulty: difficulty,
      premium: false,
      canonicalLocale: const LocaleCode('en'),
      editorialStatus: EditorialStatus.published,
      version: 1,
      createdAt: now,
      updatedAt: now,
    ),
    translation: ContentTranslation(
      id: 't$id',
      contentId: id,
      locale: const LocaleCode('en'),
      title: id,
      summary: 's',
      body: 'b',
      status: TranslationStatus.published,
      method: TranslationMethod.human,
      sourceVersion: 1,
      createdAt: now,
      updatedAt: now,
    ),
    tags: [Tag(id: tag, code: tag)],
  );
  final profile = UserProfile(
    id: 'p',
    skillLevel: SkillLevel.beginner,
    languageMode: LanguageMode.device,
    themePreference: ThemePreference.system,
    preferredTopics: ['landscape'],
    createdAt: now,
    updatedAt: now,
  );
  test('is deterministic and prioritizes interests', () {
    final e = RecommendationEngine();
    final r = e.recommend(
      contents: [
        item('b', tag: 'portrait'),
        item('a'),
      ],
      profile: profile,
      locale: const LocaleCode('en'),
    );
    expect(r.first.content.item.id, 'a');
    expect(r.first.reasons, contains(RecommendationReason.interest));
  });
  test('deduplicates and stable ties', () {
    final r = RecommendationEngine().recommend(
      contents: [
        item('b', tag: 'x'),
        item('a', tag: 'x'),
        item('a', tag: 'x'),
      ],
      profile: null,
      locale: const LocaleCode('it'),
    );
    expect(r.map((x) => x.content.item.id), ['a', 'b']);
  });
}
