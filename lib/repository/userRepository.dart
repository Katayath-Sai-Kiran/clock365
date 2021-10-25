import 'dart:convert';
import 'dart:io';

import 'package:clock365/constants.dart';
import 'package:clock365/customWidgets.dart';
import 'package:clock365/models/OrganizationModel.dart';
import 'package:clock365/models/clock_user.dart';
import 'package:clock365/providers/organization_provider.dart';
import 'package:clock365/providers/user_provider.dart';
import 'package:clock365/screens/dashboard/user_dashboard.dart';
import 'package:clock365/screens/profile/staff_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class UserRepository extends ChangeNotifier {
  List<OrganizationModel> currentCacheOrganizations = [];
  final CustomWidgets _customWidgets = CustomWidgets();
  final Map<String, String> headers = {
    "Content-Type": "application/json",
  };

  //login into application
  Future login({
    required String email,
    required String password,
    required int signInType,
    required BuildContext context,
  }) async {
    try {
      http.Response responce = await http.post(
        Uri.parse(kUserLoginEndPont),
        body: jsonEncode({
          "email": email,
          "password": password,
          "signin_type": signInType,
        }),
        headers: {"Content-Type": "application/json"},
      );

      Map<String, dynamic> userJson = jsonDecode(responce.body);

      if (responce.statusCode == 200) {
        //user available and check is verified or not
        if (userJson["is_verified"] == true) {
          //user is verified
          //check user is logging first time
          final isFirstTime = userJson["login_count"] <= 1 ? true : false;
          if (isFirstTime) {
            //first time login
            //cache user data
            OrganizationModel org =
                OrganizationModel.fromJson(userJson["current_org"]);
            //update user data with organization model
            userJson["current_org"] = org;
            ClockUser user = ClockUser.fromJson(userJson);
            //cache the current user
            Hive.box(kUserBox).put(kCurrentUserKey, user);

            if (signInType == 1) {
              await Hive.box(kUserBox).put(kSignInType, 1);
              Get.offAll(() => StaffProfile());
            } else if (signInType == 2) {
              await Hive.box(kUserBox).put(kSignInType, 2);
              Get.offAll(() => StaffProfile());
            } else {
              await Hive.box(kUserBox).put(kSignInType, 3);

              Navigator.of(context).pushNamed(kLocationModificationRoute);
            }
          } else {
            //cache the user Data
            //convert the organization model
            OrganizationModel org =
                OrganizationModel.fromJson(userJson["current_org"]);
            //update user data with organization model
            userJson["current_org"] = org;
            //get a clock user instance to store cache
            ClockUser user = ClockUser.fromJson(userJson);
            //cache the current user
            Hive.box(kUserBox).put(kCurrentUserKey, user);
            await Hive.box(kUserBox).put("isLoggedIn", true);

            if (signInType == 1) {
              await Hive.box(kUserBox).put(kSignInType, 1);
              Get.offAll(() => StaffProfile());
            } else if (signInType == 2) {
              await Hive.box(kUserBox).put(kSignInType, 2);
              Get.offAll(() => StaffProfile());
            } else {
              await Hive.box(kUserBox).put(kSignInType, 3);

              Navigator.of(context)
                  .pushNamedAndRemoveUntil(kMainScreen, (route) => false);
            }
          }
        } else {
          //user not verified
          _customWidgets.failureToste(
              text: "Email is not verified Please SignUp again !",
              context: context);
        }

        return "done";
      } else {
        Map message = jsonDecode(responce.body);
        _customWidgets.failureToste(text: message["msg"], context: context);
      }
    } catch (e) {
      debugPrint("error when loging in");
      _customWidgets.failureToste(text: e.toString(), context: context);
    }
  }

  //verify user mail with otp
  Future verifyUserGmail({
    required String mail,
    required otpCode,
    required String jobTitle,
    required BuildContext context,
  }) async {
    int otp = int.parse(otpCode);
    try {
      final Uri uri = Uri.parse(kVerifyGmailEndPoint);
      final body = jsonEncode({"email": mail, "code": otp});
      http.Response responce =
          await http.post(uri, body: body, headers: headers);
      if (responce.statusCode == 200) {
        return "done";
      } else {
        Map message = jsonDecode(responce.body);
        _customWidgets.failureToste(text: message["msg"], context: context);
      }
    } catch (e) {
      debugPrint("error in verifing user email");
      _customWidgets.failureToste(text: e.toString(), context: context);
    }
  }

  //generate otp when signing in
  Future generateOTP({
    required final String mail,
    required final BuildContext context,
  }) async {
    final ClockUserProvider clockUserProvider =
        Provider.of(context, listen: false);

    try {
      Uri uri = Uri.parse(kGenerateOTPEndpoint);

      http.Response response = await http.post(uri,
          body: jsonEncode({"email": mail}), headers: headers);

      if (response.statusCode == 200) {
        _customWidgets.successToste(
            text: "Verification Code Sent", context: context);

        return "done";
      } else if (response.statusCode == 409) {
        clockUserProvider.updateVerifyingStatus(updatedStatus: 1);
        _customWidgets.failureToste(
            text: "Email already exist !", context: context);
      } else {
        clockUserProvider.updateVerifyingStatus(updatedStatus: 1);
        _customWidgets.failureToste(
            text: "Something went wrong", context: context);
      }
    } catch (error) {
      debugPrint("error when in generating otp");

      clockUserProvider.updateVerifyingStatus(updatedStatus: 1);
      _customWidgets.failureToste(text: error.toString(), context: context);
    }
  }

