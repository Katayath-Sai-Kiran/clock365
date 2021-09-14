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
  String? login = '';
  @HiveField(5)
  String? jobTitle = '';

  ClockUser({this.id, this.name, this.website, this.isStaff, this.login, this.jobTitle});
}
