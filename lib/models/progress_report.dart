import 'package:hive/hive.dart';

part 'progress_report.g.dart';

@HiveType(typeId: 5)
class ProgressReport extends HiveObject {
  @HiveField(0)
  int milestoneWeek; // e.g. 26 or 52

  @HiveField(1)
  DateTime dateGenerated;

  // A serialized text report or a map
  @HiveField(2)
  List<String> reportLines;

  ProgressReport({
    required this.milestoneWeek,
    required this.dateGenerated,
    required this.reportLines,
  });
}
