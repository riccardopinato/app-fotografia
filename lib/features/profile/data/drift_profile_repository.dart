import 'package:drift/drift.dart' show Value;

import '../../../core/database/app_database.dart' as db;
import '../domain/profile_repository.dart';
import '../domain/user_profile.dart';
import 'profile_mapper.dart';

class DriftProfileRepository implements ProfileRepository {
  DriftProfileRepository(this._database);
  final db.AppDatabase _database;
  @override
  Future<UserProfile?> get() async {
    final row = await _database
        .select(_database.userProfiles)
        .getSingleOrNull();
    return row == null ? null : profileFromRow(row);
  }

  @override
  Stream<UserProfile?> watch() => _database
      .select(_database.userProfiles)
      .watchSingleOrNull()
      .map((row) => row == null ? null : profileFromRow(row));
  @override
  Future<void> save(UserProfile profile) => _database
      .into(_database.userProfiles)
      .insertOnConflictUpdate(
        db.UserProfilesCompanion.insert(
          id: profile.id,
          skillLevel: profile.skillLevel.name,
          preferredLocale: profile.selectedLocale?.value ?? 'en',
          languageMode: Value(profile.languageMode.name),
          selectedLocale: Value(profile.selectedLocale?.value),
          preferredTopics: Value(profile.preferredTopics),
          cameraBodies: Value(profile.cameraBodies),
          lenses: Value(profile.lenses),
          smartphones: Value(profile.smartphones),
          learningGoals: Value(profile.learningGoals),
          themePreference: profile.themePreference.name,
          createdAtUtcMs: profile.createdAt.toUtc().millisecondsSinceEpoch,
          updatedAtUtcMs: profile.updatedAt.toUtc().millisecondsSinceEpoch,
        ),
      );
}
