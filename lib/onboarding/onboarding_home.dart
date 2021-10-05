import 'package:clock365/constants.dart';
import 'package:clock365/onboarding/intro1.dart';
import 'package:clock365/onboarding/intro2.dart';
import 'package:clock365/onboarding/intro3.dart';
import 'package:clock365/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';


class OnboardHome extends StatefulWidget {
  const OnboardHome({Key? key}) : super(key: key);

  @override
  State<OnboardHome> createState() => _OnboardHomeState();
}

class _OnboardHomeState extends State<OnboardHome> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final double _height = Get.height;
    final double _width = Get.width;
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            children: [
              IntroOne(),
              IntroTwo(),
              IntroThree(),
            ],
            index: _selectedIndex,
          ),
          Positioned(
              bottom: _height * 0.05,
              left: _width * 0.4, //bottom: 100,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 0;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.circle,
                        size: 12.0,
                        color: _selectedIndex == 0
                            ? Color(0xff6756D8)
                            : Colors.grey,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 1;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.circle,
                        size: 12.0,
                        color: _selectedIndex == 1
                            ? Color(0xff6756D8)
                            : Colors.grey,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 2;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.circle,
                        size: 12.0,
                        color: _selectedIndex == 2
                            ? Color(0xff6756D8)
                            : Colors.grey,
                      ),
                    ),
                  ),
                ],
              )),
          Positioned(
              bottom: _height * 0.04,
              right: _width * 0.03,
              child: InkWell(
                onTap: () {
                  if (_selectedIndex != 2) {
                    setState(() {
                      _selectedIndex++;
                    });
                  } else {
                    Hive.box(kUserBox).put("isFirstTime", false);
                    Get.offAll(() => LoginScreen());
                  }
                },
                child: CircleAvatar(
                  backgroundColor: Color(0xff6756D8),
                  child: Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.white,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
