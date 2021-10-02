import 'package:clock365/constants.dart';
import 'package:clock365/models/clock_user.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'OrganizationModel.g.dart';

@HiveType(typeId: kOrganizationModel)
class OrganizationModel {
  @HiveField(0)
  String? organizationName = "";
  @HiveField(1)
  List<ClockUser>? staff = [];
  @HiveField(2)
  bool? visitorSignIn = true;
  @HiveField(3)
  List<ClockUser>? staffSignedIn = [];
  @HiveField(4)
  List<ClockUser>? visitorsSignedIn = [];
  @HiveField(5)
  bool? staffSignIn = true;
  @HiveField(6)
  String? colorCode = "";
  @HiveField(7)
  double? colorOpacity = 1.0;
  @HiveField(8)
  String? organizationId = "";
  @HiveField(9)
  String? createdBy = '';

  OrganizationModel({
    this.organizationName,
    this.colorCode,
    this.colorOpacity,
    this.organizationId,
    this.createdBy,
    this.staff,
    this.staffSignIn,
    this.staffSignedIn,
    this.visitorsSignedIn,
    this.visitorSignIn,
  });
  factory OrganizationModel.fromJson(Map<String, dynamic> json) {
    return OrganizationModel(
      colorCode: json["color_code"],
      colorOpacity: json["color_opacity"],
      createdBy: json["created_by"]["\$oid"],
      organizationId: json["_id"]["\$oid"],
      organizationName: json["name"],
      staff: json["staff"],
      staffSignIn: json["staff_sign_in"],
      staffSignedIn: json["staff_signed_in"],
      visitorSignIn: json["visitor_sign_in"],
      visitorsSignedIn: json["visitors_signed_in"],
    );
  }
}
