import 'package:clock365/constants.dart';
import 'package:clock365/models/clock_user.dart';
import 'package:hive_flutter/hive_flutter.dart';


@HiveType(typeId: kOrganizationModel)
class OrganizationModel{
  @HiveField(0)
  String? organizationName = "";
  @HiveField(1)
  List<ClockUser> staff = [];
  @HiveField(2)
  List<ClockUser> visitors = [];
  @HiveField(3)
  List<ClockUser> staffSignedIn = [];
  @HiveField(4)
  List<ClockUser> visitorsSignedIn = [];
  @HiveField(5)
  List<ClockUser> users = [];
  @HiveField(6)
  String? colorCode = "";
  @HiveField(7)
  double? colorOpasity = 1.0;
  @HiveField(8)
  ClockUser? owner = ClockUser();

  OrganizationModel();


}