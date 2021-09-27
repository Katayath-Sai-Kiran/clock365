import 'dart:convert';
import 'dart:io';

import 'package:clock365/models/clock_user.dart';
import 'package:clock365/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:clock365/constants.dart';
import 'package:provider/provider.dart';

class UserRepository extends ChangeNotifier {
  String userId = "";
  final Map<String, String> headers = {
    "Content-Type": "application/json",
  };
  ClockUser owner = ClockUser();

  Future updateOwner({required List updatedOrganizations}) async {
    owner..organizations = updatedOrganizations;
    notifyListeners();
  }

  Future login({
    required String email,
    required String password,
    required int signInType,
    required BuildContext context,
  }) async {
    final ClockUserProvider clockUserProvider =
        Provider.of(context, listen: false);
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
        clockUserProvider.setOwner(updatedUser: ClockUser.fromJson(userJson));

        await Hive.box<ClockUser>(kClockUserBox)
            .put(kCurrentUserKey, ClockUser.fromJson(userJson));

        final String oId = userJson["_id"]["\$oid"];
        Box bufferBox = await Hive.openBox(kUserIdBuffer);

        List buffer = bufferBox.get("buffer") ?? [];

        if (!buffer.contains(oId)) {
          await Hive.box(kUserBox).putAll(
            {
              kcurrentUserId: oId,
              oId: {
                "currentUser": ClockUser.fromJson(userJson),
                "themeData": {},
                "loginDetails": {"isLoggedIn": false},
                "currentOrganization": {},
              },
            },
          );

          buffer.add(oId);
          await Hive.box(kUserIdBuffer).put("buffer", buffer);

          Navigator.of(context)
              .pushReplacementNamed(kLocationModificationRoute);
        } else {
          Box userBox = await Hive.openBox(kUserBox);
          await userBox.put(kcurrentUserId, oId);
          Map previousData = userBox.get(oId);
          previousData.update("loginDetails", (value) => {"isLoggedIn": true});
          await Hive.box(kUserBox).put(oId, previousData);

          Navigator.of(context)
              .pushNamedAndRemoveUntil(kMainScreen, (route) => false);
        }

        return "done";
      } else {
        Map message = jsonDecode(responce.body);
        print(message);
        return message["msg"];
      }
    } catch (e) {
      print("error -$e");
      return e.toString();
    }
  }

  Future verifyUserGmail({
    required String mail,
    required otpCode,
    required String jobTitle,
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
        return message["msg"];
      }
    } catch (e) {
      return e.toString();
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

      String message = jsonDecode(response.body)["msg"];

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
        return "done";
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
        return message;
      }
    } catch (error) {
      print(error);
      return error.toString();
    }
  }

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
        },
      );

      http.Response response = await http.post(
        Uri.parse(kUserSignUpEndPoint),
        body: body,
        headers: headers,
      );

      if (response.statusCode == 200) {
        print(response.body);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("successfully signed up")));
        Navigator.of(context).pushReplacementNamed(kLoginRoute);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.body)));
      }
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  Future getMatches({required String pattern}) async {
    final url = "$kBaseUrl/api/v1/staff/$pattern/suggestions";
    try {
      Uri uri = Uri.parse(url);
      http.Response responce = await http.get(uri);
      List data = jsonDecode(responce.body);

      List<ClockUser> staff = <ClockUser>[
        ...data.map((e) => ClockUser.fromJson(e))
      ];

      return staff;
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

      Map organization = jsonDecode(await response.stream.bytesToString());

      String currentUserId = Hive.box(kUserBox).get(kcurrentUserId);
      Map userData = Hive.box(kUserBox).get(currentUserId);
      userData.update("currentOrganization", (value) => organization);
      print(userData);

      // await Hive.box(kUserBox).put(currentUserId, userData);

      // Navigator.of(context)
      //     .pushNamedAndRemoveUntil(kMainScreen, (route) => false);
      print(await response.stream.bytesToString());
    } catch (error) {
      print("error is $error");
    }
  }
}
