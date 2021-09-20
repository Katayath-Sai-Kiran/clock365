import 'package:clock365/models/clock_user.dart';
import 'package:clock365/models/organization.dart';
import 'package:clock365/providers/clock_user_provider.dart';
import 'package:clock365/repository/userRepository.dart';
import 'package:clock365/route_generator.dart';
import 'package:clock365/screens/location/location_customization.dart';
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
  await Hive.openBox<bool>("AuthModelBox");
  await Hive.openBox<dynamic>("themeBox");
  await Hive.openBox<ClockUser>("clockUserBox");
  await Hive.openBox<Map>("users");

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ClockUserProvider()),
        ChangeNotifierProvider(create: (context) => UserRepository()),
        ChangeNotifierProvider(create: (context) => OrganizationRepository()),
      ],
      child: ValueListenableBuilder(
          valueListenable: Hive.box("themeBox").listenable(),
          builder: (context, Box box, child) {
            String color = box.get("primaryColor") ?? "0xFF6756D8";
            double intensity = box.get("colorIntensity") ?? 1.0;
            Color primaryColor = Color(int.parse(color));

            return Consumer<ClockUserProvider>(
              builder: (context, ClockUserProvider accountProvider, child) =>
                  MaterialApp(
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
                  intensity: intensity,
                  pColor: primaryColor,
                ),
                home: FutureBuilder(
                  future: getCredentials(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    final bool isLoggedIn = snapshot.data["isLoggedIn"];
                    final bool isOrgRegistered =
                        snapshot.data["isOrgRegistered"];
                    return isLoggedIn && isOrgRegistered
                        ? MainScreen()
                        : isLoggedIn
                            ? LocationCustomizationScreen()
                            : LoginScreen();
                  },
                ),
              ),
            );
          }),
    );
  }

  Future getCredentials() async {
    Box authModelBox = await Hive.openBox<bool>("AuthModelBox");
    final bool isLoggedIn = authModelBox.get("isLoggedIn") ?? false;
    final bool isOrgRegistered = authModelBox.get("isOrgRegistered") ?? false;
    return {
      "isLoggedIn": isLoggedIn,
      "isOrgRegistered": isOrgRegistered,
    };
  }
}
