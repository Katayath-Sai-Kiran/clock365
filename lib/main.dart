import 'package:clock365/constants.dart';
import 'package:clock365/models/OrganizationModel.dart';
import 'package:clock365/models/clock_user.dart';
import 'package:clock365/models/organization.dart';
import 'package:clock365/onboarding/intro_logo.dart';
import 'package:clock365/providers/organization_provider.dart';
import 'package:clock365/providers/user_provider.dart';
import 'package:clock365/repository/userRepository.dart';
import 'package:clock365/route_generator.dart';
import 'package:clock365/screens/dashboard/user_dashboard.dart';
import 'package:clock365/screens/login/login_screen.dart';
import 'package:clock365/screens/main/main_screen.dart';
import 'package:clock365/screens/profile/staff_profile.dart';

import 'package:clock365/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'generated/l10n.dart';
import 'repository/organization_repository.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ClockUserAdapter());
  Hive.registerAdapter(OrganizationAdapter());
  Hive.registerAdapter(OrganizationModelAdapter());

  await Hive.openBox<dynamic>(kUserBox);

  runApp(Clock365App());
}

class Clock365App extends StatefulWidget {
  const Clock365App({Key? key}) : super(key: key);

  @override
  _Clock365AppState createState() => _Clock365AppState();
}

class _Clock365AppState extends State<Clock365App> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double colorIntensity = 1.0;
    String colorCode = "0xFF6756D8";
    int signInType = 3;

    Map themeData = {
      "primaryColor": colorCode,
      "colorIntensity": colorIntensity,
    };

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ClockUserProvider()),
        ChangeNotifierProvider(create: (context) => UserRepository()),
        ChangeNotifierProvider(create: (context) => OrganizationRepository()),
        ChangeNotifierProvider(create: (context) => OrganizationProvider()),
      ],
      child: ValueListenableBuilder(
        valueListenable: Hive.box<dynamic>(kUserBox).listenable(),
        builder: (context, Box box, child) {
          bool? _isLoggedIn = box.get("isLoggedIn") ?? false;
          bool? _isFirstTime;

          if (_isLoggedIn == true) {
            //user is already logged in
            ClockUser? loggedInUser = box.get(kCurrentUserKey);
            signInType = box.get(kSignInType);
            OrganizationModel? currentOrganization =
                loggedInUser!.currentOrganization;

            themeData = {
              "colorIntensity": currentOrganization?.colorOpacity,
              "primaryColor": currentOrganization?.colorCode,
            };
          } else {
            ClockUser? loggedInUser = box.get(kCurrentUserKey);
            if (loggedInUser != null) {
              OrganizationModel? currentOrganization =
                  loggedInUser.currentOrganization;
              themeData = {
                "colorIntensity": currentOrganization?.colorOpacity,
                "primaryColor": currentOrganization?.colorCode,
              };
            } else {
              _isFirstTime = box.get("isFirstTime") ?? true;
            }
          }

          // ClockUser currentUser = box.get(kCurrentUserKey);
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            onGenerateRoute: RouteGenerator.generateRoutes,
            supportedLocales: S.delegate.supportedLocales,
            theme: Clock365Theme.getThemeData(
              ThemeData.light(),
              intensity: themeData["colorIntensity"] ?? 1.0,
              pColor: Color(
                int.parse(themeData["primaryColor"] ?? colorCode),
              ),
            ),
            home: _isFirstTime == true
                ? IntroLogo()
                : _isLoggedIn == true
                    ? signInType == 1
                        ? StaffProfile()
                        : signInType == 2
                            ? UserDashboard()
                            : MainScreen()
                    : LoginScreen(),
          );
        },
      ),
    );
  }
}
