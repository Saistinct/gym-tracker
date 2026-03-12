// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProgressLogAdapter extends TypeAdapter<ProgressLog> {
  @override
  final int typeId = 4;

  @override
  ProgressLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProgressLog(
      weekNumber: fields[0] as int,
      date: fields[1] as DateTime,
      exerciseId: fields[2] as String,
      exerciseName: fields[3] as String,
      weight: fields[4] as double,
      reps: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ProgressLog obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.weekNumber)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.exerciseId)
      ..writeByte(3)
      ..write(obj.exerciseName)
      ..writeByte(4)
      ..write(obj.weight)
      ..writeByte(5)
      ..write(obj.reps);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProgressLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
