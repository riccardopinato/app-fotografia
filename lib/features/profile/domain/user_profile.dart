import '../../catalog/domain/catalog_models.dart';

enum SkillLevel { beginner, intermediate, advanced }

enum ThemePreference { system, light, dark }

class UserProfile {
  const UserProfile({
    required this.id,
    required this.skillLevel,
    required this.preferredLocale,
    required this.themePreference,
    required this.createdAt,
    required this.updatedAt,
  });
  final String id;
  final SkillLevel skillLevel;
  final LocaleCode preferredLocale;
  final ThemePreference themePreference;
  final DateTime createdAt;
  final DateTime updatedAt;
}
