import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'carrot_localizations_en.dart';
import 'carrot_localizations_nl.dart';

/// Callers can lookup localized strings with an instance of CarrotLocalizations
/// returned by `CarrotLocalizations.of(context)`.
///
/// Applications need to include `CarrotLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/carrot_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: CarrotLocalizations.localizationsDelegates,
///   supportedLocales: CarrotLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the CarrotLocalizations.supportedLocales
/// property.
abstract class CarrotLocalizations {
  CarrotLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static CarrotLocalizations? of(BuildContext context) {
    return Localizations.of<CarrotLocalizations>(context, CarrotLocalizations);
  }

  static const LocalizationsDelegate<CarrotLocalizations> delegate = _CarrotLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('nl'),
  ];

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @datePickerDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick a date'**
  String get datePickerDialogTitle;

  /// No description provided for @drawerClose.
  ///
  /// In en, this message translates to:
  /// **'Close side menu'**
  String get drawerClose;

  /// No description provided for @editorCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get editorCopy;

  /// No description provided for @editorCut.
  ///
  /// In en, this message translates to:
  /// **'Cut'**
  String get editorCut;

  /// No description provided for @editorPaste.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get editorPaste;

  /// No description provided for @editorSelectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get editorSelectAll;

  /// No description provided for @formOptional.
  ///
  /// In en, this message translates to:
  /// **'(optional)'**
  String get formOptional;
}

class _CarrotLocalizationsDelegate extends LocalizationsDelegate<CarrotLocalizations> {
  const _CarrotLocalizationsDelegate();

  @override
  Future<CarrotLocalizations> load(Locale locale) {
    return SynchronousFuture<CarrotLocalizations>(lookupCarrotLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'nl'].contains(locale.languageCode);

  @override
  bool shouldReload(_CarrotLocalizationsDelegate old) => false;
}

CarrotLocalizations lookupCarrotLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return CarrotLocalizationsEn();
    case 'nl':
      return CarrotLocalizationsNl();
  }

  throw FlutterError('CarrotLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
