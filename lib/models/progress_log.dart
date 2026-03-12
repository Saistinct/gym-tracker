import 'package:hive/hive.dart';

part 'progress_log.g.dart';

@HiveType(typeId: 4)
class ProgressLog extends HiveObject {
  @HiveField(0)
  int weekNumber;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  String exerciseId;

  @HiveField(3)
  String exerciseName;

  @HiveField(4)
  double weight;

  @HiveField(5)
  int reps;

  ProgressLog({
    required this.weekNumber,
    required this.date,
    required this.exerciseId,
    required this.exerciseName,
    required this.weight,
    required this.reps,
  });
}
