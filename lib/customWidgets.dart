import 'package:clock365/constants.dart';
import 'package:clock365/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CustomWidgets {
  Future successToste(
      {required String text, required BuildContext context}) async {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.done, color: Colors.green),
            SizedBox(width: 16.0),
            Flexible(
              child: Text(text),
            ),
          ],
        ),
      ),
    );
  }

  Future failureToste(
      {required String text, required BuildContext context}) async {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.0),
        content: Row(
          children: [
            Icon(Icons.warning_amber_outlined, color: Colors.orange),
            SizedBox(width: 16.0),
            Flexible(
              child: Text(text),
            ),
          ],
        ),
      ),
    );
  }

  ScaffoldFeatureController snacbarWithTwoButtons(
      {required BuildContext context}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        elevation: 8.0,
        backgroundColor: Colors.white,
        content: Container(
          height: Get.height * 0.15,
          width: Get.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Are you sure you want lo logout",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton(
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(
                        BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                    child: Text(
                      "Cancle",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  OutlinedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.primary),
                    ),
                    onPressed: () async {
                      await Hive.box(kUserBox).put("isLoggedIn", false);
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();

                      Get.offAll(() => LoginScreen());
                    },
                    child: Text("Logout"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
