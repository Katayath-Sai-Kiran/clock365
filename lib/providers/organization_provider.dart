import 'package:clock365/constants.dart';
import 'package:clock365/models/OrganizationModel.dart';
import 'package:clock365/models/clock_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

class OrganizationProvider extends ChangeNotifier {
  OrganizationModel? currentOrganization;

  Future setCurrentOrganization(
      {required OrganizationModel updatedOrganization}) async {
    currentOrganization = updatedOrganization;

    notifyListeners();
    ClockUser user = Hive.box(kUserBox).get(kCurrentUserKey);
    user.currentOrganization = updatedOrganization;

    await Hive.box(kUserBox).put(kCurrentUserKey, user);
  }

  Future addStaffToCurrentOrganization() async {}

  Future getCurrentOrganization() async {
    String userId = Hive.box(kUserBox).get(kcurrentUserId);
    currentOrganization = Hive.box(kUserBox).get(userId)["currentOrganization"];
    notifyListeners();
  }
}
