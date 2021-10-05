import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class IntroThree extends StatelessWidget {
  const IntroThree({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _height = Get.height;
    final double _width = Get.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: _height * 0.1,
            ),
            Container(
              height: _height * 0.4,
              child: Center(
                child: SvgPicture.asset(
                  "assets/onboard3.svg",
                  height: _height * 0.45,
                  width: _width * 0.6,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: _height * 0.075,
                  ),
                  Text(
                    "Construction \nIndustry",
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: Colors.black87,
                        ),
                  ),
                  SizedBox(height: _height * 0.04),
                  Text(
                    "Extra features for sites with time frames and labour budgets ",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Colors.black54,
                        ),
                  ),
                  SizedBox(height: _height * 0.03),
                  Container(
                    width: _width * 0.65,
                    height: 16.0,
                    color: Color(0xff6756D8),
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: _width * 0.25,
                      height: 16.0,
                      color: Color(0xffFBB03B),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
