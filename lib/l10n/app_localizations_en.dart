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
  String get libraryLoading => 'Loading saved content';

  @override
  String get libraryEmptyTitle => 'No saved content yet';

  @override
  String get libraryEmptyDescription =>
      'Save content from the catalog to find it here.';

  @override
  String get libraryErrorTitle => 'Library unavailable';

  @override
  String get libraryErrorDescription => 'Try loading your saved content again.';

  @override
  String libraryCardSemantics(String title) {
    return 'Open saved content: $title';
  }

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
  String get catalogEmptyDescription =>
      'The offline catalog is unavailable. Try again.';

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
  String get catalogDetailSave => 'Save';

  @override
  String get catalogDetailSaved => 'Saved';

  @override
  String get catalogDetailSaveError =>
      'The saved state could not be updated. Try again.';

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

  @override
  String get libraryNoResultsTitle => 'No saved content found';

  @override
  String get libraryNoResultsDescription =>
      'Try changing the search or filters.';

  @override
  String get libraryClearFilters => 'Clear search and filters';

  @override
  String get librarySearchHint => 'Search saved content and notes';

  @override
  String get librarySearchClear => 'Clear library search';

  @override
  String get libraryAllStatuses => 'All statuses';

  @override
  String get libraryAllCollections => 'All collections';

  @override
  String get libraryManageCollections => 'Manage collections';

  @override
  String get libraryStatusToTry => 'To try';

  @override
  String get libraryStatusTried => 'Tried';

  @override
  String get libraryStatusCompleted => 'Completed';

  @override
  String libraryEditItem(String title) {
    return 'Edit $title';
  }

  @override
  String get libraryStatusLabel => 'Status';

  @override
  String get libraryCollectionLabel => 'Collection';

  @override
  String get libraryNoCollection => 'No collection';

  @override
  String get libraryNoteLabel => 'Personal note';

  @override
  String get libraryRemoveTitle => 'Remove saved content?';

  @override
  String get libraryRemoveMessage =>
      'This removes the note, status, and collection assignment.';

  @override
  String get libraryRemoveAction => 'Remove';

  @override
  String get libraryCancel => 'Cancel';

  @override
  String get librarySaveChanges => 'Save';

  @override
  String get libraryMutationError =>
      'The change could not be saved. Try again.';

  @override
  String get libraryNoCollections => 'No collections yet.';

  @override
  String libraryCollectionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
      zero: 'No items',
    );
    return '$_temp0';
  }

  @override
  String get libraryRenameCollection => 'Rename collection';

  @override
  String get libraryDeleteCollection => 'Delete collection';

  @override
  String get libraryDeleteCollectionMessage =>
      'Saved content will remain in the library without a collection.';

  @override
  String get libraryCreateCollection => 'New collection';

  @override
  String get libraryDone => 'Done';

  @override
  String get libraryCollectionName => 'Collection name';

  @override
  String get libraryConfirm => 'Confirm';

  @override
  String get libraryNoNote => 'No note';
}
