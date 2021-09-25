import 'package:clock365/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

class OrganizationProvider extends ChangeNotifier {
  Map? currentOrganization;

  Future setCurrentOrganization({required Map updatedOrganization}) async {
    print(updatedOrganization);
    currentOrganization = updatedOrganization;

    notifyListeners();

    final currentUserID = await Hive.box(kUserBox).get(kcurrentUserId);

    Map userData = Hive.box(kUserBox).get(currentUserID);
    userData.update("currentOrganization", (value) => updatedOrganization);
    await Hive.box(kUserBox).put(currentUserID, userData);
  }

  Future addStaffToCurrentOrganization() async {}

  Future getCurrentOrganization() async {
    String userId = Hive.box(kUserBox).get(kcurrentUserId);
    currentOrganization = Hive.box(kUserBox).get(userId)["currentOrganization"];
    notifyListeners();
  }
}
