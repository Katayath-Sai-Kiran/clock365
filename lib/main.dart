import 'package:clock365/constants.dart';
import 'package:clock365/models/clock_user.dart';
import 'package:clock365/models/organization.dart';
import 'package:clock365/providers/organization_provider.dart';
import 'package:clock365/providers/user_provider.dart';
import 'package:clock365/repository/userRepository.dart';
import 'package:clock365/route_generator.dart';
import 'package:clock365/screens/login/login_screen.dart';
import 'package:clock365/screens/main/main_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'generated/l10n.dart';
import 'package:clock365/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'repository/organization_repository.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(ClockUserAdapter());
  Hive.registerAdapter(OrganizationAdapter());

  await Hive.openBox<ClockUser>(kClockUserBox);
  await Hive.openBox(kUserIdBuffer);
  await Hive.openBox<dynamic>("users");
  await Hive.openBox<ClockUser>(kClockUserBox);

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
    bool? isLoggedIn = false;

    List? organizations = [];

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
          String? currentUserId = box.get(kcurrentUserId);

          if (currentUserId != null) {
            final Map userData = box.get(currentUserId);
            final Map currentOrganization = userData["currentOrganization"];
          
            ClockUser user = userData["currentUser"];
            organizations = user.organizations ?? [];
            themeData = {
              "primaryColor": currentOrganization["color_code"],
              "colorIntensity": currentOrganization["color_opacity"],
            };
            isLoggedIn = userData["loginDetails"]["isLoggedIn"] ?? false;
          }

          return MaterialApp(
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
            home: currentUserId == null
                ? LoginScreen()
                : isLoggedIn == true && organizations!.length > 0
                    ? MainScreen()
                    : LoginScreen(),
          );
        },
      ),
    );
  }
}
