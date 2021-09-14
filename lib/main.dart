import 'package:clock365/route_generator.dart';
import 'package:clock365/screens/login/login_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';
import 'package:clock365/theme/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(Clock365App());
}

class Clock365App extends StatefulWidget {
  const Clock365App({Key? key}) : super(key: key);

  @override
  _Clock365AppState createState() => _Clock365AppState();
}

class _Clock365AppState extends State<Clock365App> {
  @override
  Widget build(BuildContext context) {
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
      theme: Clock365Theme.getThemeData(ThemeData.light()),
      home: LoginScreen(),
    );
  }
}
