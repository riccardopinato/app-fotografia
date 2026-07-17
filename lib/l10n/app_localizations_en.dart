// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'FrameLab';

  @override
  String get navHome => 'Home';

  @override
  String get navExplore => 'Explore';

  @override
  String get navIdeas => 'Ideas';

  @override
  String get navLibrary => 'Library';

  @override
  String get navProfile => 'Profile';

  @override
  String get homePlaceholderTitle => 'Your photography space is taking shape';

  @override
  String get homePlaceholderDescription =>
      'The Home experience will arrive in a future update.';

  @override
  String get explorePlaceholderTitle => 'Explore is coming soon';

  @override
  String get explorePlaceholderDescription =>
      'Discoverable photography content will appear here.';

  @override
  String get ideasPlaceholderTitle => 'Ideas are coming soon';

  @override
  String get ideasPlaceholderDescription =>
      'Personalized photo prompts will appear here.';

  @override
  String get libraryPlaceholderTitle => 'Your library is coming soon';

  @override
  String get libraryPlaceholderDescription =>
      'Saved inspiration and notes will appear here.';

  @override
  String get profilePlaceholderTitle => 'Your profile is coming soon';

  @override
  String get profilePlaceholderDescription =>
      'Your preferences and photography journey will appear here.';

  @override
  String get navigationLabel => 'Main navigation';
}
