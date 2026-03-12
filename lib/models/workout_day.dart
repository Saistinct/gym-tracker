// ✅ Both hive AND exercise_instance are imported here.
// The .g.dart part file inherits these imports automatically.
import 'package:hive/hive.dart';
import 'exercise_instance.dart';

part 'workout_day.g.dart';

@HiveType(typeId: 2)
class WorkoutDay extends HiveObject {
  @HiveField(0)
  int dayNumber;

  @HiveField(1)
  String title;

  @HiveField(2)
  bool isRestDay;

  @HiveField(3)
  DateTime? completionDate;

  @HiveField(4)
  List<ExerciseInstance> exercises;

  WorkoutDay({
    required this.dayNumber,
    required this.title,
    this.isRestDay = false,
    this.completionDate,
    List<ExerciseInstance>? exercises,
  }) : exercises = exercises ?? [];

  bool get isCompleted => completionDate != null;

  bool get completedToday {
    if (completionDate == null) return false;
    final now = DateTime.now();
    return completionDate!.year == now.year &&
        completionDate!.month == now.month &&
        completionDate!.day == now.day;
  }
}
