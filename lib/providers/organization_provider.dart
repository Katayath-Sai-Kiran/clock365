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
  List<ClockUser> currentOrganizationStaff = [];
  List<ClockUser> currentOrganizationVisitors = [];
  bool areStaffLoading = false;
  bool areVisitorsLoading = false;

  Future getCurrentorganization({required BuildContext context}) async {
    try {
      notifyListeners();
    } catch (error) {
      _customWidgets.failureToste(text: error.toString(), context: context);
    }
  }

  Future getCurrentOrganizationStaff(
      {required String orgId, required BuildContext context}) async {
    try {} catch (error) {}
  }

  Future getCurrentOrganizationSignedInStaff({
    required BuildContext context,
  }) async {
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
        currentOrganizationStaff = responseList
            .map((e) => ClockUser.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        Map message = jsonDecode(response.body);
        _customWidgets.failureToste(text: message["msg"], context: context);
        currentOrganizationStaff = [];
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
        "org_id", currentOrganization!.organizationName.toString()));
    try {
      http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        List responseList = jsonDecode(response.body);
        currentOrganizationVisitors = responseList
            .map((e) => ClockUser.fromJson(e as Map<String, dynamic>))
            .toList();
       
      } else {
        currentOrganizationVisitors = [];
        Map message = jsonDecode(response.body);
        _customWidgets.failureToste(text: message["msg"], context: context);
      }
    } catch (error) {
      currentOrganizationVisitors = [];


      _customWidgets.failureToste(text: error.toString(), context: context);
    }
  }
}
