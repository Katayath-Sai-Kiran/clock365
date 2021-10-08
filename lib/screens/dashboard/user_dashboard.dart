import 'package:clock365/constants.dart';
import 'package:clock365/customWidgets.dart';
import 'package:clock365/models/clock_user.dart';
import 'package:clock365/screens/qrTest.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserDashboard extends StatelessWidget {
  UserDashboard({Key? key}) : super(key: key);
  final CustomWidgets _customWidgets = CustomWidgets();

  @override
  Widget build(BuildContext context) {
    final ClockUser clockUser = Hive.box(kUserBox).get(kCurrentUserKey);
    final double _height = Get.height;
    final String signIntype =
        Hive.box(kUserBox).get(kSignInType) == 1 ? "staff" : "visitor";
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: _height * 0.05,
              ),
              Center(
                child: Image.asset(
                  "assets/sample_capture.png",
                  height: _height * 0.25,
                ),
              ),
              SizedBox(
                height: _height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    clockUser.name.toString(),
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Text(
                     " ($signIntype)",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontSize: 14.0,
                        ),
                  ),
                ],
              ),
              Text(
                clockUser.email.toString(),
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  clockUser.website.toString(),
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                ),
              ),
              SizedBox(
                height: _height * 0.3,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).colorScheme.primary),
                ),
                onPressed: () {
                  Get.to(() => QRViewExample());
                },
                child: Text("SCAN QR"),
              ),
              SizedBox(
                height: _height * 0.02,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).colorScheme.primary),
                ),
                onPressed: () {
                  _customWidgets.snacbarWithTwoButtons(context: context);
                },
                child: Text("SIGN OUT"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
