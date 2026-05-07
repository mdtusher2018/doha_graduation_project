import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('ar'),
    Locale('en'),
  ];

  /// App title
  ///
  /// In en, this message translates to:
  /// **'Doha Institute Graduation'**
  String get appTitle;

  /// Role selection screen title
  ///
  /// In en, this message translates to:
  /// **'Choose Your Role'**
  String get chooseYourRole;

  /// Role selection screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Select how you want to use the platform'**
  String get selectRoleSubtitle;

  /// Student role
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get student;

  /// Faculty role
  ///
  /// In en, this message translates to:
  /// **'Faculty'**
  String get faculty;

  /// Staff role
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get staff;

  /// Student or Faculty label
  ///
  /// In en, this message translates to:
  /// **'Student/Faculty'**
  String get studentFaculty;

  /// Admin access label
  ///
  /// In en, this message translates to:
  /// **'Administrative access'**
  String get administrativeAccess;

  /// Role selection description
  ///
  /// In en, this message translates to:
  /// **'Easily access your academic or faculty dashboard'**
  String get easilyAccessDashboard;

  /// Role selection validation
  ///
  /// In en, this message translates to:
  /// **'Please select your role'**
  String get pleaseSelectRole;

  /// Continue button label
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// Sign in button/title
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// Create account button/title
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// Create new account title
  ///
  /// In en, this message translates to:
  /// **'Create New Account'**
  String get createNewAccount;

  /// Already registered label
  ///
  /// In en, this message translates to:
  /// **'Already Registered'**
  String get alreadyRegistered;

  /// Sign in subtitle
  ///
  /// In en, this message translates to:
  /// **'Access your graduation dashboard'**
  String get accessGraduationDashboard;

  /// Email label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Email hint text
  ///
  /// In en, this message translates to:
  /// **'ahmed@university.edu'**
  String get emailHint;

  /// Email helper text
  ///
  /// In en, this message translates to:
  /// **'✦  Only approved university emails accepted'**
  String get emailHelperText;

  /// Mobile number label
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get mobile;

  /// Mobile hint text
  ///
  /// In en, this message translates to:
  /// **'+974 5555 1234'**
  String get mobileHint;

  /// Photo upload label
  ///
  /// In en, this message translates to:
  /// **'Upload your photo'**
  String get uploadPhoto;

  /// Continue to verify button
  ///
  /// In en, this message translates to:
  /// **'Continue to Verify'**
  String get continueToVerify;

  /// Verify email screen title
  ///
  /// In en, this message translates to:
  /// **'Check Your Email'**
  String get checkYourEmail;

  /// OTP sent message
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a 6-digit code to'**
  String get weSentCodeTo;

  /// Verify and continue button
  ///
  /// In en, this message translates to:
  /// **'Verify & Continue'**
  String get verifyAndContinue;

  /// Resend OTP button
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// OTP countdown prefix
  ///
  /// In en, this message translates to:
  /// **'Code expires in  '**
  String get codeExpiresIn;

  /// Important instructions label
  ///
  /// In en, this message translates to:
  /// **'Important Instructions'**
  String get importantInstructions;

  /// Email not approved title
  ///
  /// In en, this message translates to:
  /// **'Email not approved'**
  String get emailNotApproved;

  /// Email not approved message
  ///
  /// In en, this message translates to:
  /// **'Your email is not in the approved list.\nPlease contact the administration.'**
  String get emailNotApprovedMessage;

  /// Welcome message
  ///
  /// In en, this message translates to:
  /// **'Welcome {name}'**
  String welcomeUser(String name);

  /// QR code section title
  ///
  /// In en, this message translates to:
  /// **'Your QR Code'**
  String get yourQrCode;

  /// QR code instructions
  ///
  /// In en, this message translates to:
  /// **'Show this QR code at the venue entrance for instant check-in'**
  String get showQrAtEntrance;

  /// Seat assignment title
  ///
  /// In en, this message translates to:
  /// **'Your Seat Assignment'**
  String get yourSeatAssignment;

  /// Seat label
  ///
  /// In en, this message translates to:
  /// **'Seat'**
  String get seat;

  /// Section label
  ///
  /// In en, this message translates to:
  /// **'Section'**
  String get section;

  /// Name label
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Phone number label
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// What's included section title
  ///
  /// In en, this message translates to:
  /// **'What\'s Included'**
  String get whatsIncluded;

  /// Event details title
  ///
  /// In en, this message translates to:
  /// **'Event Details'**
  String get eventDetails;

  /// Edit profile button
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// Save changes button
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Logout button
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Done button
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// Success message title
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// Profile update success message
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccessfully;

  /// Scan QR code button/title
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scanQrCode;

  /// QR scanner instruction
  ///
  /// In en, this message translates to:
  /// **'Align QR code within frame to scan'**
  String get alignQrCode;

  /// Scan again button
  ///
  /// In en, this message translates to:
  /// **'Scan Again'**
  String get scanAgain;

  /// Invalid QR error title
  ///
  /// In en, this message translates to:
  /// **'Invalid QR Code'**
  String get invalidQrCode;

  /// No valid QR data message
  ///
  /// In en, this message translates to:
  /// **'No valid QR data found.'**
  String get noValidQrData;

  /// Validation error title
  ///
  /// In en, this message translates to:
  /// **'Validation Error'**
  String get validationError;

  /// Open in maps button
  ///
  /// In en, this message translates to:
  /// **'Open in Maps'**
  String get openInMaps;

  /// Select role dropdown hint
  ///
  /// In en, this message translates to:
  /// **'Select your role'**
  String get selectYourRole;

  /// Section validation message
  ///
  /// In en, this message translates to:
  /// **'Please select your section'**
  String get pleaseSelectSection;

  /// Password field hint
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// Don't have account label
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// Not applicable
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get na;

  /// No description provided for @closeButton.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeButton;

  /// Confirmed status label
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmed;

  /// Announcements section title
  ///
  /// In en, this message translates to:
  /// **'Announcements'**
  String get announcements;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
