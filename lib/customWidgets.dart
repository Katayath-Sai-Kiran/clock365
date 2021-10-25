import 'package:clock365/models/OrganizationModel.dart';
import 'package:clock365/constants.dart';
import 'package:clock365/models/clock_user.dart';
import 'package:clock365/screens/dashboard/visitor_confirm_screen.dart';
import 'package:clock365/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CustomWidgets {
  Future successToste(
      {required String text, required BuildContext context}) async {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.0),
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

  ScaffoldFeatureController snacbarWithTwoButtons2({
    required BuildContext context,
    required Function() secondaryCallback,
    required String primatyText,
    required String secondaryText,
    required String titleText,
    required OrganizationModel? selectedOrganization,
    required ClockUser currentUser,
  }) {
    final double _height = Get.height;
    final double _width = Get.width;
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        elevation: 8.0,
        behavior: SnackBarBehavior.floating,
        content: Container(
          height: 100,
          width: _width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                titleText,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: _width * 0.3,
                    height: _height * 0.05,
                    child: OutlinedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        side: MaterialStateProperty.all(BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                        )),
                      ),
                      onPressed: secondaryCallback,
                      child: Text(
                        secondaryText,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ),
                  Container(
                    width: _width * 0.3,
                    height: _height * 0.05,
                    child: OutlinedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.primary),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        List<ClockUser>? selectedOrganizationStaff =
                            selectedOrganization!.staff;

                        bool _canSignIn = false;
                        selectedOrganizationStaff?.forEach((element) {
                          if (element.id == currentUser.id) {
                            _canSignIn = true;
                          }
                        });
                        if (_canSignIn) {
                          Navigator.of(context).pushNamed(
                            kUserConfirmSignInScreen,
                            arguments: selectedOrganization,
                          );
                        } else {
                          failureToste(
                              text:
                                  "You are not registered with ${selectedOrganization.organizationName}",
                              context: context);
                        }
                      },
                      child: Text(
                        primatyText,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        margin: EdgeInsets.all(16.0),
      ),
    );
  }

  ScaffoldFeatureController snacbarWithTwoButtons3({
    required BuildContext context,
    required Function() secondaryCallback,
    required String primatyText,
    required String secondaryText,
    required String titleText,
    required OrganizationModel? selectedOrganization,
    required ClockUser currentUser,
  }) {
    final double _height = Get.height;
    final double _width = Get.width;
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        elevation: 8.0,
        behavior: SnackBarBehavior.floating,
        content: Container(
          height: 100,
          width: _width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                titleText,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: _width * 0.3,
                    height: _height * 0.05,
                    child: OutlinedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        side: MaterialStateProperty.all(BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                        )),
                      ),
                      onPressed: secondaryCallback,
                      child: Text(
                        secondaryText,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ),
                  Container(
                    width: _width * 0.3,
                    height: _height * 0.05,
                    child: OutlinedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.primary),
                      ),
                      onPressed: () {
                        Get.to(() => VisitorSignInConfirm(
                              selectedOrganization: selectedOrganization,
                            ));
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      },
                      child: Text(
                        primatyText,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        margin: EdgeInsets.all(16.0),
      ),
    );
  }
}
