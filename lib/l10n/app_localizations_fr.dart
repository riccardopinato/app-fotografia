// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'FrameLab';

  @override
  String get navHome => 'Accueil';

  @override
  String get navExplore => 'Explorer';

  @override
  String get navIdeas => 'Idées';

  @override
  String get navLibrary => 'Bibliothèque';

  @override
  String get navProfile => 'Profil';

  @override
  String get homePlaceholderTitle => 'Votre espace photo prend forme';

  @override
  String get homePlaceholderDescription =>
      'L\'expérience Accueil arrivera dans une prochaine mise à jour.';

  @override
  String get explorePlaceholderTitle => 'Explorer arrive bientôt';

  @override
  String get explorePlaceholderDescription =>
      'Du contenu photographique à découvrir apparaîtra ici.';

  @override
  String get ideasPlaceholderTitle => 'Les idées arrivent bientôt';

  @override
  String get ideasPlaceholderDescription =>
      'Des propositions photo personnalisées apparaîtront ici.';

  @override
  String get libraryPlaceholderTitle => 'Votre bibliothèque arrive bientôt';

  @override
  String get libraryPlaceholderDescription =>
      'Vos inspirations et notes enregistrées apparaîtront ici.';

  @override
  String get profilePlaceholderTitle => 'Votre profil arrive bientôt';

  @override
  String get profilePlaceholderDescription =>
      'Vos préférences et votre parcours photo apparaîtront ici.';

  @override
  String get navigationLabel => 'Navigation principale';
}
