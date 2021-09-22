import 'dart:convert';

import 'package:clock365/models/clock_user.dart';
import 'package:clock365/repository/userRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:clock365/constants.dart';
import 'package:provider/provider.dart';

class OrganizationRepository extends ChangeNotifier {
  final Map<String, String> headers = {
    "Content-Type": "application/json",
  };
  Map? currentOrganization = {};
  Map? get currentOrg => currentOrganization;

  Future setCurrentOrganization({required Map? updatedOrganization}) async {
    currentOrganization = updatedOrganization;

    notifyListeners();
  }

  Future addStaffToOrganization({
    required ClockUser user,
    required String organizationId,
    required BuildContext context,
  }) async {
    final Uri uri = Uri.parse(kAddnNewStaffEndPoint);
    String body = jsonEncode({
      "org_id": organizationId,
      "user_id": user.id,
    });

    http.Response response = await http.put(
      uri,
      headers: headers,
      body: body,
    );
    Map result = jsonDecode(response.body);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(milliseconds: 2000),
        backgroundColor: Colors.black,
        content: Text(result["msg"]),
      ));

      Box userBox = await Hive.openBox<dynamic>(kUserBox);
      String userId = userBox.get(kcurrentUserId);
      Map userEntireData = userBox.get(userId);
      Map userData = userEntireData["data"];
      print("organizations are ${userData["organizations"]}");
      List currentUserOrganizations = userData["organizations"];
      List updatedCurrentOrgs = [];
      currentUserOrganizations.asMap().forEach((key, value) {
        if (value["_id"]["\$oid"] == organizationId) {
          List currentStaff = value["staff"];
          value["staff"] = [user, ...currentStaff];
          print("updated value is $value");
          updatedCurrentOrgs.add(value);
        } else {
          updatedCurrentOrgs.add(value);
        }
      });
      userData.update("organizations", (value) => updatedCurrentOrgs);
      userEntireData.update("data", (value) => userData);
      await userBox.put(userId, userEntireData);
      print("updated local database");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(milliseconds: 2000),
        backgroundColor: Colors.black,
        content: Text(result["msg"]),
      ));
    }
  }

  Future removeStaffFromOrganization({
    required ClockUser user,
    required String organizationId,
    required BuildContext context,
  }) async {
    final Uri uri = Uri.parse(kAddnNewStaffEndPoint);
    String body = jsonEncode({
      "org_id": organizationId,
      "user_id": user.id,
    });

    http.Response response = await http.put(
      uri,
      headers: headers,
      body: body,
    );
    Map result = jsonDecode(response.body);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(milliseconds: 2000),
        backgroundColor: Colors.black,
        content: Text(result["msg"]),
      ));
      print(response.body);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(milliseconds: 2000),
        backgroundColor: Colors.black,
        content: Text(result["msg"]),
      ));
      print(response.body);
    }
  }

  Future registerOrganization({
    required Map data,
    required String oId,
    required BuildContext context,
  }) async {
    final UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);
    try {
      final Uri uri = Uri.parse(kUserOrganizationResisterEndpoint);

      final String encodedData = jsonEncode(data);

      http.Response response =
          await http.post(uri, headers: headers, body: encodedData);

      if (response.statusCode == 201) {
        Map organizationData = jsonDecode(response.body);
        Box users = await Hive.openBox<dynamic>(kUserBox);
        Map userData = users.get(oId);

        Map userOrganizations = users.get(oId)["data"];

        List updatedOrganizations = userOrganizations["organizations"];

        updatedOrganizations.add(organizationData);

        userOrganizations.update(
            "organizations", (value) => updatedOrganizations);
        userData.update("data", (value) => userOrganizations);

        await users.put(oId, userData);

        userRepository.updateOwner(updatedOrganizations: updatedOrganizations);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("organization successfully added")));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.body)));
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
