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

  @override
  String get onboardingTitle => 'Configurez votre profil photo';

  @override
  String get onboardingDescription =>
      'Choisissez des préférences modifiables à tout moment.';

  @override
  String get onboardingContinue => 'Enregistrer les préférences';

  @override
  String get profileTitle => 'Votre profil';

  @override
  String get profileDescription =>
      'Ces préférences guideront les futures suggestions.';

  @override
  String get profileSave => 'Enregistrer les modifications';

  @override
  String get profileSkillLevel => 'Niveau d\'expérience';

  @override
  String get skillBeginner => 'Débutant';

  @override
  String get skillIntermediate => 'Intermédiaire';

  @override
  String get skillAdvanced => 'Avancé';

  @override
  String get profileTopics => 'Centres d\'intérêt photo';

  @override
  String get topicPortrait => 'Portrait';

  @override
  String get topicLandscape => 'Paysage';

  @override
  String get topicStreet => 'Street';

  @override
  String get topicMacro => 'Macro';

  @override
  String get topicNight => 'Photographie de nuit';

  @override
  String get topicSmartphone => 'Smartphone';

  @override
  String get profileEquipment => 'Équipement photo';

  @override
  String get profileCameraBodies => 'Boîtiers';

  @override
  String get profileLenses => 'Objectifs';

  @override
  String get profileSmartphones => 'Smartphones';

  @override
  String get equipmentMirrorless => 'Appareil hybride';

  @override
  String get equipmentDslr => 'Reflex numérique';

  @override
  String get equipmentFilm => 'Appareil argentique';

  @override
  String get equipmentPrimeLens => 'Objectif à focale fixe';

  @override
  String get equipmentZoomLens => 'Objectif zoom';

  @override
  String get equipmentTelephotoLens => 'Téléobjectif';

  @override
  String get equipmentIPhone => 'iPhone';

  @override
  String get equipmentAndroid => 'Téléphone Android';

  @override
  String get profileLearningGoals => 'Objectifs d\'apprentissage';

  @override
  String get goalComposition => 'Composition';

  @override
  String get goalLight => 'Lumière';

  @override
  String get goalTechnique => 'Technique d\'appareil';

  @override
  String get goalEditing => 'Retouche';

  @override
  String get profileLanguage => 'Langue de l\'application';

  @override
  String get languageDevice => 'Utiliser la langue de l\'appareil';

  @override
  String get languageManual => 'Choisir une langue';

  @override
  String get languageSelectionLabel => 'Langue';

  @override
  String get languageEnglish => 'Anglais';

  @override
  String get languageItalian => 'Italien';

  @override
  String get languageSpanish => 'Espagnol';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageGerman => 'Allemand';

  @override
  String get languageBrazilianPortuguese => 'Portugais brésilien';

  @override
  String get profileSaveError =>
      'Vos préférences n\'ont pas pu être enregistrées. Réessayez.';

  @override
  String get catalogTitle => 'Explorer le catalogue';

  @override
  String get catalogOfflineAvailable => 'Available offline';

  @override
  String get catalogSearchHint => 'Rechercher techniques, conseils et tags';

  @override
  String get catalogSearchSemantics => 'Catalog search field';

  @override
  String get catalogSearchClear => 'Clear search';

  @override
  String get catalogFiltersTitle => 'Filtres';

  @override
  String catalogFiltersButton(int count) {
    return 'Filters ($count)';
  }

  @override
  String get catalogApplyFilters => 'Appliquer';

  @override
  String get catalogCancel => 'Annuler';

  @override
  String get catalogClearFilters => 'Effacer les filtres';

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
  String get catalogLoadMore => 'Charger plus';

  @override
  String get catalogRetry => 'Réessayer';

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
  String get catalogDetailTitle => 'Détail du contenu';

  @override
  String get catalogDetailBack => 'Retour au catalogue';

  @override
  String get catalogDetailLoading => 'Chargement du contenu';

  @override
  String get catalogDetailUnavailableTitle => 'Contenu indisponible';

  @override
  String get catalogDetailUnavailableDescription =>
      'Ce contenu n’est pas disponible hors ligne ou ne peut pas être publié.';

  @override
  String get catalogDetailErrorTitle => 'Impossible de charger le détail';

  @override
  String get catalogDetailErrorDescription =>
      'Réessayez de lire ce contenu depuis le catalogue hors ligne.';

  @override
  String get catalogDetailOffline => 'Disponible hors ligne';

  @override
  String get catalogDetailSources => 'Sources';

  @override
  String catalogDetailAttribution(String value) {
    return 'Attribution : $value';
  }

  @override
  String catalogDetailLicense(String value) {
    return 'Licence : $value';
  }

  @override
  String catalogDetailRights(String value) {
    return 'Droits : $value';
  }

  @override
  String get catalogDetailRightsPublishable => 'publiable';

  @override
  String get catalogDetailRightsRestricted => 'restreint';

  @override
  String get catalogDetailRightsUnknown => 'inconnu';
}
