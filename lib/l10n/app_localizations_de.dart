// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'FrameLab';

  @override
  String get navHome => 'Startseite';

  @override
  String get navExplore => 'Entdecken';

  @override
  String get navIdeas => 'Ideen';

  @override
  String get navLibrary => 'Archiv';

  @override
  String get navProfile => 'Profil';

  @override
  String get homePlaceholderTitle => 'Dein Fotobereich nimmt Gestalt an';

  @override
  String get homePlaceholderDescription =>
      'Das Startseitenerlebnis kommt in einem zukünftigen Update.';

  @override
  String get explorePlaceholderTitle => 'Entdecken kommt bald';

  @override
  String get explorePlaceholderDescription =>
      'Hier erscheinen fotografische Inhalte zum Entdecken.';

  @override
  String get ideasPlaceholderTitle => 'Ideen kommen bald';

  @override
  String get ideasPlaceholderDescription =>
      'Hier erscheinen persönliche Fotoimpulse.';

  @override
  String get libraryPlaceholderTitle => 'Dein Archiv kommt bald';

  @override
  String get libraryPlaceholderDescription =>
      'Hier erscheinen gespeicherte Inspirationen und Notizen.';

  @override
  String get profilePlaceholderTitle => 'Dein Profil kommt bald';

  @override
  String get profilePlaceholderDescription =>
      'Hier erscheinen deine Präferenzen und dein Fotoweg.';

  @override
  String get navigationLabel => 'Hauptnavigation';
}
