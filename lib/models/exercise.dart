import 'package:hive/hive.dart';

part 'exercise.g.dart';

@HiveType(typeId: 0)
class Exercise {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final String equipment;

  const Exercise({
    required this.id,
    required this.name,
    required this.category,
    required this.equipment,
  });
}
