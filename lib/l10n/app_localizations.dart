import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('pt'),
    Locale('pt', 'BR'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'FrameLab'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get navExplore;

  /// No description provided for @navIdeas.
  ///
  /// In en, this message translates to:
  /// **'Ideas'**
  String get navIdeas;

  /// No description provided for @navLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get navLibrary;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @homePlaceholderTitle.
  ///
  /// In en, this message translates to:
  /// **'Your photography space is taking shape'**
  String get homePlaceholderTitle;

  /// No description provided for @homePlaceholderDescription.
  ///
  /// In en, this message translates to:
  /// **'The Home experience will arrive in a future update.'**
  String get homePlaceholderDescription;

  /// No description provided for @explorePlaceholderTitle.
  ///
  /// In en, this message translates to:
  /// **'Explore is coming soon'**
  String get explorePlaceholderTitle;

  /// No description provided for @explorePlaceholderDescription.
  ///
  /// In en, this message translates to:
  /// **'Discoverable photography content will appear here.'**
  String get explorePlaceholderDescription;

  /// No description provided for @ideasPlaceholderTitle.
  ///
  /// In en, this message translates to:
  /// **'Ideas are coming soon'**
  String get ideasPlaceholderTitle;

  /// No description provided for @ideasPlaceholderDescription.
  ///
  /// In en, this message translates to:
  /// **'Personalized photo prompts will appear here.'**
  String get ideasPlaceholderDescription;

  /// No description provided for @libraryPlaceholderTitle.
  ///
  /// In en, this message translates to:
  /// **'Your library is coming soon'**
  String get libraryPlaceholderTitle;

  /// No description provided for @libraryPlaceholderDescription.
  ///
  /// In en, this message translates to:
  /// **'Saved inspiration and notes will appear here.'**
  String get libraryPlaceholderDescription;

  /// No description provided for @profilePlaceholderTitle.
  ///
  /// In en, this message translates to:
  /// **'Your profile is coming soon'**
  String get profilePlaceholderTitle;

  /// No description provided for @profilePlaceholderDescription.
  ///
  /// In en, this message translates to:
  /// **'Your preferences and photography journey will appear here.'**
  String get profilePlaceholderDescription;

  /// No description provided for @navigationLabel.
  ///
  /// In en, this message translates to:
  /// **'Main navigation'**
  String get navigationLabel;

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Set up your photography profile'**
  String get onboardingTitle;

  /// No description provided for @onboardingDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose preferences you can change any time.'**
  String get onboardingDescription;

  /// No description provided for @onboardingContinue.
  ///
  /// In en, this message translates to:
  /// **'Save preferences'**
  String get onboardingContinue;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Your profile'**
  String get profileTitle;

  /// No description provided for @profileDescription.
  ///
  /// In en, this message translates to:
  /// **'These preferences shape future suggestions.'**
  String get profileDescription;

  /// No description provided for @profileSave.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get profileSave;

  /// No description provided for @profileSkillLevel.
  ///
  /// In en, this message translates to:
  /// **'Experience level'**
  String get profileSkillLevel;

  /// No description provided for @skillBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get skillBeginner;

  /// No description provided for @skillIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get skillIntermediate;

  /// No description provided for @skillAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get skillAdvanced;

  /// No description provided for @profileTopics.
  ///
  /// In en, this message translates to:
  /// **'Photography interests'**
  String get profileTopics;

  /// No description provided for @topicPortrait.
  ///
  /// In en, this message translates to:
  /// **'Portrait'**
  String get topicPortrait;

  /// No description provided for @topicLandscape.
  ///
  /// In en, this message translates to:
  /// **'Landscape'**
  String get topicLandscape;

  /// No description provided for @topicStreet.
  ///
  /// In en, this message translates to:
  /// **'Street'**
  String get topicStreet;

  /// No description provided for @topicMacro.
  ///
  /// In en, this message translates to:
  /// **'Macro'**
  String get topicMacro;

  /// No description provided for @topicNight.
  ///
  /// In en, this message translates to:
  /// **'Night photography'**
  String get topicNight;

  /// No description provided for @topicSmartphone.
  ///
  /// In en, this message translates to:
  /// **'Smartphone'**
  String get topicSmartphone;

  /// No description provided for @profileLearningGoals.
  ///
  /// In en, this message translates to:
  /// **'Learning goals'**
  String get profileLearningGoals;

  /// No description provided for @goalComposition.
  ///
  /// In en, this message translates to:
  /// **'Composition'**
  String get goalComposition;

  /// No description provided for @goalLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get goalLight;

  /// No description provided for @goalTechnique.
  ///
  /// In en, this message translates to:
  /// **'Camera technique'**
  String get goalTechnique;

  /// No description provided for @goalEditing.
  ///
  /// In en, this message translates to:
  /// **'Editing'**
  String get goalEditing;

  /// No description provided for @profileLanguage.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get profileLanguage;

  /// No description provided for @languageDevice.
  ///
  /// In en, this message translates to:
  /// **'Use device language'**
  String get languageDevice;

  /// No description provided for @languageManual.
  ///
  /// In en, this message translates to:
  /// **'Choose a language'**
  String get languageManual;

  /// No description provided for @languageSelectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSelectionLabel;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageItalian.
  ///
  /// In en, this message translates to:
  /// **'Italian'**
  String get languageItalian;

  /// No description provided for @languageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get languageSpanish;

  /// No description provided for @languageFrench.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get languageFrench;

  /// No description provided for @languageGerman.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get languageGerman;

  /// No description provided for @languageBrazilianPortuguese.
  ///
  /// In en, this message translates to:
  /// **'Brazilian Portuguese'**
  String get languageBrazilianPortuguese;

  /// No description provided for @profileSaveError.
  ///
  /// In en, this message translates to:
  /// **'Your preferences could not be saved. Try again.'**
  String get profileSaveError;

  /// No description provided for @catalogTitle.
  ///
  /// In en, this message translates to:
  /// **'Explore catalog'**
  String get catalogTitle;

  /// No description provided for @catalogOfflineAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available offline'**
  String get catalogOfflineAvailable;

  /// No description provided for @catalogSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search techniques, tips and tags'**
  String get catalogSearchHint;

  /// No description provided for @catalogSearchSemantics.
  ///
  /// In en, this message translates to:
  /// **'Catalog search field'**
  String get catalogSearchSemantics;

  /// No description provided for @catalogSearchClear.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get catalogSearchClear;

  /// No description provided for @catalogFiltersTitle.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get catalogFiltersTitle;

  /// No description provided for @catalogFiltersButton.
  ///
  /// In en, this message translates to:
  /// **'Filters ({count})'**
  String catalogFiltersButton(int count);

  /// No description provided for @catalogApplyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get catalogApplyFilters;

  /// No description provided for @catalogCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get catalogCancel;

  /// No description provided for @catalogClearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get catalogClearFilters;

  /// No description provided for @catalogRemoveFilter.
  ///
  /// In en, this message translates to:
  /// **'Remove {label} filter'**
  String catalogRemoveFilter(String label);

  /// No description provided for @catalogType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get catalogType;

  /// No description provided for @catalogCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get catalogCategory;

  /// No description provided for @catalogDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get catalogDifficulty;

  /// No description provided for @catalogTag.
  ///
  /// In en, this message translates to:
  /// **'Tag'**
  String get catalogTag;

  /// No description provided for @catalogTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type: {value}'**
  String catalogTypeLabel(String value);

  /// No description provided for @catalogCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category: {value}'**
  String catalogCategoryLabel(String value);

  /// No description provided for @catalogDifficultyLabel.
  ///
  /// In en, this message translates to:
  /// **'Difficulty: {value}'**
  String catalogDifficultyLabel(String value);

  /// No description provided for @catalogPremiumLabel.
  ///
  /// In en, this message translates to:
  /// **'Premium: {value}'**
  String catalogPremiumLabel(String value);

  /// No description provided for @catalogTagLabel.
  ///
  /// In en, this message translates to:
  /// **'Tag: {value}'**
  String catalogTagLabel(String value);

  /// No description provided for @catalogPremium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get catalogPremium;

  /// No description provided for @catalogPremiumOnly.
  ///
  /// In en, this message translates to:
  /// **'Premium only'**
  String get catalogPremiumOnly;

  /// No description provided for @catalogFreeOnly.
  ///
  /// In en, this message translates to:
  /// **'Free only'**
  String get catalogFreeOnly;

  /// No description provided for @catalogLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading catalog'**
  String get catalogLoading;

  /// No description provided for @catalogLoadingMore.
  ///
  /// In en, this message translates to:
  /// **'Loading more'**
  String get catalogLoadingMore;

  /// No description provided for @catalogLoadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get catalogLoadMore;

  /// No description provided for @catalogRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get catalogRetry;

  /// No description provided for @catalogRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get catalogRefresh;

  /// No description provided for @catalogNextPageError.
  ///
  /// In en, this message translates to:
  /// **'The next page could not be loaded.'**
  String get catalogNextPageError;

  /// No description provided for @catalogEndOfResults.
  ///
  /// In en, this message translates to:
  /// **'End of results'**
  String get catalogEndOfResults;

  /// No description provided for @catalogEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No catalog items yet'**
  String get catalogEmptyTitle;

  /// No description provided for @catalogEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Install the local seed or try again.'**
  String get catalogEmptyDescription;

  /// No description provided for @catalogNoSearchResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'No search results'**
  String get catalogNoSearchResultsTitle;

  /// No description provided for @catalogNoSearchResultsDescription.
  ///
  /// In en, this message translates to:
  /// **'Try a different term or clear the search.'**
  String get catalogNoSearchResultsDescription;

  /// No description provided for @catalogNoFilterResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'No filtered results'**
  String get catalogNoFilterResultsTitle;

  /// No description provided for @catalogNoFilterResultsDescription.
  ///
  /// In en, this message translates to:
  /// **'Remove one or more filters to broaden the catalog.'**
  String get catalogNoFilterResultsDescription;

  /// No description provided for @catalogErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Catalog unavailable'**
  String get catalogErrorTitle;

  /// No description provided for @catalogErrorDescription.
  ///
  /// In en, this message translates to:
  /// **'The local catalog could not be loaded.'**
  String get catalogErrorDescription;

  /// No description provided for @catalogCardSemantics.
  ///
  /// In en, this message translates to:
  /// **'Open {title}'**
  String catalogCardSemantics(String title);

  /// No description provided for @catalogTypeTip.
  ///
  /// In en, this message translates to:
  /// **'Tip'**
  String get catalogTypeTip;

  /// No description provided for @catalogTypeTechnique.
  ///
  /// In en, this message translates to:
  /// **'Technique'**
  String get catalogTypeTechnique;

  /// No description provided for @catalogTypeCuriosity.
  ///
  /// In en, this message translates to:
  /// **'Curiosity'**
  String get catalogTypeCuriosity;

  /// No description provided for @catalogTypeIdea.
  ///
  /// In en, this message translates to:
  /// **'Idea'**
  String get catalogTypeIdea;

  /// No description provided for @catalogTypeCommonMistake.
  ///
  /// In en, this message translates to:
  /// **'Common mistake'**
  String get catalogTypeCommonMistake;

  /// No description provided for @catalogTypeGuide.
  ///
  /// In en, this message translates to:
  /// **'Guide'**
  String get catalogTypeGuide;

  /// No description provided for @catalogTypeChecklist.
  ///
  /// In en, this message translates to:
  /// **'Checklist'**
  String get catalogTypeChecklist;

  /// No description provided for @catalogTypeChallenge.
  ///
  /// In en, this message translates to:
  /// **'Challenge'**
  String get catalogTypeChallenge;

  /// No description provided for @catalogTypeGlossary.
  ///
  /// In en, this message translates to:
  /// **'Glossary'**
  String get catalogTypeGlossary;

  /// No description provided for @catalogTypeHistory.
  ///
  /// In en, this message translates to:
  /// **'Photo history'**
  String get catalogTypeHistory;

  /// No description provided for @catalogCategoryExposure.
  ///
  /// In en, this message translates to:
  /// **'Exposure'**
  String get catalogCategoryExposure;

  /// No description provided for @catalogCategoryPortrait.
  ///
  /// In en, this message translates to:
  /// **'Portrait'**
  String get catalogCategoryPortrait;

  /// No description provided for @catalogCategoryComposition.
  ///
  /// In en, this message translates to:
  /// **'Composition'**
  String get catalogCategoryComposition;

  /// No description provided for @catalogCategoryLowLight.
  ///
  /// In en, this message translates to:
  /// **'Low light'**
  String get catalogCategoryLowLight;

  /// No description provided for @catalogCategoryColor.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get catalogCategoryColor;

  /// No description provided for @catalogCategoryMotion.
  ///
  /// In en, this message translates to:
  /// **'Motion'**
  String get catalogCategoryMotion;

  /// No description provided for @catalogCategoryGear.
  ///
  /// In en, this message translates to:
  /// **'Gear'**
  String get catalogCategoryGear;

  /// No description provided for @catalogTagExposure.
  ///
  /// In en, this message translates to:
  /// **'Exposure'**
  String get catalogTagExposure;

  /// No description provided for @catalogTagLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get catalogTagLight;

  /// No description provided for @catalogTagComposition.
  ///
  /// In en, this message translates to:
  /// **'Composition'**
  String get catalogTagComposition;

  /// No description provided for @catalogTagStability.
  ///
  /// In en, this message translates to:
  /// **'Stability'**
  String get catalogTagStability;

  /// No description provided for @catalogTagColor.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get catalogTagColor;

  /// No description provided for @catalogTagFocus.
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get catalogTagFocus;

  /// No description provided for @catalogTagMetering.
  ///
  /// In en, this message translates to:
  /// **'Metering'**
  String get catalogTagMetering;

  /// No description provided for @catalogTagPractice.
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get catalogTagPractice;

  /// No description provided for @catalogTagMotion.
  ///
  /// In en, this message translates to:
  /// **'Motion'**
  String get catalogTagMotion;

  /// No description provided for @catalogTagMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get catalogTagMaintenance;

  /// No description provided for @catalogDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Content detail'**
  String get catalogDetailTitle;

  /// No description provided for @catalogDetailBack.
  ///
  /// In en, this message translates to:
  /// **'Back to catalog'**
  String get catalogDetailBack;

  /// No description provided for @catalogDetailLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading content'**
  String get catalogDetailLoading;

  /// No description provided for @catalogDetailUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Content unavailable'**
  String get catalogDetailUnavailableTitle;

  /// No description provided for @catalogDetailUnavailableDescription.
  ///
  /// In en, this message translates to:
  /// **'This content is not available offline or is not publishable.'**
  String get catalogDetailUnavailableDescription;

  /// No description provided for @catalogDetailErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Detail unavailable'**
  String get catalogDetailErrorTitle;

  /// No description provided for @catalogDetailErrorDescription.
  ///
  /// In en, this message translates to:
  /// **'Try reading this content again from the offline catalog.'**
  String get catalogDetailErrorDescription;

  /// No description provided for @catalogDetailOffline.
  ///
  /// In en, this message translates to:
  /// **'Available offline'**
  String get catalogDetailOffline;

  /// No description provided for @catalogDetailSources.
  ///
  /// In en, this message translates to:
  /// **'Sources'**
  String get catalogDetailSources;

  /// No description provided for @catalogDetailAttribution.
  ///
  /// In en, this message translates to:
  /// **'Attribution: {value}'**
  String catalogDetailAttribution(String value);

  /// No description provided for @catalogDetailLicense.
  ///
  /// In en, this message translates to:
  /// **'License: {value}'**
  String catalogDetailLicense(String value);

  /// No description provided for @catalogDetailRights.
  ///
  /// In en, this message translates to:
  /// **'Rights: {value}'**
  String catalogDetailRights(String value);

  /// No description provided for @catalogDetailRightsPublishable.
  ///
  /// In en, this message translates to:
  /// **'publishable'**
  String get catalogDetailRightsPublishable;

  /// No description provided for @catalogDetailRightsRestricted.
  ///
  /// In en, this message translates to:
  /// **'restricted'**
  String get catalogDetailRightsRestricted;

  /// No description provided for @catalogDetailRightsUnknown.
  ///
  /// In en, this message translates to:
  /// **'unknown'**
  String get catalogDetailRightsUnknown;

  /// No description provided for @profileEquipment.
  ///
  /// In en, this message translates to:
  /// **'Photography equipment'**
  String get profileEquipment;

  /// No description provided for @profileCameraBodies.
  ///
  /// In en, this message translates to:
  /// **'Camera bodies'**
  String get profileCameraBodies;

  /// No description provided for @profileLenses.
  ///
  /// In en, this message translates to:
  /// **'Lenses'**
  String get profileLenses;

  /// No description provided for @profileSmartphones.
  ///
  /// In en, this message translates to:
  /// **'Smartphones'**
  String get profileSmartphones;

  /// No description provided for @equipmentMirrorless.
  ///
  /// In en, this message translates to:
  /// **'Mirrorless camera'**
  String get equipmentMirrorless;

  /// No description provided for @equipmentDslr.
  ///
  /// In en, this message translates to:
  /// **'DSLR camera'**
  String get equipmentDslr;

  /// No description provided for @equipmentFilm.
  ///
  /// In en, this message translates to:
  /// **'Film camera'**
  String get equipmentFilm;

  /// No description provided for @equipmentPrimeLens.
  ///
  /// In en, this message translates to:
  /// **'Prime lens'**
  String get equipmentPrimeLens;

  /// No description provided for @equipmentZoomLens.
  ///
  /// In en, this message translates to:
  /// **'Zoom lens'**
  String get equipmentZoomLens;

  /// No description provided for @equipmentTelephotoLens.
  ///
  /// In en, this message translates to:
  /// **'Telephoto lens'**
  String get equipmentTelephotoLens;

  /// No description provided for @equipmentIPhone.
  ///
  /// In en, this message translates to:
  /// **'iPhone'**
  String get equipmentIPhone;

  /// No description provided for @equipmentAndroid.
  ///
  /// In en, this message translates to:
  /// **'Android phone'**
  String get equipmentAndroid;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Your photography, at your pace'**
  String get homeGreeting;

  /// No description provided for @homeLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading personalised suggestions'**
  String get homeLoading;

  /// No description provided for @homeError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get homeError;

  /// No description provided for @homeIncompleteProfile.
  ///
  /// In en, this message translates to:
  /// **'Complete your profile to refine these suggestions.'**
  String get homeIncompleteProfile;

  /// No description provided for @homeChosenForYou.
  ///
  /// In en, this message translates to:
  /// **'Chosen for you'**
  String get homeChosenForYou;

  /// No description provided for @homeImproveIdeas.
  ///
  /// In en, this message translates to:
  /// **'Ideas to improve'**
  String get homeImproveIdeas;

  /// No description provided for @homeForYourLevel.
  ///
  /// In en, this message translates to:
  /// **'Right for your level'**
  String get homeForYourLevel;

  /// No description provided for @homeOpenCatalog.
  ///
  /// In en, this message translates to:
  /// **'Open the full catalog'**
  String get homeOpenCatalog;

  /// No description provided for @homeEmptyCatalog.
  ///
  /// In en, this message translates to:
  /// **'The offline catalog is currently empty.'**
  String get homeEmptyCatalog;

  /// No description provided for @homeEditorialFallback.
  ///
  /// In en, this message translates to:
  /// **'A useful editorial selection for you'**
  String get homeEditorialFallback;

  /// No description provided for @homeReasonInterest.
  ///
  /// In en, this message translates to:
  /// **'Chosen for your photography interest'**
  String get homeReasonInterest;

  /// No description provided for @homeReasonGoal.
  ///
  /// In en, this message translates to:
  /// **'Can help you reach your learning goal'**
  String get homeReasonGoal;

  /// No description provided for @homeReasonLevel.
  ///
  /// In en, this message translates to:
  /// **'Right for your level'**
  String get homeReasonLevel;

  /// No description provided for @homeReasonEquipment.
  ///
  /// In en, this message translates to:
  /// **'Compatible with your equipment'**
  String get homeReasonEquipment;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'it',
    'pt',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
