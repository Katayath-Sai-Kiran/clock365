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

  
  int verifyingStatus = 1;

  void updateVerifyingStatus({required int updatedStatus}) {
    verifyingStatus = updatedStatus;
    notifyListeners();
  }

  Future addStaff({required newStaffMember}) async {
    staff.add(newStaffMember);
    notifyListeners();
  }

  Future getCurrentUser({required BuildContext context}) async {
    try {
      notifyListeners();
    } catch (error) {
      _customWidgets.failureToste(text: error.toString(), context: context);
    }
  }

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
        currentUserOrganizations = [];
        _customWidgets.failureToste(text: message["msg"], context: context);
      }
      notifyListeners();
    } catch (error) {
      currentUserOrganizations = [];
      _customWidgets.failureToste(text: error.toString(), context: context);
      notifyListeners();
    }
  }

  Future getUserAttendenceData({required BuildContext context}) async {
    try {
      final ClockUser currentUser =
          await Hive.box(kUserBox).get(kCurrentUserKey);
      final OrganizationModel? currentOrganization =
          currentUser.currentOrganization;
      print(
          "urk is ${kGetAttendenceDetailsEndPoint.replaceFirst("user_id", currentUser.id.toString()).toString().replaceAll("org_value", currentOrganization!.organizationId.toString())}");
      final Uri uri = Uri.parse(kGetAttendenceDetailsEndPoint
          .replaceFirst("user_id", currentUser.id.toString())
          .toString()
          .replaceAll(
              "org_value", currentOrganization.organizationId.toString()));
      http.Response response = await http.get(uri);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        attendencePresentDays = data["totalDaysPresent"];
        notifyListeners();
      } else {
        //Map message = jsonDecode(response.body);
        print(response.body);
        _customWidgets.failureToste(
            text: "Something went wrong", context: context);
      }
    } catch (error) {
      print(error.toString());
      //_customWidgets.failureToste(text: error.toString(), context: context);
    }
  }

  Future deleteStaff({required int staffIndex}) async {
    staff.removeAt(staffIndex);
    notifyListeners();
  }
}
