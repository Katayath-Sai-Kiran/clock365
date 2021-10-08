// Hive types

import 'package:clock365/models/clock_user.dart';
import 'package:clock365/models/destination.dart';
import 'package:clock365/screens/dashboard/dashboard_screen.dart';
import 'package:clock365/screens/dashboard/org_sign_in.dart';
import 'package:clock365/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';

const int kOrgHiveType = 0;
const int kClockUserHiveType = 1;
const int kAuthModelType = 2;
const int kOrganizationModel = 3;

// Hive boxes
const String kClockUserBox = 'clock_user';
const String kOrganizationBox = 'organization';
const String kUserBox = "users";
const String kCurrentUserKey = "currentUser";
const String kUserIdBuffer = "USERIDBUFFER";
const String kcurrentUserId = "currentUserId";
const String kSignInType = "signInType";

// Hive box keys
const String kUserKey = 'clock_user.KEY';

// API
//const String kBaseUrl = 'https://clock365.wielabs.tech';
const String kBaseUrl = 'http://192.168.1.48:6001';

// Supported locales
const kSupportedLocales = <Locale>[
  Locale('en', ''),
  Locale('es', ''),
];

// Test
final List<ClockUser> kClockUsers = <ClockUser>[
  ClockUser(),
];

// Primary destinations
final allDestinations = <Destination>[
  Destination(
      id: 1,
      iconPath: 'assets/user_profile.svg',
      name: 'User Profile',
      child: ProfileScreen()),
  Destination(
      id: 2,
      iconPath: 'assets/dashboard.svg',
      name: 'Settings',
      child: DashboardScreen()),
  Destination(
      id: 3,
      iconPath: 'assets/sign_in_out.svg',
      name: 'Sign In/Out',
      child: OrganizationSignInScreen()),
];

// Routes
const String kLoginRoute = '/login';
const String kSignupRoute = '/signup';
const String kForgotPasswordRoute = '/forgotPassword';
const String kEditLocationRoute = '/editLocation';
const String kLocationRoute = '/location';
const String kLocationOptionsRoute = '/locationOptions';
const String kLocationModificationRoute = '/locationModification';
const String kEditStaffRoute = '/editStaff';
const String kReadySetGoScreen = '/readySetGo';
const String kSignupIntroduce = '/signupIntroduce';
const String kSignupPasswordRoute = '/signupPassword';
const String kDashboardRoute = '/dashboard';
const String kMainScreen = '/mainScreen';
const String kUserSignInDetailsScreen = '/userSignInDetails';
const String kVisitorSignInDetailsScreen = '/visitorSignInDetailsScreen';
const String kUserConfirmSignInScreen = '/userConfirmSignIn';
const String kCapturePhotoScreen = '/capturePhoto';
const String kProfileDetailRoute = '/profileDetail';
const String kScanQr = '/scanQr';
const String kUserDashboard = '/userDashboard';

// Colors
final allColors = <Color>[
  Color(0xFF6756D8),
  Color(0xFFFDBE00),
  Color(0xFF244F43),
  Color(0xFFFF6957),
];

//API endPoints
const String kGenerateOTPEndpoint =
    "$kBaseUrl/api/v1/send/code/verification"; // send otp

const String kResetOTPEndpoint =
    "$kBaseUrl/api/v1/send/code/reset"; // send otp in reset password screen

const String kVerifyGmailEndPoint =
    "$kBaseUrl/api/v1/verify/code"; // verify opt

const String kUserSignUpEndPoint = "$kBaseUrl/api/v1/signup"; //sign up user

const String kUserLoginEndPont = "$kBaseUrl/api/v1/login"; //login user

const String kUserOrganizationResisterEndpoint =
    "$kBaseUrl/api/v1/org"; //register new organization

const String kUserExistingOrganizationEndpoint =
    "$kBaseUrl/api/v1/user/add/org"; //add existing org to user

const String kAddnNewStaffEndPoint =
    "$kBaseUrl/api/v1/org/new/staff"; // add staff to organization

const String kRemoveStaffEndPoint =
    "$kBaseUrl/api/v1/org/remove/staff"; //remove staff from org

const String kstaffSignInEndPoint =
    "$kBaseUrl/api/v1/org/signin"; //staff and visitor sign into org from dashbord

const String kGetCurrentSitesEndPoint =
    "$kBaseUrl/api/v1/user/user_id/orgs"; //get current user registerd organizations

const String kGetStaffEndpoint =
    "$kBaseUrl/api/v1/org/org_id/staff"; //get current organization staff
const String kGetStaffSignedInEndpoint =
    "$kBaseUrl/api/v1/org/org_id/staff/active"; //get current organization signed in staff

const String kGetVisitorSignedInEndpoint =
    "$kBaseUrl/api/v1/org/org_id/visitors/active"; //get current organization signed in visitors

const String kUpdateOrganizationData =
    "$kBaseUrl/api/v1/org"; //update organization data like staffsign instatus

const String kGetScannedOrgDetailsEndPoint =
    "$kBaseUrl/api/v1/org/org_id"; //touch less sign response organizations

const String kResetUserPasswordEndpoint =
    "$kBaseUrl/api/v1/user/update/password"; // reset passsword of registered mail

const String kGetAttendenceDetailsEndPoint =
    "$kBaseUrl/api/v1/user/user_id/status?org_id=org_value"; //attendence details list

//userBox keys
