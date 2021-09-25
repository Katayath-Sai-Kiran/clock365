import 'package:clock365/models/clock_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:clock365/constants.dart';

class ClockUserProvider extends ChangeNotifier {
  String? userName;

  List? organisations = [];
  List<ClockUser> staff = [];
  ClockUser? owner = ClockUser();

  Future setOwner({required ClockUser updatedUser}) async {
    owner = updatedUser;
    notifyListeners();
  }

  Future getCurrentUser() async {
    try {
      owner = Hive.box<ClockUser>(kClockUserBox).get(kCurrentUserKey);

      print("called");
    } catch (error) {
      print(error);
    }
    notifyListeners();
  }

  Future addStaff({required newStaffMember}) async {
    staff.add(newStaffMember);
    notifyListeners();
  }

  Future deleteStaff({required int staffIndex}) async {
    staff.removeAt(staffIndex);
    notifyListeners();
  }
}
