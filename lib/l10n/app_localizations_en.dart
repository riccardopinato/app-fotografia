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

  @override
  String get onboardingTitle => 'Set up your photography profile';

  @override
  String get onboardingDescription =>
      'Choose preferences you can change any time.';

  @override
  String get onboardingContinue => 'Save preferences';

  @override
  String get profileTitle => 'Your profile';

  @override
  String get profileDescription =>
      'These preferences shape future suggestions.';

  @override
  String get profileSave => 'Save changes';

  @override
  String get profileSkillLevel => 'Experience level';

  @override
  String get skillBeginner => 'Beginner';

  @override
  String get skillIntermediate => 'Intermediate';

  @override
  String get skillAdvanced => 'Advanced';

  @override
  String get profileTopics => 'Photography interests';

  @override
  String get topicPortrait => 'Portrait';

  @override
  String get topicLandscape => 'Landscape';

  @override
  String get topicStreet => 'Street';

  @override
  String get topicMacro => 'Macro';

  @override
  String get topicNight => 'Night photography';

  @override
  String get topicSmartphone => 'Smartphone';

  @override
  String get profileLearningGoals => 'Learning goals';

  @override
  String get goalComposition => 'Composition';

  @override
  String get goalLight => 'Light';

  @override
  String get goalTechnique => 'Camera technique';

  @override
  String get goalEditing => 'Editing';

  @override
  String get profileLanguage => 'App language';

  @override
  String get languageDevice => 'Use device language';

  @override
  String get languageManual => 'Choose a language';

  @override
  String get languageSelectionLabel => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageItalian => 'Italian';

  @override
  String get languageSpanish => 'Spanish';

  @override
  String get languageFrench => 'French';

  @override
  String get languageGerman => 'German';

  @override
  String get languageBrazilianPortuguese => 'Brazilian Portuguese';

  @override
  String get profileSaveError =>
      'Your preferences could not be saved. Try again.';

  @override
  String get catalogTitle => 'Explore catalog';

  @override
  String get catalogOfflineAvailable => 'Available offline';

  @override
  String get catalogSearchHint => 'Search techniques, tips and tags';

  @override
  String get catalogSearchSemantics => 'Catalog search field';

  @override
  String get catalogSearchClear => 'Clear search';

  @override
  String get catalogFiltersTitle => 'Filters';

  @override
  String catalogFiltersButton(int count) {
    return 'Filters ($count)';
  }

  @override
  String get catalogApplyFilters => 'Apply';

  @override
  String get catalogCancel => 'Cancel';

  @override
  String get catalogClearFilters => 'Clear filters';

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
  String get catalogLoadMore => 'Load more';

  @override
  String get catalogRetry => 'Try again';

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
  String get catalogDetailTitle => 'Content detail';

  @override
  String get catalogDetailBack => 'Back to catalog';

  @override
  String get catalogDetailLoading => 'Loading content';

  @override
  String get catalogDetailUnavailableTitle => 'Content unavailable';

  @override
  String get catalogDetailUnavailableDescription =>
      'This content is not available offline or is not publishable.';

  @override
  String get catalogDetailErrorTitle => 'Detail unavailable';

  @override
  String get catalogDetailErrorDescription =>
      'Try reading this content again from the offline catalog.';

  @override
  String get catalogDetailOffline => 'Available offline';

  @override
  String get catalogDetailSources => 'Sources';

  @override
  String catalogDetailAttribution(String value) {
    return 'Attribution: $value';
  }

  @override
  String catalogDetailLicense(String value) {
    return 'License: $value';
  }

  @override
  String catalogDetailRights(String value) {
    return 'Rights: $value';
  }

  @override
  String get catalogDetailRightsPublishable => 'publishable';

  @override
  String get catalogDetailRightsRestricted => 'restricted';

  @override
  String get catalogDetailRightsUnknown => 'unknown';

  @override
  String get profileEquipment => 'Photography equipment';

  @override
  String get profileCameraBodies => 'Camera bodies';

  @override
  String get profileLenses => 'Lenses';

  @override
  String get profileSmartphones => 'Smartphones';

  @override
  String get equipmentMirrorless => 'Mirrorless camera';

  @override
  String get equipmentDslr => 'DSLR camera';

  @override
  String get equipmentFilm => 'Film camera';

  @override
  String get equipmentPrimeLens => 'Prime lens';

  @override
  String get equipmentZoomLens => 'Zoom lens';

  @override
  String get equipmentTelephotoLens => 'Telephoto lens';

  @override
  String get equipmentIPhone => 'iPhone';

  @override
  String get equipmentAndroid => 'Android phone';

  @override
  String get homeGreeting => 'Your photography, at your pace';

  @override
  String get homeLoading => 'Loading personalised suggestions';

  @override
  String get homeError => 'Something went wrong. Please try again.';

  @override
  String get homeIncompleteProfile =>
      'Complete your profile to refine these suggestions.';

  @override
  String get homeChosenForYou => 'Chosen for you';

  @override
  String get homeImproveIdeas => 'Ideas to improve';

  @override
  String get homeForYourLevel => 'Right for your level';

  @override
  String get homeOpenCatalog => 'Open the full catalog';

  @override
  String get homeEmptyCatalog => 'The offline catalog is currently empty.';

  @override
  String get homeEditorialFallback => 'A useful editorial selection for you';

  @override
  String get homeReasonInterest => 'Chosen for your photography interest';

  @override
  String get homeReasonGoal => 'Can help you reach your learning goal';

  @override
  String get homeReasonLevel => 'Right for your level';

  @override
  String get homeReasonEquipment => 'Compatible with your equipment';
}
