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

  Future getCurrentUserSites({required BuildContext context}) async {
    final ClockUser clockUser = Hive.box(kUserBox).get(kCurrentUserKey);
    print(clockUser.id.toString());

    try {
      http.Response response = await http.get(Uri.parse(kGetCurrentSitesEndPoint
          .replaceFirst("user_id", clockUser.id.toString())));

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

  Future deleteStaff({required int staffIndex}) async {
    staff.removeAt(staffIndex);
    notifyListeners();
  }
}
