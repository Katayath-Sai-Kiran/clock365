// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Edit Staff`
  String get pageEditStaff {
    return Intl.message(
      'Edit Staff',
      name: 'pageEditStaff',
      desc: '',
      args: [],
    );
  }

  /// `Add new staff members`
  String get pageEditAddNewStaffMembers {
    return Intl.message(
      'Add new staff members',
      name: 'pageEditAddNewStaffMembers',
      desc: '',
      args: [],
    );
  }

  /// `Added members`
  String get pageEditAddedMembers {
    return Intl.message(
      'Added members',
      name: 'pageEditAddedMembers',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get actionContinue {
    return Intl.message(
      'Continue',
      name: 'actionContinue',
      desc: '',
      args: [],
    );
  }

  /// `Ready, Set, Go!`
  String get readySetGo {
    return Intl.message(
      'Ready, Set, Go!',
      name: 'readySetGo',
      desc: '',
      args: [],
    );
  }

  /// `Tips`
  String get tipsText {
    return Intl.message(
      'Tips',
      name: 'tipsText',
      desc: '',
      args: [],
    );
  }

  /// `1. Protect the Home button with PIN`
  String get protectHomeButtonWithPin {
    return Intl.message(
      '1. Protect the Home button with PIN',
      name: 'protectHomeButtonWithPin',
      desc: '',
      args: [],
    );
  }

  /// `2. Visit the Dashboard`
  String get visitTheDashboard {
    return Intl.message(
      '2. Visit the Dashboard',
      name: 'visitTheDashboard',
      desc: '',
      args: [],
    );
  }

  /// `3. Enclosure for iPads`
  String get enclosureForIpads {
    return Intl.message(
      '3. Enclosure for iPads',
      name: 'enclosureForIpads',
      desc: '',
      args: [],
    );
  }

  /// `Prevent Staff and Visitors exiting the app by enabling Guided access.`
  String get protectHomeButtonWithPinDesc {
    return Intl.message(
      'Prevent Staff and Visitors exiting the app by enabling Guided access.',
      name: 'protectHomeButtonWithPinDesc',
      desc: '',
      args: [],
    );
  }

  /// `Guided Access is currently`
  String get guidedAccessIsCurrently {
    return Intl.message(
      'Guided Access is currently',
      name: 'guidedAccessIsCurrently',
      desc: '',
      args: [],
    );
  }

  /// `This app is also available for iPads.\n\nEnclosures are a great way to secure iPads to counter-tops or walls\n\niPads enclosures are available online from a number of vendors`
  String get enclosureForIpadsDesc {
    return Intl.message(
      'This app is also available for iPads.\n\nEnclosures are a great way to secure iPads to counter-tops or walls\n\niPads enclosures are available online from a number of vendors',
      name: 'enclosureForIpadsDesc',
      desc: '',
      args: [],
    );
  }

  /// `Download\n• Time sheets\n• History\n• Reports & Charts.`
  String get visitTheDashboardDesc {
    return Intl.message(
      'Download\n• Time sheets\n• History\n• Reports & Charts.',
      name: 'visitTheDashboardDesc',
      desc: '',
      args: [],
    );
  }

  /// `Access the dashboard by pointing you at absclock.co.in and logging in.`
  String get visitTheDashboardDesc2 {
    return Intl.message(
      'Access the dashboard by pointing you at absclock.co.in and logging in.',
      name: 'visitTheDashboardDesc2',
      desc: '',
      args: [],
    );
  }

  /// `On Site at\n{siteName}`
  String onSiteAtX(Object siteName) {
    return Intl.message(
      'On Site at\n$siteName',
      name: 'onSiteAtX',
      desc: '',
      args: [siteName],
    );
  }

  /// `Touchless`
  String get touchless {
    return Intl.message(
      'Touchless',
      name: 'touchless',
      desc: '',
      args: [],
    );
  }

  /// `Dashboard`
  String get dashboardTitle {
    return Intl.message(
      'Dashboard',
      name: 'dashboardTitle',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get signIn {
    return Intl.message(
      'Sign In',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `Staff`
  String get staff {
    return Intl.message(
      'Staff',
      name: 'staff',
      desc: '',
      args: [],
    );
  }

  /// `{organization} Staff sign in`
  String xStaffSignIn(Object organization) {
    return Intl.message(
      '$organization Staff sign in',
      name: 'xStaffSignIn',
      desc: '',
      args: [organization],
    );
  }

  /// `Visitor`
  String get visitor {
    return Intl.message(
      'Visitor',
      name: 'visitor',
      desc: '',
      args: [],
    );
  }

  /// `Visitor from other companies`
  String get visitorFromOtherCompanies {
    return Intl.message(
      'Visitor from other companies',
      name: 'visitorFromOtherCompanies',
      desc: '',
      args: [],
    );
  }

  /// `Sign In Details`
  String get signInDetails {
    return Intl.message(
      'Sign In Details',
      name: 'signInDetails',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Sign In`
  String get confirmSignIn {
    return Intl.message(
      'Confirm Sign In',
      name: 'confirmSignIn',
      desc: '',
      args: [],
    );
  }

  /// `Your full name`
  String get yourFullName {
    return Intl.message(
      'Your full name',
      name: 'yourFullName',
      desc: '',
      args: [],
    );
  }

  /// `Your organization name`
  String get yourOrgName {
    return Intl.message(
      'Your organization name',
      name: 'yourOrgName',
      desc: '',
      args: [],
    );
  }

  /// `I consent to my information being used for attendance monitering`
  String get informationBeingUsedConsent {
    return Intl.message(
      'I consent to my information being used for attendance monitering',
      name: 'informationBeingUsedConsent',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get location {
    return Intl.message(
      'Location',
      name: 'location',
      desc: '',
      args: [],
    );
  }

  /// `Location Options`
  String get locationOptions {
    return Intl.message(
      'Location Options',
      name: 'locationOptions',
      desc: '',
      args: [],
    );
  }

  /// `At which site is this iPhone located?`
  String get atWhichSiteIsThisPhoneLocated {
    return Intl.message(
      'At which site is this iPhone located?',
      name: 'atWhichSiteIsThisPhoneLocated',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Your Sites`
  String get yourSites {
    return Intl.message(
      'Your Sites',
      name: 'yourSites',
      desc: '',
      args: [],
    );
  }

  /// `Modification`
  String get modification {
    return Intl.message(
      'Modification',
      name: 'modification',
      desc: '',
      args: [],
    );
  }

  /// `Buttons`
  String get buttons {
    return Intl.message(
      'Buttons',
      name: 'buttons',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Intensity`
  String get intensity {
    return Intl.message(
      'Intensity',
      name: 'intensity',
      desc: '',
      args: [],
    );
  }

  /// `Color code`
  String get colorCode {
    return Intl.message(
      'Color code',
      name: 'colorCode',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message(
      'Done',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `Color`
  String get color {
    return Intl.message(
      'Color',
      name: 'color',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
