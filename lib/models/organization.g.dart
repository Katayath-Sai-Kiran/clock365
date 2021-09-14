// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrganizationAdapter extends TypeAdapter<Organization> {
  @override
  final int typeId = 0;

  @override
  Organization read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Organization()
      ..id = fields[0] as String
      ..name = fields[1] as String
      ..staffSignIn = fields[2] as bool
      ..visitorsSignIn = fields[3] as bool
      ..takeVisitorPhotos = fields[4] as bool
      ..takeStaffPhotos = fields[5] as bool
      ..printVisitorLabels = fields[6] as bool
      ..askVisitorsWhoTheyAreSeeing = fields[7] as bool
      ..askPhoneNumber = fields[8] as bool
      ..askEmail = fields[9] as bool
      ..askActivities = fields[10] as bool
      ..simplifySignOut = fields[11] as bool
      ..touchlessSignIn = fields[12] as bool
      ..animateSignInButton = fields[13] as bool
      ..rollCallButton = fields[14] as bool
      ..showAttendees = fields[15] as bool
      ..showAnnouncements = fields[16] as bool
      ..staffMembers = (fields[17] as List).cast<ClockUser>()
      ..visitors = (fields[18] as List).cast<ClockUser>()
      ..staffSignedIn = (fields[19] as List).cast<ClockUser>()
      ..visitorsSignedIn = (fields[20] as List).cast<ClockUser>()
      ..owner = fields[21] as ClockUser?;
  }

  @override
  void write(BinaryWriter writer, Organization obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.staffSignIn)
      ..writeByte(3)
      ..write(obj.visitorsSignIn)
      ..writeByte(4)
      ..write(obj.takeVisitorPhotos)
      ..writeByte(5)
      ..write(obj.takeStaffPhotos)
      ..writeByte(6)
      ..write(obj.printVisitorLabels)
      ..writeByte(7)
      ..write(obj.askVisitorsWhoTheyAreSeeing)
      ..writeByte(8)
      ..write(obj.askPhoneNumber)
      ..writeByte(9)
      ..write(obj.askEmail)
      ..writeByte(10)
      ..write(obj.askActivities)
      ..writeByte(11)
      ..write(obj.simplifySignOut)
      ..writeByte(12)
      ..write(obj.touchlessSignIn)
      ..writeByte(13)
      ..write(obj.animateSignInButton)
      ..writeByte(14)
      ..write(obj.rollCallButton)
      ..writeByte(15)
      ..write(obj.showAttendees)
      ..writeByte(16)
      ..write(obj.showAnnouncements)
      ..writeByte(17)
      ..write(obj.staffMembers)
      ..writeByte(18)
      ..write(obj.visitors)
      ..writeByte(19)
      ..write(obj.staffSignedIn)
      ..writeByte(20)
      ..write(obj.visitorsSignedIn)
      ..writeByte(21)
      ..write(obj.owner);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrganizationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
