import 'dart:convert';

import 'package:clock365/customWidgets.dart';
import 'package:clock365/models/clock_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:clock365/constants.dart';
import 'package:http/http.dart' as http;
import 'package:clock365/models/OrganizationModel.dart';

class ClockUserProvider extends ChangeNotifier {
  final CustomWidgets _customWidgets = CustomWidgets();

  List? organisations = [];
  List<ClockUser> staff = [];
  ClockUser? currentUser;
  List<OrganizationModel>? currentUserOrganizations = [];
  int attendencePresentDays = 0;

  //user in reseting password to show progress
  int verifyingStatus = 1;

  //update verifying status when resetting password
  void updateVerifyingStatus({required int updatedStatus}) {
    verifyingStatus = updatedStatus;
    notifyListeners();
  }

  //add staff to selected organization temp
  Future addStaff({required newStaffMember}) async {
    staff.add(newStaffMember);
    notifyListeners();
  }

  //delete staff from selected organization temp
  Future deleteStaff({required int staffIndex}) async {
    staff.removeAt(staffIndex);
    notifyListeners();
  }

//add organizations to current user temp
  Future updateCurrentUserSites(
      {required OrganizationModel addedOrganizarion}) async {
    currentUserOrganizations!.add(addedOrganizarion);
    notifyListeners();
  }

  Future getCurrentUserSites({required BuildContext context}) async {
    final ClockUser currentUser = await Hive.box(kUserBox).get(kCurrentUserKey);

    try {
      http.Response response = await http.get(Uri.parse(kGetCurrentSitesEndPoint
          .replaceFirst("user_id", currentUser.id.toString())));

      if (response.statusCode == 200) {
        List currentSites = jsonDecode(response.body);
        List<OrganizationModel> currentOrganizations = currentSites
            .map((organization) => OrganizationModel.fromJson(
                organization as Map<String, dynamic>))
            .toList();
        currentUserOrganizations = currentOrganizations;
      } else {
        Map message = jsonDecode(response.body);
        _customWidgets.failureToste(text: message["msg"], context: context);
      }
      notifyListeners();
    } catch (error) {
      _customWidgets.failureToste(text: error.toString(), context: context);
    }
  }

  Future getUserAttendenceData({required BuildContext context}) async {
    try {
      final ClockUser currentUser =
          await Hive.box(kUserBox).get(kCurrentUserKey);
      final OrganizationModel? currentOrganization =
          currentUser.currentOrganization;
      final Uri uri = Uri.parse(kGetAttendenceDetailsEndPoint
          .replaceFirst("user_id", currentUser.id.toString())
          .toString()
          .replaceAll(
              "org_value", currentOrganization!.organizationId.toString()));
 
      http.Response response = await http.get(uri);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        attendencePresentDays = data["totalDaysPresent"];
      } else {
        _customWidgets.failureToste(
            text: "Something went wrong !", context: context);
      }
      notifyListeners();
    } catch (error) {
      _customWidgets.failureToste(text: error.toString(), context: context);
    }
  }
}
