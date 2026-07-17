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
