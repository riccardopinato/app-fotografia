import '../../../core/database/app_database.dart' as db;
import '../domain/user_profile.dart';
import '../../catalog/domain/catalog_models.dart';

UserProfile profileFromRow(db.UserProfile row) => UserProfile(
  id: row.id,
  skillLevel: SkillLevel.values.byName(row.skillLevel),
  languageMode: LanguageMode.values.byName(row.languageMode),
  selectedLocale: row.selectedLocale == null
      ? null
      : LocaleCode(row.selectedLocale!),
  preferredTopics: row.preferredTopics,
  cameraBodies: row.cameraBodies,
  lenses: row.lenses,
  smartphones: row.smartphones,
  learningGoals: row.learningGoals,
  themePreference: ThemePreference.values.byName(row.themePreference),
  createdAt: DateTime.fromMillisecondsSinceEpoch(
    row.createdAtUtcMs,
    isUtc: true,
  ),
  updatedAt: DateTime.fromMillisecondsSinceEpoch(
    row.updatedAtUtcMs,
    isUtc: true,
  ),
);
