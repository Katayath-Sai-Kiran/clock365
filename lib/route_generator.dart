import 'package:clock365/constants.dart';
import 'package:clock365/screens/dashboard/capture_photo.dart';
import 'package:clock365/screens/dashboard/dashboard_screen.dart';
import 'package:clock365/screens/dashboard/user_confirm_sign_in.dart';
import 'package:clock365/screens/dashboard/user_sign_in_details.dart';
import 'package:clock365/screens/dashboard/visitor_sign_in_details_screen.dart';
import 'package:clock365/screens/forgot/forgot_password.dart';
import 'package:clock365/screens/landing/ready_set_go.dart';
import 'package:clock365/screens/location/edit_staff.dart';
import 'package:clock365/screens/location/location_customization.dart';
import 'package:clock365/screens/location/location_options.dart';
import 'package:clock365/screens/location/location_screen.dart';
import 'package:clock365/screens/login/login_screen.dart';
import 'package:clock365/screens/main/main_screen.dart';
import 'package:clock365/screens/profile/profile_detail.dart';
import 'package:clock365/screens/signup/signup_introduce.dart';
import 'package:clock365/screens/signup/signup_password.dart';
import 'package:clock365/screens/signup/signup_screen.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case kLoginRoute:
        return MaterialPageRoute(builder: (context) => LoginScreen());
      case kSignupRoute:
        return MaterialPageRoute(builder: (context) => SignupScreen());
      case kSignupIntroduce:
        return MaterialPageRoute(builder: (context) => SignupIntroduceScreen());
      case kSignupPasswordRoute:
        return MaterialPageRoute(
          builder: (context) => SignupPasswordScreen(),
          settings: settings,
        );
      case kForgotPasswordRoute:
        return MaterialPageRoute(builder: (context) => ForgotPasswordScreen());
      case kLocationModificationRoute:
        return MaterialPageRoute(
          builder: (context) => LocationCustomizationScreen(),
          settings: settings,
        );
      case kLocationOptionsRoute:
        return MaterialPageRoute(
          builder: (context) => LocationOptionsScreen(),
          settings: settings,
        );
      case kEditStaffRoute:
        return MaterialPageRoute(builder: (context) => EditStaffScreen());
      case kLocationRoute:
        return MaterialPageRoute(builder: (context) => LocationScreen());
      case kReadySetGoScreen:
        return MaterialPageRoute(builder: (context) => ReadySetGoScreen());
      case kMainScreen:
        return MaterialPageRoute(builder: (context) => MainScreen());
      case kUserSignInDetailsScreen:
        return MaterialPageRoute(builder: (context) => UserSignInScreen());
      case kVisitorSignInDetailsScreen:
        return MaterialPageRoute(
            builder: (context) => VisitorSignInDetailsScreen());
      case kUserConfirmSignInScreen:
        return MaterialPageRoute(
            builder: (context) => UserConfirmSignInScreen());
      case kCapturePhotoScreen:
        return MaterialPageRoute(builder: (context) => CapturePhotoScreen());
      case kDashboardRoute:
        return MaterialPageRoute(builder: (context) => DashboardScreen());
      case kProfileDetailRoute:
        return MaterialPageRoute(builder: (context) => ProfileDetailScreen());
      default:
        throw Exception('Unknown route ${settings.name}');
    }
  }
}
