import 'package:clock365/constants.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'clock_user.g.dart';

@HiveType(typeId: kClockUserHiveType)
class ClockUser {
  @HiveField(0)
  String? id = '';
  @HiveField(1)
  String? name = '';
  @HiveField(2)
  String? website = '';
  @HiveField(3)
  bool? isStaff = false;
  @HiveField(4)
  String? email = '';
  @HiveField(5)
  String? jobTitle = '';
  @HiveField(6)
  List? organizations = [];

  ClockUser({
    this.id,
    this.name,
    this.website,
    this.isStaff,
    this.email,
    this.jobTitle,
    this.organizations,
  });

  factory ClockUser.fromJson(Map<String, dynamic> json) {
    return ClockUser(
      email: json["email"],
      id: json["_id"]["\$oid"],
      isStaff: json["isStaff"],
      jobTitle: json["job_title"],
      name: json["name"],
      organizations: json["organizations"],
      website: json["website"],
    );
  }
}
