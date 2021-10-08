import 'dart:convert';

import 'package:clock365/constants.dart';
import 'package:clock365/customWidgets.dart';
import 'package:clock365/models/OrganizationModel.dart';
import 'package:clock365/models/clock_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class OrganizationProvider extends ChangeNotifier {
  final CustomWidgets _customWidgets = CustomWidgets();
  OrganizationModel? currentOrganization;
  List<ClockUser> currentOrganizationSignedInStaff = [];
  List<ClockUser> currentOrganizationSignedInVisitors = [];
  List<ClockUser> currentOrganizationStaff = [];
  bool areStaffLoading = false;
  bool areVisitorsLoading = false;
  bool isOrganizationDetailsLoading = false;

  void updateOrganizationLoadingStatus({required bool updatedState}) {
    isOrganizationDetailsLoading = updatedState;
    notifyListeners();
  }

  Future getCurrentorganization({required BuildContext context}) async {
    try {
      notifyListeners();
    } catch (error) {
      _customWidgets.failureToste(text: error.toString(), context: context);
    }
  }

  Future getCurrentOrganizationStaff({required BuildContext context}) async {
    List<ClockUser> staff = [];
    final ClockUser currentUser = await Hive.box(kUserBox).get(kCurrentUserKey);
    try {
      http.Response response = await http.get(Uri.parse(
          kGetStaffEndpoint.replaceFirst("org_id",
              currentUser.currentOrganization!.organizationId.toString())));
      if (response.statusCode == 200) {
        List responseList = jsonDecode(response.body);
        staff = responseList
            .map((e) => ClockUser.fromJson(e as Map<String, dynamic>))
            .toList();

        currentOrganizationStaff = staff;
      } else {
        Map message = jsonDecode(response.body);
        currentOrganizationStaff = [];
        _customWidgets.failureToste(text: message["msg"], context: context);
      }
      notifyListeners();
    } catch (error) {
      currentOrganizationStaff = [];
      notifyListeners();

      _customWidgets.failureToste(text: error.toString(), context: context);
    }
  }

  Future getCurrentOrganizationSignedInStaff({
    required BuildContext context,
  }) async {
    print("called when loading");
    final ClockUser clockUser = Hive.box(kUserBox).get(kCurrentUserKey);
    final OrganizationModel? currentOrganization =
        clockUser.currentOrganization;
    final Uri url = Uri.parse(kGetStaffSignedInEndpoint.replaceFirst(
      "org_id",
      currentOrganization!.organizationId.toString(),
    ));
    try {
      http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        List responseList = jsonDecode(response.body);
        currentOrganizationSignedInStaff = responseList
            .map((e) => ClockUser.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        Map message = jsonDecode(response.body);
        _customWidgets.failureToste(text: message["msg"], context: context);
        currentOrganizationSignedInStaff = [];
      }
      notifyListeners();
    } catch (error) {
      _customWidgets.failureToste(text: error.toString(), context: context);
    }
  }

  Future getCurrentOrganizationSignedInVisitors(
      {required BuildContext context}) async {
    final ClockUser clockUser = Hive.box(kUserBox).get(kCurrentUserKey);
    final OrganizationModel? currentOrganization =
        clockUser.currentOrganization;

    final Uri url = Uri.parse(kGetVisitorSignedInEndpoint.replaceFirst(
        "org_id", currentOrganization!.organizationId.toString()));
    try {
      http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        List responseList = jsonDecode(response.body);
        print(responseList);
        currentOrganizationSignedInVisitors = responseList
            .map((e) => ClockUser.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        currentOrganizationSignedInVisitors = [];
        Map message = jsonDecode(response.body);
        _customWidgets.failureToste(text: message["msg"], context: context);
      }
    } catch (error) {
      currentOrganizationSignedInVisitors = [];

      _customWidgets.failureToste(text: error.toString(), context: context);
    }
  }
}
