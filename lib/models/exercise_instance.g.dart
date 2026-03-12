// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_instance.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExerciseInstanceAdapter extends TypeAdapter<ExerciseInstance> {
  @override
  final int typeId = 1;

  @override
  ExerciseInstance read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExerciseInstance(
      exerciseId: fields[0] as String,
      exerciseName: fields[1] as String,
      weight: fields[2] as double,
      reps: fields[3] as int,
      lastReps: fields[4] as int,
      lastWeight: fields[5] as double,
      category: fields[6] as String,
      equipment: fields[7] as String,
      isCompleted: fields[8] == null ? false : fields[8] as bool,
      notes: fields[9] == null ? '' : fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ExerciseInstance obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.exerciseId)
      ..writeByte(1)
      ..write(obj.exerciseName)
      ..writeByte(2)
      ..write(obj.weight)
      ..writeByte(3)
      ..write(obj.reps)
      ..writeByte(4)
      ..write(obj.lastReps)
      ..writeByte(5)
      ..write(obj.lastWeight)
      ..writeByte(6)
      ..write(obj.category)
      ..writeByte(7)
      ..write(obj.equipment)
      ..writeByte(8)
      ..write(obj.isCompleted)
      ..writeByte(9)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseInstanceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
