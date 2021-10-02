// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clock_user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClockUserAdapter extends TypeAdapter<ClockUser> {
  @override
  final int typeId = 1;

  @override
  ClockUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClockUser(
      id: fields[0] as String?,
      name: fields[1] as String?,
      website: fields[2] as String?,
      isStaff: fields[3] as bool?,
      email: fields[4] as String?,
      jobTitle: fields[5] as String?,
      organizations: (fields[6] as List?)?.cast<OrganizationModel>(),
      currentOrganization: fields[7] as OrganizationModel?,
    );
  }

  @override
  void write(BinaryWriter writer, ClockUser obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.website)
      ..writeByte(3)
      ..write(obj.isStaff)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.jobTitle)
      ..writeByte(6)
      ..write(obj.organizations)
      ..writeByte(7)
      ..write(obj.currentOrganization);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClockUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
