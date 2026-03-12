// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_report.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProgressReportAdapter extends TypeAdapter<ProgressReport> {
  @override
  final int typeId = 5;

  @override
  ProgressReport read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProgressReport(
      milestoneWeek: fields[0] as int,
      dateGenerated: fields[1] as DateTime,
      reportLines: (fields[2] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ProgressReport obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.milestoneWeek)
      ..writeByte(1)
      ..write(obj.dateGenerated)
      ..writeByte(2)
      ..write(obj.reportLines);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProgressReportAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
