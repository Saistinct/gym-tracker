// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'body_measurements.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BodyMeasurementsAdapter extends TypeAdapter<BodyMeasurements> {
  @override
  final int typeId = 4;

  @override
  BodyMeasurements read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BodyMeasurements(
      preferredUnit: fields[0] as int,
      heightCm: fields[1] as double,
      weightKg: fields[2] as double,
      measurementsCm: (fields[3] as Map?)?.cast<String, double>(),
    );
  }

  @override
  void write(BinaryWriter writer, BodyMeasurements obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.preferredUnit)
      ..writeByte(1)
      ..write(obj.heightCm)
      ..writeByte(2)
      ..write(obj.weightKg)
      ..writeByte(3)
      ..write(obj.measurementsCm);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BodyMeasurementsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
