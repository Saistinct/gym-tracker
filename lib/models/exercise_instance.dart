import 'package:hive/hive.dart';

part 'exercise_instance.g.dart';

@HiveType(typeId: 1)
class ExerciseInstance {
  @HiveField(0)
  String exerciseId;

  @HiveField(1)
  String exerciseName;

  @HiveField(2)
  double weight;

  @HiveField(3)
  int reps;

  @HiveField(4)
  int lastReps;

  @HiveField(5)
  double lastWeight;

  @HiveField(6)
  String category;

  @HiveField(7)
  String equipment;

  @HiveField(8, defaultValue: false)
  bool isCompleted;

  @HiveField(9, defaultValue: '')
  String notes;

  ExerciseInstance({
    required this.exerciseId,
    required this.exerciseName,
    this.weight = 45.0,
    this.reps = 0,
    this.lastReps = 0,
    this.lastWeight = 45.0,
    this.category = '',
    this.equipment = '',
    this.isCompleted = false,
    this.notes = '',
  });
}
