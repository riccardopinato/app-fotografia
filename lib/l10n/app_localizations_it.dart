// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'FrameLab';

  @override
  String get navHome => 'Home';

  @override
  String get navExplore => 'Esplora';

  @override
  String get navIdeas => 'Idee';

  @override
  String get navLibrary => 'Archivio';

  @override
  String get navProfile => 'Profilo';

  @override
  String get homePlaceholderTitle =>
      'Il tuo spazio fotografico sta prendendo forma';

  @override
  String get homePlaceholderDescription =>
      'L\'esperienza Home arriverà in un futuro aggiornamento.';

  @override
  String get explorePlaceholderTitle => 'Esplora arriverà presto';

  @override
  String get explorePlaceholderDescription =>
      'Qui appariranno contenuti fotografici da scoprire.';

  @override
  String get ideasPlaceholderTitle => 'Le idee arriveranno presto';

  @override
  String get ideasPlaceholderDescription =>
      'Qui appariranno proposte fotografiche personalizzate.';

  @override
  String get libraryPlaceholderTitle => 'Il tuo archivio arriverà presto';

  @override
  String get libraryPlaceholderDescription =>
      'Qui appariranno ispirazioni e note salvate.';

  @override
  String get profilePlaceholderTitle => 'Il tuo profilo arriverà presto';

  @override
  String get profilePlaceholderDescription =>
      'Qui appariranno preferenze e percorso fotografico.';

  @override
  String get navigationLabel => 'Navigazione principale';

  @override
  String get onboardingTitle => 'Configura il tuo profilo fotografico';

  @override
  String get onboardingDescription =>
      'Scegli preferenze modificabili in qualsiasi momento.';

  @override
  String get onboardingContinue => 'Salva preferenze';

  @override
  String get profileTitle => 'Il tuo profilo';

  @override
  String get profileDescription =>
      'Queste preferenze influenzeranno i suggerimenti futuri.';

  @override
  String get profileSave => 'Salva modifiche';

  @override
  String get profileSkillLevel => 'Livello di esperienza';

  @override
  String get skillBeginner => 'Principiante';

  @override
  String get skillIntermediate => 'Intermedio';

  @override
  String get skillAdvanced => 'Avanzato';

  @override
  String get profileTopics => 'Interessi fotografici';

  @override
  String get topicPortrait => 'Ritratto';

  @override
  String get topicLandscape => 'Paesaggio';

  @override
  String get topicStreet => 'Street';

  @override
  String get topicMacro => 'Macro';

  @override
  String get topicNight => 'Fotografia notturna';

  @override
  String get topicSmartphone => 'Smartphone';

  @override
  String get profileLearningGoals => 'Obiettivi di apprendimento';

  @override
  String get goalComposition => 'Composizione';

  @override
  String get goalLight => 'Luce';

  @override
  String get goalTechnique => 'Tecnica fotografica';

  @override
  String get goalEditing => 'Editing';

  @override
  String get profileLanguage => 'Lingua dell\'app';

  @override
  String get languageDevice => 'Usa la lingua del dispositivo';

  @override
  String get languageManual => 'Scegli una lingua';

  @override
  String get languageSelectionLabel => 'Lingua';

  @override
  String get languageEnglish => 'Inglese';

  @override
  String get languageItalian => 'Italiano';

  @override
  String get languageSpanish => 'Spagnolo';

  @override
  String get languageFrench => 'Francese';

  @override
  String get languageGerman => 'Tedesco';

  @override
  String get languageBrazilianPortuguese => 'Portoghese brasiliano';

  @override
  String get profileSaveError =>
      'Non è stato possibile salvare le preferenze. Riprova.';

  @override
  String get catalogTitle => 'Esplora catalogo';

  @override
  String get catalogOfflineAvailable => 'Disponibile offline';

  @override
  String get catalogSearchHint => 'Cerca tecniche, consigli e tag';

  @override
  String get catalogSearchSemantics => 'Catalog search field';

  @override
  String get catalogSearchClear => 'Clear search';

  @override
  String get catalogFiltersTitle => 'Filtri';

  @override
  String catalogFiltersButton(int count) {
    return 'Filters ($count)';
  }

  @override
  String get catalogApplyFilters => 'Applica';

  @override
  String get catalogCancel => 'Annulla';

  @override
  String get catalogClearFilters => 'Azzera filtri';

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
  String get catalogPremiumOnly => 'Solo Premium';

  @override
  String get catalogFreeOnly => 'Solo gratuiti';

  @override
  String get catalogLoading => 'Loading catalog';

  @override
  String get catalogLoadingMore => 'Loading more';

  @override
  String get catalogLoadMore => 'Carica altro';

  @override
  String get catalogRetry => 'Riprova';

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
  String get catalogNoSearchResultsTitle => 'Nessun risultato';

  @override
  String get catalogNoSearchResultsDescription =>
      'Try a different term or clear the search.';

  @override
  String get catalogNoFilterResultsTitle =>
      'Nessun risultato con questi filtri';

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
  String get catalogTypeTip => 'Consiglio';

  @override
  String get catalogTypeTechnique => 'Tecnica';

  @override
  String get catalogTypeCuriosity => 'Curiosity';

  @override
  String get catalogTypeIdea => 'Idea';

  @override
  String get catalogTypeCommonMistake => 'Common mistake';

  @override
  String get catalogTypeGuide => 'Guida';

  @override
  String get catalogTypeChecklist => 'Checklist';

  @override
  String get catalogTypeChallenge => 'Sfida';

  @override
  String get catalogTypeGlossary => 'Glossary';

  @override
  String get catalogTypeHistory => 'Photo history';

  @override
  String get catalogCategoryExposure => 'Esposizione';

  @override
  String get catalogCategoryPortrait => 'Ritratto';

  @override
  String get catalogCategoryComposition => 'Composizione';

  @override
  String get catalogCategoryLowLight => 'Poca luce';

  @override
  String get catalogCategoryColor => 'Colore';

  @override
  String get catalogCategoryMotion => 'Movimento';

  @override
  String get catalogCategoryGear => 'Attrezzatura';

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
  String get catalogTagMaintenance => 'Manutenzione';
}
