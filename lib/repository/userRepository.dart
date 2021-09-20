import 'dart:convert';

import 'package:clock365/models/clock_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:clock365/constants.dart';

class UserRepository extends ChangeNotifier {
  String userId = "";
  final Map<String, String> headers = {
    "Content-Type": "application/json",
  };
  ClockUser? owner;

  Future addOrganizations({required String organization}) async {
    owner!..organizations = [...owner!.organizations!, organization];

    Box clockUserBox = await Hive.openBox<ClockUser>("clockUserBox");
    await clockUserBox.put("clockUser", owner);

    notifyListeners();
  }

  Future updateOwner({required List updatedOrganizations}) async {
    owner!..organizations = updatedOrganizations;
    notifyListeners();
  }

  Future login({
    required String email,
    required String password,
    required int signInType,
  }) async {
    try {
      Uri url = Uri.parse(kUserLoginEndPont);
      String body = jsonEncode({
        "email": email,
        "password": password,
        "signin_type": signInType,
      });

      http.Response responce = await http.post(
        url,
        body: body,
        headers: headers,
      );

      if (responce.statusCode == 200) {
        Box authBoxModel = await Hive.openBox<bool>("AuthModelBox");
        Box clockUserBox = await Hive.openBox<ClockUser>("clockUserBox");
        Box users = await Hive.openBox<Map>(kUserBox);

        await authBoxModel.put("isLoggedIn", true);

        Map<String, dynamic> userJson = jsonDecode(responce.body);
        await clockUserBox.put("clockUser", ClockUser.fromJson(userJson));
        final String oId = userJson["_id"]["\$oid"];

        userId = oId;

        await users.put(oId, {
          "data": userJson,
          "organizations": [],
          "themeData": {},
        });

        owner = clockUserBox.get("clockUser");

        notifyListeners();

        return "done";
      } else {
        Map message = jsonDecode(responce.body);
        return message["msg"];
      }
    } catch (e) {
      print("error -$e");
      return e.toString();
    }
  }

  Future verifyUserGmail(
      {required String mail,
      required otpCode,
      required String jobTitle}) async {
    int otp = int.parse(otpCode);
    try {
      final Uri uri = Uri.parse(kVerifyGmailEndPoint);
      final body = jsonEncode({"email": mail, "code": otp});
      http.Response responce =
          await http.post(uri, body: body, headers: headers);
      if (responce.statusCode == 200) {
        owner = ClockUser(
          email: mail,
          id: "",
          isStaff: false,
          jobTitle: jobTitle,
        );
        notifyListeners();
        return "done";
      } else {
        Map message = jsonDecode(responce.body);
        return message["msg"];
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future generateOTP({required final String mail}) async {
    try {
      Uri uri = Uri.parse(kGenerateOTPEndpoint);
      String body = jsonEncode({"email": mail});
      http.Response responce =
          await http.post(uri, body: body, headers: headers);
      if (responce.statusCode == 200) {
        print(responce.body);
        notifyListeners();
        return "done";
      } else {
        Map message = jsonDecode(responce.body);
        return message["msg"];
      }
    } catch (error) {
      return error.toString();
    }
  }

  Future signUpClockUser({
    required String password,
    required String name,
    required String orgName,
    required String website,
  }) async {
    try {
      String body = jsonEncode({
        "email": owner!.email.toString(),
        "name": name,
        "password": password,
        "website": website,
        "job_title": owner!.jobTitle.toString(),
        "organizations": [orgName],
      });

      owner = ClockUser(
        email: owner!.email,
        id: "",
        isStaff: true,
        jobTitle: owner!.jobTitle,
        name: name,
        organizations: [],
        website: website,
      );

      notifyListeners();

      http.Response response = await http.post(
        Uri.parse(kUserSignUpEndPoint),
        body: body,
        headers: headers,
      );
      if (response.statusCode == 200) {
        print("done");
        return "done";
      } else {
        Map message = jsonDecode(response.body);
        return message["msg"];
      }
    } catch (error) {
      return error.toString();
    }
  }

  Future getMatches({required String pattern}) async {
    final url = "$kBaseUrl/api/v1/staff/$pattern/suggestions";
    try {
      Uri uri = Uri.parse(url);
      http.Response responce = await http.get(
        uri,
      );
      List data = jsonDecode(responce.body);
      List<ClockUser> staff = <ClockUser>[
        ...data.map((e) => ClockUser.fromJson(e))
      ];

      return staff;
    } catch (e) {
      print("error $e");
    }
  }
}
