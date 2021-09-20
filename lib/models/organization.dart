import 'package:clock365/constants.dart';
import 'package:clock365/models/clock_user.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'organization.g.dart';

@HiveType(typeId: kOrgHiveType)
class Organization {
  @HiveField(0)
  String? id = '';
  @HiveField(1)
  String? name = '';
  @HiveField(2)
  bool? staffSignIn = true;
  @HiveField(3)
  bool visitorsSignIn = false;
  @HiveField(4)
  bool takeVisitorPhotos = true;
  @HiveField(5)
  bool takeStaffPhotos = true;
  @HiveField(6)
  bool printVisitorLabels = true;
  @HiveField(7)
  bool? askVisitorsWhoTheyAreSeeing = false;
  @HiveField(8)
  bool? askPhoneNumber = false;
  @HiveField(9)
  bool? askEmail = false;
  @HiveField(10)
  bool? askActivities = false;
  @HiveField(11)
  bool? simplifySignOut = false;
  @HiveField(12)
  bool? touchlessSignIn = false;
  @HiveField(13)
  bool? animateSignInButton = false;
  @HiveField(14)
  bool? rollCallButton = false;
  @HiveField(15)
  bool? showAttendees = false;
  @HiveField(16)
  bool? showAnnouncements = false;
  @HiveField(17)
  List<ClockUser>? staffMembers = [];
  @HiveField(18)
  List<ClockUser>? visitors = [];
  @HiveField(19)
  List<ClockUser>? staffSignedIn = [];
  @HiveField(20)
  List<ClockUser>? visitorsSignedIn = [];
  @HiveField(21)
  ClockUser? owner;

  Organization({
    this.id,
    this.animateSignInButton,
    this.askActivities,
    this.askEmail,
    this.askPhoneNumber,
    this.askVisitorsWhoTheyAreSeeing,
    this.name,
    this.owner,
  });
}
