import '../../catalog/domain/catalog_models.dart';

enum SkillLevel { beginner, intermediate, advanced }

enum ThemePreference { system, light, dark }

enum LanguageMode { device, manual }

class UserProfile {
  const UserProfile({
    required this.id,
    required this.skillLevel,
    required this.languageMode,
    this.selectedLocale,
    this.preferredTopics = const [],
    this.cameraBodies = const [],
    this.lenses = const [],
    this.smartphones = const [],
    this.learningGoals = const [],
    required this.themePreference,
    required this.createdAt,
    required this.updatedAt,
  });
  final String id;
  final SkillLevel skillLevel;
  final LanguageMode languageMode;
  final LocaleCode? selectedLocale;
  final List<String> preferredTopics;
  final List<String> cameraBodies;
  final List<String> lenses;
  final List<String> smartphones;
  final List<String> learningGoals;
  final ThemePreference themePreference;
  final DateTime createdAt;
  final DateTime updatedAt;
}
