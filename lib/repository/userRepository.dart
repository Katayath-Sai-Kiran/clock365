import 'dart:convert';
import 'dart:io';

import 'package:clock365/constants.dart';
import 'package:clock365/customWidgets.dart';
import 'package:clock365/models/OrganizationModel.dart';
import 'package:clock365/models/clock_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

class UserRepository extends ChangeNotifier {
  String userId = "";
  List<OrganizationModel> currentCacheOrganizations = [];
  final CustomWidgets _customWidgets = CustomWidgets();
  final Map<String, String> headers = {
    "Content-Type": "application/json",
  };
  Future updateCurrentCacheOrganizations(
      {required OrganizationModel newOrganization}) async {
    currentCacheOrganizations.add(newOrganization);
    notifyListeners();
  }

  ClockUser owner = ClockUser();

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
      print(responce.body);

      Map<String, dynamic> userJson = jsonDecode(responce.body);

      print("user response from login $userJson");

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
            //get a clock user instance to store cache
            ClockUser user = ClockUser.fromJson(userJson);
            //cache the current user
            Hive.box(kUserBox).put(kCurrentUserKey, user);
            //redirect to modification screen
            Navigator.of(context).pushNamed(kLocationModificationRoute);
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

            Navigator.of(context)
                .pushNamedAndRemoveUntil(kMainScreen, (route) => false);
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
      print("error");

      _customWidgets.failureToste(text: e.toString(), context: context);
    }
  }

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
      _customWidgets.failureToste(text: e.toString(), context: context);
    }
  }

  Future generateOTP({
    required final String mail,
    required final BuildContext context,
  }) async {
    try {
      Uri uri = Uri.parse(kGenerateOTPEndpoint);

      http.Response response = await http.post(uri,
          body: jsonEncode({"email": mail}), headers: headers);

      if (response.statusCode == 200) {
        _customWidgets.successToste(
            text: "Verification Code Sent", context: context);

        return "done";
      } else {
        _customWidgets.failureToste(
            text: "Email is already existed !", context: context);
      }
    } catch (error) {
      _customWidgets.failureToste(text: error.toString(), context: context);
    }
  }

  Future signUpClockUser({
    required String password,
    required BuildContext context,
    required Map data,
  }) async {
    try {
      print(data);
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
        print(response.body);
        Navigator.of(context).pushReplacementNamed(kLoginRoute);
        return "done";
      } else {
        String message = responseData["msg"];
        _customWidgets.failureToste(text: message, context: context);
      }
    } catch (error) {
      _customWidgets.failureToste(text: error.toString(), context: context);
    }
  }

  Future getMatches({required String pattern}) async {
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

      print("staff are $parsedStaff");

      return parsedStaff;
    } catch (e) {
      print("error $e");
    }
  }

  Future manualSignInUser({
    required String organizationName,
    required String userId,
    required int signInType,
    required File profileImage,
    required BuildContext context,
  }) async {
    print("$organizationName $userId $signInType");
    var request = http.MultipartRequest("PUT", Uri.parse(kstaffSignInEndPoint));
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16.0),
          content: Row(
            children: [
              Icon(
                Icons.warning_amber_outlined,
                color: Colors.orange,
              ),
              SizedBox(width: 16.0),
              Flexible(
                child: Text(
                  "Image Is too large to upload please select another image",
                  maxLines: 5,
                  softWrap: true,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      print("response from manual signIn $res");
      Map<String, dynamic> organization =
          jsonDecode(await response.stream.bytesToString());
      List previousStaff = organization["staff"];
      List<OrganizationModel> updatedStaff = [];
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

      Navigator.of(context)
          .pushNamedAndRemoveUntil(kMainScreen, (route) => false);
    }
  }

  Future getCurrentSites({required String? userId}) async {
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
        print("error");
      }
      notifyListeners();
    } catch (error) {
      print("error $error");
      return [];
    }
  }

  Future manualSignInVisitor(
      {required String organizationName,
      required int signInType,
      required File profileImage}) async {
    try {
      var request =
          http.MultipartRequest("PUT", Uri.parse(kGetVisitorSignedInEndpoint));
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
    } catch (error) {}
  }
}
