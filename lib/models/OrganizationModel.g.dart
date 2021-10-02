// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'OrganizationModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrganizationModelAdapter extends TypeAdapter<OrganizationModel> {
  @override
  final int typeId = 3;

  @override
  OrganizationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrganizationModel(
      organizationName: fields[0] as String?,
      colorCode: fields[6] as String?,
      colorOpacity: fields[7] as double?,
      organizationId: fields[8] as String?,
      createdBy: fields[9] as String?,
      staff: (fields[1] as List?)?.cast<ClockUser>(),
      staffSignIn: fields[5] as bool?,
      staffSignedIn: (fields[3] as List?)?.cast<ClockUser>(),
      visitorsSignedIn: (fields[4] as List?)?.cast<ClockUser>(),
      visitorSignIn: fields[2] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, OrganizationModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.organizationName)
      ..writeByte(1)
      ..write(obj.staff)
      ..writeByte(2)
      ..write(obj.visitorSignIn)
      ..writeByte(3)
      ..write(obj.staffSignedIn)
      ..writeByte(4)
      ..write(obj.visitorsSignedIn)
      ..writeByte(5)
      ..write(obj.staffSignIn)
      ..writeByte(6)
      ..write(obj.colorCode)
      ..writeByte(7)
      ..write(obj.colorOpacity)
      ..writeByte(8)
      ..write(obj.organizationId)
      ..writeByte(9)
      ..write(obj.createdBy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrganizationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
