import '../../catalog/domain/catalog_models.dart';
import '../../profile/domain/user_profile.dart';

/// Pure, offline deterministic Home rules. Weights: topic 40, goal 24, level
/// 18, equipment 12, exact locale 4; premium receives a 3-point penalty.
class RecommendationEngine {
  const RecommendationEngine();
  List<Recommendation> recommend({
    required Iterable<LocalizedContent> contents,
    UserProfile? profile,
    required LocaleCode locale,
    int limit = 10,
  }) {
    final unique = <String, Recommendation>{};
    for (final content in contents) {
      if (content.item.editorialStatus != EditorialStatus.published ||
          !content.translation.isPublishable) {
        continue;
      }
      final tags = content.tags.map((tag) => tag.code.toLowerCase()).toSet();
      final category = content.item.primaryCategory.toLowerCase();
      final reasons = <RecommendationReason>[];
      var score = content.translation.locale == locale ? 4 : 0;
      if (profile != null) {
        if (profile.preferredTopics.any(
          (v) => tags.contains(v.toLowerCase()) || category == v.toLowerCase(),
        )) {
          score += 40;
          reasons.add(RecommendationReason.interest);
        }
        if (profile.learningGoals.any(
          (v) =>
              tags.contains(v.toLowerCase()) ||
              content.item.type.name == v.toLowerCase(),
        )) {
          score += 24;
          reasons.add(RecommendationReason.goal);
        }
        if (_levelMatches(profile.skillLevel, content.item.difficulty)) {
          score += 18;
          reasons.add(RecommendationReason.level);
        }
        if ([
          ...profile.cameraBodies,
          ...profile.lenses,
          ...profile.smartphones,
        ].map((v) => v.toLowerCase()).any(tags.contains)) {
          score += 12;
          reasons.add(RecommendationReason.equipment);
        }
      }
      if (content.item.premium) score -= 3;
      unique.putIfAbsent(
        content.item.id,
        () => Recommendation(content: content, score: score, reasons: reasons),
      );
    }
    final values = unique.values.toList()
      ..sort((a, b) {
        final byScore = b.score.compareTo(a.score);
        return byScore != 0
            ? byScore
            : a.content.item.id.compareTo(b.content.item.id);
      });
    return values.take(limit).toList();
  }

  bool _levelMatches(SkillLevel l, Difficulty d) =>
      (l == SkillLevel.beginner && d == Difficulty.beginner) ||
      (l == SkillLevel.intermediate &&
          (d == Difficulty.beginner || d == Difficulty.intermediate)) ||
      (l == SkillLevel.advanced && d != Difficulty.advanced
          ? true
          : l == SkillLevel.advanced && d == Difficulty.advanced);
}

enum RecommendationReason { interest, goal, level, equipment }

class Recommendation {
  const Recommendation({
    required this.content,
    required this.score,
    required this.reasons,
  });
  final LocalizedContent content;
  final int score;
  final List<RecommendationReason> reasons;
}
