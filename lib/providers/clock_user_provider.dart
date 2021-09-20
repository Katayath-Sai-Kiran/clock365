import 'package:clock365/models/clock_user.dart';
import 'package:flutter/cupertino.dart';

class ClockUserProvider extends ChangeNotifier {
  String? userName;
  String? mail;
  String? password;
  String? organization;
  String? jobTitle;
  String? website;
  Color pColor = Color(0xFF6756D8);
  int selectedIndex = 0;
  List? organisations = [];
  List<ClockUser> staff = [];

  updateIndex({required int index, required Color color}) {
    selectedIndex = index;
    pColor = color;

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

  Future setNameConpanyAndWebsite({
    required String? updatedName,
    required String? updatedCompany,
    required String? updatedWebsite,
  }) async {
    userName = updatedName;
    organization = updatedCompany;
    website = updatedWebsite;
    organisations?.add(updatedCompany);

    notifyListeners();
  }

  Future addOrganizations({required String newOrganization}) async {
    organisations?.add(newOrganization);
    notifyListeners();
  }

  Future setMailAndJobTitle({
    required String updatedMail,
    required String updatedJobTitle,
  }) async {
    mail = updatedMail;
    jobTitle = updatedJobTitle;
    notifyListeners();
  }

  Future set({required String updatedMail}) async {
    mail = updatedMail;
    notifyListeners();
  }

  Future setMail({required String? updatedMail}) async {
    mail = updatedMail;
    notifyListeners();
  }

  Future setPassword({required String updatedPassword}) async {
    password = updatedPassword;
    notifyListeners();
  }


}
