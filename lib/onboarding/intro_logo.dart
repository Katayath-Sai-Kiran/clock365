import 'package:clock365/onboarding/onboarding_home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IntroLogo extends StatefulWidget {
  const IntroLogo({Key? key}) : super(key: key);

  @override
  State<IntroLogo> createState() => _IntroLogoState();
}

class _IntroLogoState extends State<IntroLogo> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3), () {
      Get.offAll(() => OnboardHome());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff6756D8),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Image.asset("assets/logo.png"),
        ),
      ),
    );
  }
}
