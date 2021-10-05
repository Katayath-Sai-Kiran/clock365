import 'dart:convert';

import 'package:clock365/constants.dart';
import 'package:clock365/customWidgets.dart';
import 'package:clock365/models/OrganizationModel.dart';
import 'package:clock365/models/clock_user.dart';
import 'package:clock365/repository/userRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class OrganizationRepository extends ChangeNotifier {
  final CustomWidgets _customWidgets = CustomWidgets();
  final Map<String, String> headers = {
    "Content-Type": "application/json",
  };

  Future setCurrentOrganization(
      {required OrganizationModel updatedOrganization,
      required String colorCode,
      required double colorOpasity}) async {
    updatedOrganization.colorCode = colorCode;
    updatedOrganization.colorOpacity = colorOpasity;

    ClockUser currentUser = await Hive.box(kUserBox).get(kCurrentUserKey);
    currentUser.currentOrganization = updatedOrganization;
    await Hive.box(kUserBox).put(kCurrentUserKey, currentUser);
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

      // currentUser.organizations = updatedCurrentOrgs;

      userData.update("currentUser", (value) => currentUser);

      userData.update(
          "currentOrganization", (value) => currentOfflineOrganization);

      await Hive.box(kUserBox).put(userId, userData);
      _customWidgets.successToste(text: result["msg"], context: context);
    } else {
      _customWidgets.failureToste(text: result["msg"], context: context);
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

      // currentOfflineUser.organizations = updatedCurrentOrgs;

      currentOfflineUserData.update(
          "currentUser", (value) => currentOfflineUser);

      currentOfflineUserData.update(
          "currentOrganization", (value) => currentOfflineOrganization);

      await Hive.box(kUserBox).put(userId, currentOfflineUserData);
    } else {
      _customWidgets.failureToste(text: result["msg"], context: context);
    }
  }

  Future registerOrganization({
    required Map data,
    required BuildContext context,
  }) async {
    final UserRepository userRepository = Provider.of(context, listen: false);
    try {
      final Uri uri = Uri.parse(kUserOrganizationResisterEndpoint);

      final String encodedData = jsonEncode(data);

      http.Response response =
          await http.post(uri, headers: headers, body: encodedData);

      if (response.statusCode == 201) {
        //request successful
        //cache the user data
        Map<String, dynamic> organizationData = jsonDecode(response.body);

        List newOrgStaff = organizationData["staff"];

        List<ClockUser> parsedStaff =
            newOrgStaff.map((staff) => ClockUser.fromJson(staff)).toList();

        organizationData["staff"] = parsedStaff;
        OrganizationModel organizationModel =
            OrganizationModel.fromJson(organizationData);

        userRepository.updateCurrentCacheOrganizations(
            newOrganization: organizationModel);

        ClockUser user = Hive.box(kUserBox).get(kCurrentUserKey);

        List<OrganizationModel>? previousOrganizations =
            user.organizations ?? [];

        user.organizations = [organizationModel, ...previousOrganizations];
        await Hive.box(kUserBox).put(kCurrentUserKey, user);

        _customWidgets.successToste(
            text: "Organization successfully registered", context: context);
      } else {
        Map result = jsonDecode(response.body);
        _customWidgets.failureToste(text: result["msg"], context: context);
      }
    } catch (e) {
      _customWidgets.failureToste(text: e.toString(), context: context);
    }
  }

  Future<List<OrganizationModel>> getOrganizationSuggetions(
      {required String pattern}) async {
    try {
      final String getOrgsUrl = "$kBaseUrl/api/v1/org/$pattern/suggestions";
      http.Response response = await http.get(Uri.parse(getOrgsUrl));
      List organizations = [];
      List<OrganizationModel> parsedOrganizations = [];
      if (response.statusCode == 200) {
        organizations = jsonDecode(response.body);

        organizations.forEach((organization) {
          List<ClockUser>? staff = [];
          List<ClockUser>? staffSignedIn = [];
          List<ClockUser>? visitorSignedId = [];

          List tempStaff = organization["staff"];
          List tempStaffSignedIn = organization["staff_signed_in"];
          List tempVisitorSignedIn = organization["visitors_signed_in"];
          tempStaff.forEach((staffMember) {
            staff.add(ClockUser()..id = staffMember["\$oid"]);
          });
          tempStaffSignedIn.forEach((staffMember) {
            staffSignedIn.add(ClockUser()..id = staffMember["\$oid"]);
          });
          tempVisitorSignedIn.forEach((staffMember) {
            visitorSignedId.add(ClockUser()..id = staffMember["\$oid"]);
          });

          organization["staff"] = staff;
          organization["staff_signed_in"] = staffSignedIn;
          organization["visitors_signed_in"] = visitorSignedId;
          parsedOrganizations.add(OrganizationModel.fromJson(organization));
        });
      }
      return parsedOrganizations;
    } catch (error) {
      print(error);
      return [];
    }
  }

  Future addExistingOrganization(
      {required Map data, required BuildContext context}) async {
    final UserRepository userRepository = Provider.of(context, listen: false);
    try {
      final Uri uri = Uri.parse(kUserExistingOrganizationEndpoint);

      final String encodedData = jsonEncode(data);

      http.Response response =
          await http.put(uri, headers: headers, body: encodedData);

      if (response.statusCode == 200) {
        //request successful
        //cache the user data
        Map<String, dynamic> organizationData = jsonDecode(response.body);

        List newOrgStaff = organizationData["staff"];

        List<ClockUser> parsedStaff =
            newOrgStaff.map((staff) => ClockUser.fromJson(staff)).toList();

        organizationData["staff"] = parsedStaff;
        OrganizationModel organizationModel =
            OrganizationModel.fromJson(organizationData);

        userRepository.updateCurrentCacheOrganizations(
            newOrganization: organizationModel);

        ClockUser user = Hive.box(kUserBox).get(kCurrentUserKey);

        List<OrganizationModel>? previousOrganizations =
            user.organizations ?? [];

        user.organizations = [organizationModel, ...previousOrganizations];
        await Hive.box(kUserBox).put(kCurrentUserKey, user);

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

  Future<List<ClockUser>?> getCurrentOrganizationsignedStaff(
      {required final String organizationId,
      required final BuildContext context}) async {
    List<ClockUser> staff = [];
    try {
      http.Response response = await http.get(Uri.parse(
          kGetStaffSignedInEndpoint.replaceFirst("org_id", organizationId)));
      if (response.statusCode == 200) {
        List responseList = jsonDecode(response.body);
        staff = responseList
            .map((e) => ClockUser.fromJson(e as Map<String, dynamic>))
            .toList();
        return staff;
      } else {
        print(response.body);
      }
    } catch (error) {
      print("error is $error");
    }
  }

  Future<List<ClockUser>?> getCurrentOrganizationsignedVisitors(
      {required final String organizationId,
      required final BuildContext context}) async {
    List<ClockUser> staff = [];
    try {
      http.Response response = await http.get(Uri.parse(
          kGetVisitorSignedInEndpoint.replaceFirst("org_id", organizationId)));
      if (response.statusCode == 200) {
        List responseList = jsonDecode(response.body);
        staff = responseList
            .map((e) => ClockUser.fromJson(e as Map<String, dynamic>))
            .toList();
        return staff;
      } else {
        print(response.body);
      }
    } catch (error) {
      print("error is $error");
    }
  }

  Future<List<ClockUser>?> getCurrentOrganizationStaff(
      {required final String organizationId,
      required final BuildContext context}) async {
    List<ClockUser> staff = [];
    try {
      http.Response response = await http.get(
          Uri.parse(kGetStaffEndpoint.replaceFirst("org_id", organizationId)));
      if (response.statusCode == 200) {
        List responseList = jsonDecode(response.body);
        staff = responseList
            .map((e) => ClockUser.fromJson(e as Map<String, dynamic>))
            .toList();

        return staff;
      } else {
        print(response.body);
      }
    } catch (error) {
      print("error is $error");
    }
  }

  Future<List<OrganizationModel>?> getCurrentOrganizations(
      {required final String userId,
      required final BuildContext context}) async {
    List<OrganizationModel> organizations = [];
    try {
      http.Response response = await http.get(
          Uri.parse(kGetCurrentOrganizations.replaceFirst("user_id", userId)));
      if (response.statusCode == 200) {
        List responseList = jsonDecode(response.body) ?? [];

        organizations = responseList
            .map((e) => OrganizationModel.fromJson(e as Map<String, dynamic>))
            .toList();

        return organizations;
      } else {
        print(response.body);
        return [];
      }
    } catch (error) {
      print("error is $error");
    }
  }

  Future<OrganizationModel> getScannedOrganizationDetails(
      {required BuildContext context, required String orgId}) async {
    OrganizationModel scannedOrganization = OrganizationModel();

    try {
      http.Response response = await http.get(Uri.parse(
          kGetScannedOrgDetailsEndPoint.replaceFirst("org_id", orgId)));
      if (response.statusCode == 200) {
        List organization = jsonDecode(response.body);
        Map parsedOrganization = organization[0];
        List staff = parsedOrganization["staff"];
        List<ClockUser> parsedStaff = staff
            .map((member) => ClockUser()..id = member["_id"]["\$oid"])
            .toList();

        scannedOrganization = OrganizationModel()
          ..staff = parsedStaff
          ..staffSignIn = parsedOrganization["staff_sign_in"]
          ..visitorSignIn = parsedOrganization["visitor_sign_in"]
          ..organizationName = parsedOrganization["name"];

        return scannedOrganization;
      } else {
        Map message = jsonDecode(response.body);
        _customWidgets.failureToste(text: message["msg"], context: context);
        return scannedOrganization;
      }
    } catch (error) {
      _customWidgets.failureToste(text: error.toString(), context: context);
      return scannedOrganization;
    }
  }
}
