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

  @override
  String get onboardingTitle => 'Fotoprofil einrichten';

  @override
  String get onboardingDescription =>
      'Wähle Einstellungen, die du jederzeit ändern kannst.';

  @override
  String get onboardingContinue => 'Einstellungen speichern';

  @override
  String get profileTitle => 'Dein Profil';

  @override
  String get profileDescription =>
      'Diese Einstellungen beeinflussen zukünftige Vorschläge.';

  @override
  String get profileSave => 'Änderungen speichern';

  @override
  String get profileSkillLevel => 'Erfahrungsstufe';

  @override
  String get skillBeginner => 'Anfänger';

  @override
  String get skillIntermediate => 'Fortgeschritten';

  @override
  String get skillAdvanced => 'Profi';

  @override
  String get profileTopics => 'Foto-Interessen';

  @override
  String get topicPortrait => 'Porträt';

  @override
  String get topicLandscape => 'Landschaft';

  @override
  String get topicStreet => 'Street';

  @override
  String get topicMacro => 'Makro';

  @override
  String get topicNight => 'Nachtfotografie';

  @override
  String get topicSmartphone => 'Smartphone';

  @override
  String get profileLearningGoals => 'Lernziele';

  @override
  String get goalComposition => 'Komposition';

  @override
  String get goalLight => 'Licht';

  @override
  String get goalTechnique => 'Kameratechnik';

  @override
  String get goalEditing => 'Bearbeitung';

  @override
  String get profileLanguage => 'App-Sprache';

  @override
  String get languageDevice => 'Gerätesprache verwenden';

  @override
  String get languageManual => 'Sprache auswählen';

  @override
  String get languageSelectionLabel => 'Sprache';

  @override
  String get languageEnglish => 'Englisch';

  @override
  String get languageItalian => 'Italienisch';

  @override
  String get languageSpanish => 'Spanisch';

  @override
  String get languageFrench => 'Französisch';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageBrazilianPortuguese => 'Brasilianisches Portugiesisch';

  @override
  String get profileSaveError =>
      'Deine Einstellungen konnten nicht gespeichert werden.';

  @override
  String get catalogTitle => 'Katalog entdecken';

  @override
  String get catalogOfflineAvailable => 'Available offline';

  @override
  String get catalogSearchHint => 'Techniken, Tipps und Tags suchen';

  @override
  String get catalogSearchSemantics => 'Catalog search field';

  @override
  String get catalogSearchClear => 'Clear search';

  @override
  String get catalogFiltersTitle => 'Filter';

  @override
  String catalogFiltersButton(int count) {
    return 'Filters ($count)';
  }

  @override
  String get catalogApplyFilters => 'Anwenden';

  @override
  String get catalogCancel => 'Abbrechen';

  @override
  String get catalogClearFilters => 'Filter löschen';

  @override
  String catalogRemoveFilter(String label) {
    return 'Remove $label filter';
  }

  @override
  String get catalogType => 'Type';

  @override
  String get catalogCategory => 'Category';

  @override
  String get catalogDifficulty => 'Difficulty';

  @override
  String get catalogTag => 'Tag';

  @override
  String catalogTypeLabel(String value) {
    return 'Type: $value';
  }

  @override
  String catalogCategoryLabel(String value) {
    return 'Category: $value';
  }

  @override
  String catalogDifficultyLabel(String value) {
    return 'Difficulty: $value';
  }

  @override
  String catalogPremiumLabel(String value) {
    return 'Premium: $value';
  }

  @override
  String catalogTagLabel(String value) {
    return 'Tag: $value';
  }

  @override
  String get catalogPremium => 'Premium';

  @override
  String get catalogPremiumOnly => 'Premium only';

  @override
  String get catalogFreeOnly => 'Free only';

  @override
  String get catalogLoading => 'Loading catalog';

  @override
  String get catalogLoadingMore => 'Loading more';

  @override
  String get catalogLoadMore => 'Mehr laden';

  @override
  String get catalogRetry => 'Erneut versuchen';

  @override
  String get catalogRefresh => 'Refresh';

  @override
  String get catalogNextPageError => 'The next page could not be loaded.';

  @override
  String get catalogEndOfResults => 'End of results';

  @override
  String get catalogEmptyTitle => 'No catalog items yet';

  @override
  String get catalogEmptyDescription => 'Install the local seed or try again.';

  @override
  String get catalogNoSearchResultsTitle => 'No search results';

  @override
  String get catalogNoSearchResultsDescription =>
      'Try a different term or clear the search.';

  @override
  String get catalogNoFilterResultsTitle => 'No filtered results';

  @override
  String get catalogNoFilterResultsDescription =>
      'Remove one or more filters to broaden the catalog.';

  @override
  String get catalogErrorTitle => 'Catalog unavailable';

  @override
  String get catalogErrorDescription =>
      'The local catalog could not be loaded.';

  @override
  String catalogCardSemantics(String title) {
    return 'Open $title';
  }

  @override
  String get catalogTypeTip => 'Tip';

  @override
  String get catalogTypeTechnique => 'Technique';

  @override
  String get catalogTypeCuriosity => 'Curiosity';

  @override
  String get catalogTypeIdea => 'Idea';

  @override
  String get catalogTypeCommonMistake => 'Common mistake';

  @override
  String get catalogTypeGuide => 'Guide';

  @override
  String get catalogTypeChecklist => 'Checklist';

  @override
  String get catalogTypeChallenge => 'Challenge';

  @override
  String get catalogTypeGlossary => 'Glossary';

  @override
  String get catalogTypeHistory => 'Photo history';

  @override
  String get catalogCategoryExposure => 'Exposure';

  @override
  String get catalogCategoryPortrait => 'Portrait';

  @override
  String get catalogCategoryComposition => 'Composition';

  @override
  String get catalogCategoryLowLight => 'Low light';

  @override
  String get catalogCategoryColor => 'Color';

  @override
  String get catalogCategoryMotion => 'Motion';

  @override
  String get catalogCategoryGear => 'Gear';

  @override
  String get catalogTagExposure => 'Exposure';

  @override
  String get catalogTagLight => 'Light';

  @override
  String get catalogTagComposition => 'Composition';

  @override
  String get catalogTagStability => 'Stability';

  @override
  String get catalogTagColor => 'Color';

  @override
  String get catalogTagFocus => 'Focus';

  @override
  String get catalogTagMetering => 'Metering';

  @override
  String get catalogTagPractice => 'Practice';

  @override
  String get catalogTagMotion => 'Motion';

  @override
  String get catalogTagMaintenance => 'Maintenance';

  @override
  String get catalogDetailTitle => 'Inhaltsdetails';

  @override
  String get catalogDetailBack => 'Zurück zum Katalog';

  @override
  String get catalogDetailLoading => 'Inhalt wird geladen';

  @override
  String get catalogDetailUnavailableTitle => 'Inhalt nicht verfügbar';

  @override
  String get catalogDetailUnavailableDescription =>
      'Dieser Inhalt ist offline nicht verfügbar oder nicht veröffentlichbar.';

  @override
  String get catalogDetailErrorTitle => 'Details konnten nicht geladen werden';

  @override
  String get catalogDetailErrorDescription =>
      'Versuche erneut, diesen Inhalt aus dem Offline-Katalog zu öffnen.';

  @override
  String get catalogDetailOffline => 'Offline verfügbar';

  @override
  String get catalogDetailSources => 'Quellen';

  @override
  String catalogDetailAttribution(String value) {
    return 'Namensnennung: $value';
  }

  @override
  String catalogDetailLicense(String value) {
    return 'Lizenz: $value';
  }

  @override
  String catalogDetailRights(String value) {
    return 'Rechte: $value';
  }

  @override
  String get catalogDetailRightsPublishable => 'veröffentlichbar';

  @override
  String get catalogDetailRightsRestricted => 'eingeschränkt';

  @override
  String get catalogDetailRightsUnknown => 'unbekannt';
}