//generate otp when resetting the password
  Future resetGenerateOTP({
    required final String mail,
    required final BuildContext context,
  }) async {
    final ClockUserProvider clockUserProvider =
        Provider.of(context, listen: false);

    try {
      Uri uri = Uri.parse(kResetOTPEndpoint);

      http.Response response = await http.post(uri,
          body: jsonEncode({"email": mail}), headers: headers);

      if (response.statusCode == 200) {
        _customWidgets.successToste(
            text: "Verification Code Sent", context: context);
        return "done";
      } else {
        clockUserProvider.updateVerifyingStatus(updatedStatus: 1);
        _customWidgets.failureToste(
            text: "Something went wrong !", context: context);
      }
    } catch (error) {
      debugPrint("error when resending otp in forgot passwor dscreen");
      clockUserProvider.updateVerifyingStatus(updatedStatus: 1);
      _customWidgets.failureToste(text: error.toString(), context: context);
    }
  }

  //sign up user
  Future signUpClockUser({
    required String password,
    required BuildContext context,
    required Map data,
  }) async {
    try {
      String body = jsonEncode(
        {
          "email": data["mail"],
          "name": data["name"],
          "password": password,
          "website": data["website"],
          "job_title": data["job_title"],
          "organizations": [],
          "org_name": data["organization"],
        },
      );

      http.Response response = await http.post(
        Uri.parse(kUserSignUpEndPoint),
        body: body,
        headers: headers,
      );
      Map responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Navigator.of(context).pushReplacementNamed(kLoginRoute);
        return "done";
      } else {
        String message = responseData["msg"];
        _customWidgets.failureToste(text: message, context: context);
      }
    } catch (error) {
      debugPrint("error when signup action");
      _customWidgets.failureToste(text: error.toString(), context: context);
    }
  }

  //get staff suggestions in registration
  Future getMatches(
      {required String pattern, required BuildContext context}) async {
    final url = "$kBaseUrl/api/v1/staff/$pattern/suggestions";
    try {
      Uri uri = Uri.parse(url);
      http.Response responce = await http.get(uri);
      List staff = jsonDecode(responce.body);
      List<ClockUser> parsedStaff = [];
      staff.forEach((staffMember) {
        List organizations = staffMember["organizations"];
        List<OrganizationModel> parsedOrgs = organizations
            .map((e) => OrganizationModel()..organizationId = e["\$oid"])
            .toList();
        staffMember["organizations"] = parsedOrgs;
        staffMember["current_org"] = OrganizationModel()
          ..organizationId = staffMember["current_org"]["\$oid"];
        parsedStaff.add(ClockUser.fromJson(staffMember));
      });
      return parsedStaff;
    } catch (error) {
      debugPrint("error when getting staff matches");
      _customWidgets.failureToste(text: error.toString(), context: context);
    }
  }

  //manual user/visitor sign into organization
  Future manualSignInUser({
    required String organizationName,
    required String userId,
    required int signInType,
    required File profileImage,
    required BuildContext context,
  }) async {
    print(signInType);
    try {
      var request =
          http.MultipartRequest("PUT", Uri.parse(kstaffSignInEndPoint));
      request.files.add(
        await http.MultipartFile.fromPath("photo", profileImage.path),
      );
      request.fields.addAll({
        "user_id": userId,
        "org_name": organizationName,
        "signin_type": signInType.toString(),
      });

      http.StreamedResponse response = await request.send();
      var res = response.stream.asBroadcastStream().toString();
      if (res.toString().contains("413 Request Entity Too Large")) {
        _customWidgets.failureToste(
            text: "Image Is too large to upload please select another image",
            context: context);
      } else {
        Map<String, dynamic> organization =
            jsonDecode(await response.stream.bytesToString());
        List previousStaff = organization["staff"];
        List<ClockUser> parsedStaff = [];

        previousStaff.forEach((currentStaffMember) {
          //get organizations list of ids
          List organizations = currentStaffMember["organizations"];
          //parse organizations
          List<OrganizationModel> parsedOrganizations = organizations
              .map((currentOrganization) => OrganizationModel()
                ..organizationId = currentOrganization["\$oid"])
              .toList();
          //update current organizations with parsed orgs
          currentStaffMember["organizations"] = parsedOrganizations;

          //get current organization

          Map<String, dynamic> currentOrg = currentStaffMember["current_org"];
          OrganizationModel parsedOrg = OrganizationModel()
            ..organizationId = currentOrg["\$oid"];
          //update current org
          currentStaffMember["current_org"] = parsedOrg;

          parsedStaff.add(
              ClockUser.fromJson(currentStaffMember as Map<String, dynamic>));
        });

        organization["staff"] = parsedStaff;
        OrganizationModel changedOrganization = OrganizationModel()
          ..organizationName = organization["name"]
          ..organizationId = organization["_id"]["\$oid"]
          ..colorCode = organization["color_code"]
          ..colorOpacity = organization["color_opacity"]
          ..createdBy = organization["created_by"]["\$oid"]
          ..staffSignIn = organization["staff_sign_in"]
          ..visitorSignIn = organization["visitor_sign_in"];

        ClockUser user = Hive.box(kUserBox).get(kCurrentUserKey);
        user.currentOrganization = changedOrganization;
        await Hive.box(kUserBox).put(kCurrentUserKey, user);

        //update the provider

        Navigator.of(context)
            .pushNamedAndRemoveUntil(kMainScreen, (route) => false);
      }
    } catch (error) {
      debugPrint("error when manual user/visitor signing");
      _customWidgets.failureToste(text: error.toString(), context: context);
    } finally {
      Provider.of<OrganizationProvider>(context, listen: false)
          .getCurrentOrganizationSignedInStaff(context: context);
      Provider.of<OrganizationProvider>(context, listen: false)
          .getCurrentOrganizationSignedInVisitors(context: context);
    }
  }

  //fetch current user organizations
  Future getCurrentSites(
      {required String? userId, required BuildContext context}) async {
    try {
      //get sites
      http.Response response = await http.get(Uri.parse(
          kGetCurrentSitesEndPoint.replaceFirst("user_id", userId.toString())));

      if (response.statusCode == 200) {
        List currentSites = jsonDecode(response.body);
        List<OrganizationModel> currentOrganizations = currentSites
            .map((organization) => OrganizationModel.fromJson(
                organization as Map<String, dynamic>))
            .toList();
        currentCacheOrganizations = currentOrganizations;

        return currentOrganizations;
      } else {
        _customWidgets.failureToste(
            text: jsonDecode(response.body)["msg"], context: context);
      }
      notifyListeners();
    } catch (error) {
      debugPrint("error when etching current user organizations");
      _customWidgets.failureToste(text: error.toString(), context: context);
    }
  }

  //update visitor and user sign permissions at registration of organization
  Future updateSignInStatus(
      {required Map data, required BuildContext context}) async {
    try {
      http.Response response = await http.put(
        Uri.parse(kUpdateOrganizationData),
        headers: headers,
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        return "done";
      } else {
        debugPrint(response.body);
      }
    } catch (error) {
      _customWidgets.failureToste(text: error.toString(), context: context);
    }
  }

  //reset user password
  Future resetUserPassword(
      {required String email,
      required String updatedPassword,
      required BuildContext context}) async {
    try {
      http.Response response = await http.put(
        Uri.parse(
          kResetUserPasswordEndpoint,
        ),
        body: jsonEncode({
          "email": email,
          "password": updatedPassword,
        }),
        headers: headers,
      );

      if (response.statusCode == 200) {
        _customWidgets.successToste(
            text: "Password updated successfully", context: context);
        return "done";
      } else {
        Map message = jsonDecode(response.body);
        _customWidgets.failureToste(text: message["msg"], context: context);
      }
    } catch (error) {
      _customWidgets.failureToste(text: error.toString(), context: context);
    }
  }
}
