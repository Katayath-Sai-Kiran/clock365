import 'dart:convert';

import 'package:clock365/models/clock_user.dart';
import 'package:clock365/providers/user_provider.dart';
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
  Map? currentOrganization;
  Map? get currentOrg => currentOrganization;

  Future setCurrentOrganization({required Map? updatedOrganization}) async {
    print("updated are $updatedOrganization");
    currentOrganization = updatedOrganization;

    notifyListeners();
  }

  Future addStaffToOrganization({
    required ClockUser user,
    required String organizationId,
    required BuildContext context,
  }) async {
    final Uri uri = Uri.parse(kAddnNewStaffEndPoint);
    String body = jsonEncode({"org_id": organizationId, "user_id": user.id});

    http.Response response = await http.put(uri, headers: headers, body: body);
    Map result = jsonDecode(response.body);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 2000),
          backgroundColor: Colors.black,
          content: Text(result["msg"]),
        ),
      );

      final String userId = Hive.box(kUserBox).get(kcurrentUserId);
      Map userData = Hive.box(kUserBox).get(userId);
      ClockUser currentUser = userData["currentUser"];

      List? currentUserOrganizations = currentUser.organizations;
      List updatedCurrentOrgs = [];
      Map currentOfflineOrganization =
          Hive.box(kUserBox).get(userId)["currentOrganization"];

      List currentOfflineOrganizationStaff =
          currentOfflineOrganization["staff"] ?? [];

      currentUserOrganizations!.asMap().forEach(
        (key, organization) {
          if (organization["_id"]["\$oid"] == organizationId) {
            List currentStaff = organization["staff"];

            organization["staff"] = [user, ...currentStaff];

            currentOfflineOrganizationStaff.add([user, ...currentStaff]);

            updatedCurrentOrgs.add(organization);
          } else {
            updatedCurrentOrgs.add(organization);
          }
        },
      );
      currentOfflineOrganization.update(
          "staff", (value) => currentOfflineOrganizationStaff);

      currentUser.organizations = updatedCurrentOrgs;

      userData.update("currentUser", (value) => currentUser);

      userData.update(
          "currentOrganization", (value) => currentOfflineOrganization);

      await Hive.box(kUserBox).put(userId, userData);
      
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 2000),
          backgroundColor: Colors.black,
          content: Text(result["msg"]),
        ),
      );
    }
  }

  Future removeStaffFromOrganization({
    required ClockUser user,
    required String organizationId,
    required BuildContext context,
  }) async {
    final Uri uri = Uri.parse(kAddnNewStaffEndPoint);
    String body = jsonEncode({"org_id": organizationId, "user_id": user.id});

    http.Response response = await http.put(uri, headers: headers, body: body);
    Map result = jsonDecode(response.body);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 2000),
          backgroundColor: Colors.black,
          content: Text(result["msg"]),
        ),
      );

      final String userId = Hive.box(kUserBox).get(kcurrentUserId);
      Map currentOfflineUserData = Hive.box(kUserBox).get(userId);
      ClockUser currentOfflineUser = currentOfflineUserData["currentUser"];
      List? currentUserOrganizations = currentOfflineUser.organizations;

      List updatedCurrentOrgs = [];

      Map currentOfflineOrganization =
          Hive.box(kUserBox).get(userId)["currentOrganization"];

      List currentOfflineOrganizationStaff =
          currentOfflineOrganization["staff"] ?? [];

      currentUserOrganizations!.asMap().forEach(
        (key, organization) {
          if (organization["_id"]["\$oid"] == organizationId) {
            List<ClockUser> currentOfflineStaff = organization["staff"];

            currentOfflineStaff.removeWhere(
                (currentOfflineUser) => currentOfflineUser.id == user.id);

            organization["staff"] = [...currentOfflineStaff];

            currentOfflineOrganizationStaff.add([...currentOfflineStaff]);

            updatedCurrentOrgs.add(organization);
          } else {
            updatedCurrentOrgs.add(organization);
          }
        },
      );
      currentOfflineOrganization.update(
          "staff", (value) => currentOfflineOrganizationStaff);

      currentOfflineUser.organizations = updatedCurrentOrgs;

      currentOfflineUserData.update(
          "currentUser", (value) => currentOfflineUser);

      currentOfflineUserData.update(
          "currentOrganization", (value) => currentOfflineOrganization);

      await Hive.box(kUserBox).put(userId, currentOfflineUserData);
      
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 2000),
          backgroundColor: Colors.black,
          content: Text(result["msg"]),
        ),
      );
    }
  }

  Future registerOrganization({
    required Map data,
    required String oId,
    required BuildContext context,
  }) async {
    final ClockUserProvider clockUserProvider =
        Provider.of(context, listen: false);
    try {
      final Uri uri = Uri.parse(kUserOrganizationResisterEndpoint);

      final String encodedData = jsonEncode(data);

      http.Response response =
          await http.post(uri, headers: headers, body: encodedData);

      if (response.statusCode == 201) {
        //
        Map organizationData = jsonDecode(response.body);

        Map userData = Hive.box(kUserBox).get(oId);

        ClockUser currentUser = userData["currentUser"];

        List? previousOrganizations = currentUser.organizations;

        List updatedOrganizations = [
          organizationData,
          ...previousOrganizations!
        ];

        clockUserProvider.setOwner(updatedUser: currentUser);

        currentUser.organizations = updatedOrganizations;

        userData.update("currentUser", (value) => currentUser);

        await Hive.box(kUserBox).put(oId, userData);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("organization successfully added"),
          ),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.body)));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<Map>> getOrganizationMatches() async {
    return [];
  }

  Future staffSignIntoOrganization({
    required String organizationId,
    required String userId,
  }) async {
    try {
      http.Response staffSignInresponse = await http.put(
        Uri.parse(kstaffSignInEndPoint),
        body: jsonEncode({"org_id": "", "user_id": "", "signin_type": 1}),
        headers: headers,
      );
      print("staff signed In $staffSignInresponse");
    } catch (error) {
      print("error while staff singing $error");
    }
  }

  Future<List<Map>> getOrganizationSuggetions({required String pattern}) async {
    try {
      final String getOrgsUrl = "$kBaseUrl/api/v1/org/$pattern/suggestions";
      http.Response response = await http.get(Uri.parse(getOrgsUrl));
      List organizations = [];
      List<Map> parsedOrganizations = [{}];
      if (response.statusCode == 200) {
        organizations = jsonDecode(response.body);
        parsedOrganizations.clear();
        organizations.forEach((organization) {
          parsedOrganizations.add(organization as Map);
        });
      }
      return parsedOrganizations;
    } catch (error) {
      print(error);
      return [{}];
    }
  }
}
