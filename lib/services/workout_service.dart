import 'package:hive_flutter/hive_flutter.dart';
import '../models/workout_day.dart';
import '../models/exercise_instance.dart';
import '../models/body_measurements.dart';
import '../models/user_profile.dart';
import '../models/progress_log.dart';
import '../models/progress_report.dart';

class WorkoutService {
  static const String _boxName = 'workoutDays';
  static const String _profileBoxName = 'userProfile';
  static const String _bodyBoxName = 'bodyMeasurements';
  static const String _progressLogBoxName = 'progressLogs';
  static const String _progressReportBoxName = 'progressReports';

  late Box<WorkoutDay> _box;
  late Box<UserProfile> _profileBox;
  late Box<BodyMeasurements> _bodyBox;
  late Box<ProgressLog> _logBox;
  late Box<ProgressReport> _reportBox;

  Future<void> init() async {
    try {
      _box = await Hive.openBox<WorkoutDay>(_boxName);
      _profileBox = await Hive.openBox<UserProfile>(_profileBoxName);
      _bodyBox = await Hive.openBox<BodyMeasurements>(_bodyBoxName);
      _logBox = await Hive.openBox<ProgressLog>(_progressLogBoxName);
      _reportBox = await Hive.openBox<ProgressReport>(_progressReportBoxName);
      if (_box.isEmpty) {
        await _seedDefaultDays();
      }
      if (_bodyBox.isEmpty) {
        await _bodyBox.add(BodyMeasurements());
      }
    } catch (e) {
      throw Exception('Failed to initialize workout data: $e');
    }
  }

  // ── User Profile ────────────────────────────────────────

  bool get hasUsername => _profileBox.isNotEmpty;

  UserProfile _getProfile() => _profileBox.getAt(0)!;

  String getUsername() => hasUsername ? _getProfile().username : '';

  int getWeekCount() => hasUsername ? _getProfile().weekCount : 0;

  int getCurrentDayIndex() => hasUsername ? _getProfile().currentDayIndex : 0;

  Future<void> setUsername(String name) async {
    if (hasUsername) {
      final profile = _getProfile();
      profile.username = name;
      await profile.save();
    } else {
      // Start weekCount at 1 (first week)
      await _profileBox.add(UserProfile(username: name, weekCount: 1));
    }
  }

  Future<void> setCurrentDayIndex(int index) async {
    if (hasUsername) {
      final profile = _getProfile();
      profile.currentDayIndex = index;
      await profile.save();
    }
  }

  Future<void> _incrementWeekCount() async {
    if (hasUsername) {
      final profile = _getProfile();
      profile.weekCount += 1;
      await profile.save();
    }
  }

  // ── Workout Days ────────────────────────────────────────

  Future<void> _seedDefaultDays() async {
    final defaults = [
      WorkoutDay(dayNumber: 1, title: 'Chest & Back'),
      WorkoutDay(dayNumber: 2, title: 'Legs'),
      WorkoutDay(dayNumber: 3, title: 'Shoulders & Arms'),
      WorkoutDay(dayNumber: 4, title: 'Rest Day', isRestDay: true),
      WorkoutDay(dayNumber: 5, title: 'Chest & Back'),
      WorkoutDay(dayNumber: 6, title: 'Legs'),
      WorkoutDay(dayNumber: 7, title: 'Rest Day', isRestDay: true),
    ];
    await _box.addAll(defaults);
  }

  List<WorkoutDay> getAllDays() => _box.values.toList();

  WorkoutDay getDayAt(int index) => _box.getAt(index)!;

  int getNextIncompleteDayIndex() {
    final days = getAllDays();
    for (int i = 0; i < days.length; i++) {
      if (!days[i].isCompleted && !days[i].isRestDay) return i;
    }
    return -1;
  }

  /// Returns the first day index that hasn't been completed yet,
  /// including rest days — so the dashboard shows rest days as current.
  int _firstIncompleteDayIndex() {
    final days = getAllDays();
    for (int i = 0; i < days.length; i++) {
      if (!days[i].isCompleted) return i;
    }
    return -1;
  }

  bool get allDaysCompleted => getNextIncompleteDayIndex() == -1;

  Future<void> updateDayTitle(int index, String title) async {
    final day = _box.getAt(index)!;
    day.title = title;
    await day.save();
  }

  ExerciseInstance _cloneExercise(ExerciseInstance ex) => ExerciseInstance(
        exerciseId: ex.exerciseId,
        exerciseName: ex.exerciseName,
        weight: ex.weight,
        reps: ex.reps,
        lastReps: ex.lastReps,
        lastWeight: ex.lastWeight,
        category: ex.category,
        equipment: ex.equipment,
        isCompleted: ex.isCompleted,
        notes: ex.notes,
      );

  WorkoutDay _cloneDayWithNumber(WorkoutDay day, int dayNumber) => WorkoutDay(
        dayNumber: dayNumber,
        title: day.title,
        isRestDay: day.isRestDay,
        completionDate: day.completionDate,
        exercises: day.exercises.map(_cloneExercise).toList(),
      );

  Future<void> reorderDays(int oldIndex, int newIndex) async {
    if (oldIndex == newIndex) return;
    if (oldIndex < 0 || oldIndex >= _box.length) return;
    if (newIndex < 0 || newIndex > _box.length) return;

    if (oldIndex < newIndex) newIndex -= 1;

    final days = getAllDays();
    final moved = days.removeAt(oldIndex);
    days.insert(newIndex, moved);

    final rebuilt = <WorkoutDay>[];
    for (int i = 0; i < days.length; i++) {
      rebuilt.add(_cloneDayWithNumber(days[i], i + 1));
    }

    await _box.clear();
    await _box.addAll(rebuilt);

    // After a reorder, point to the first incomplete day (rest days included).
    final next = _firstIncompleteDayIndex();
    await setCurrentDayIndex(next >= 0 ? next : 0);
  }

  Future<void> setRestDay(int index, {required bool isRestDay}) async {
    final day = _box.getAt(index)!;
    day.isRestDay = isRestDay;
    if (isRestDay) {
      day.title = 'Rest Day';
    } else if (day.title == 'Rest Day') {
      day.title = 'Workout Day';
    }
    await day.save();
  }

  // ── Exercise Management ─────────────────────────────────

  Future<void> addExerciseToDay(int dayIndex, ExerciseInstance exercise) async {
    final day = _box.getAt(dayIndex)!;
    day.exercises.add(exercise);
    await day.save();
  }

  Future<void> removeExerciseFromDay(int dayIndex, int exerciseIndex) async {
    final day = _box.getAt(dayIndex)!;
    day.exercises.removeAt(exerciseIndex);
    await day.save();
  }

  Future<void> updateExerciseWeight(
      int dayIndex, int exerciseIndex, double weight) async {
    final day = _box.getAt(dayIndex)!;
    day.exercises[exerciseIndex].weight = weight;
    await day.save();
  }

  Future<void> updateExerciseReps(
      int dayIndex, int exerciseIndex, int reps) async {
    final day = _box.getAt(dayIndex)!;
    day.exercises[exerciseIndex].reps = reps;
    await day.save();
  }

  Future<void> levelUpExercise(int dayIndex, int exerciseIndex) async {
    final day = _box.getAt(dayIndex)!;
    final ex = day.exercises[exerciseIndex];
    ex.lastWeight = ex.weight;
    ex.lastReps = ex.reps;
    ex.weight += 5.0;
    ex.reps = 0;
    await day.save();
  }

  /// Find the latest weight/reps for an exercise across all days.
  /// Used when re-adding a previously removed exercise.
  ExerciseInstance? getLatestExerciseState(String exerciseId) {
    ExerciseInstance? latest;
    for (int i = 0; i < _box.length; i++) {
      final day = _box.getAt(i)!;
      for (final ex in day.exercises) {
        if (ex.exerciseId == exerciseId) {
          latest = ex; // keep overwriting — last found is latest
        }
      }
    }
    return latest;
  }

  // ── Sync Exercise Across Days (on completion only) ──────

  Future<void> _syncExerciseAcrossDays(
      int completedDayIndex, List<ExerciseInstance> completedExercises) async {
    for (int i = 0; i < _box.length; i++) {
      if (i == completedDayIndex) continue;
      final day = _box.getAt(i)!;
      bool changed = false;
      for (final ex in day.exercises) {
        for (final completed in completedExercises) {
          if (ex.exerciseId == completed.exerciseId) {
            ex.weight = completed.weight;
            ex.reps = completed.reps;
            ex.lastWeight = completed.lastWeight;
            ex.lastReps = completed.lastReps;
            changed = true;
          }
        }
      }
      if (changed) await day.save();
    }
  }

  // ── Mark Day Done + Summary ─────────────────────────────

  /// Returns null if no exercises, otherwise returns a summary list.
  Future<List<Map<String, dynamic>>?> markDayDone(int index) async {
    print('DEBUG: markDayDone started for day index $index');
    final day = _box.getAt(index)!;
    
    // Allow empty days to be marked as done
    if (day.exercises.isEmpty) {
      print('DEBUG: Day is empty, marking done directly');
      day.completionDate = DateTime.now();
      await day.save();

      // Advance to the very next day sequentially (may be a rest day)
      final nextSeqIndex = index + 1;
      if (nextSeqIndex < _box.length) {
        await setCurrentDayIndex(nextSeqIndex);
      } else {
        final nextWorkoutIndex = getNextIncompleteDayIndex();
        if (nextWorkoutIndex >= 0) await setCurrentDayIndex(nextWorkoutIndex);
      }

      if (allDaysCompleted) {
        final oldWeek = getWeekCount();
        await _incrementWeekCount();
        if (oldWeek == 26 || oldWeek == 52) {
          await _generateMilestoneReport(oldWeek);
        }
        await resetProgram();
      }
      return [];
    }

    print('DEBUG: Building summary');
    // Build summary before overwriting lastReps/lastWeight
    final summary = <Map<String, dynamic>>[];
    for (final ex in day.exercises) {
      final lastWeight = ex.lastWeight.toDouble();
      final lastReps = ex.lastReps.toInt();
      final weight = ex.weight.toDouble();
      final reps = ex.reps.toInt();
      
      summary.add({
        'name': ex.exerciseName,
        'weight': weight,
        'reps': reps,
        'lastWeight': lastWeight,
        'lastReps': lastReps,
        'weightDelta': weight - lastWeight,
        'repsDelta': reps - lastReps,
      });

      // ---- FEATURE 3: Log Progress ----
      final log = ProgressLog(
        weekNumber: getWeekCount(),
        date: DateTime.now(),
        exerciseId: ex.exerciseId,
        exerciseName: ex.exerciseName,
        weight: ex.weight,
        reps: ex.reps,
      );
      await _logBox.add(log);
    }

    print('DEBUG: Saving lastReps/lastWeight and completionDate');
    // Save current as last
    for (final ex in day.exercises) {
      ex.lastReps = ex.reps;
      ex.lastWeight = ex.weight;
    }
    day.completionDate = DateTime.now();
    await day.save();

    print('DEBUG: Syncing across days');
    // Sync this exercise state to same exercises on other days
    await _syncExerciseAcrossDays(index, day.exercises);

    print('DEBUG: Advancing day index');
    // Advance to the very next day sequentially (may be a rest day)
    final nextSeqIndex = index + 1;
    if (nextSeqIndex < _box.length) {
      await setCurrentDayIndex(nextSeqIndex);
    } else {
      final nextWorkoutIndex = getNextIncompleteDayIndex();
      if (nextWorkoutIndex >= 0) await setCurrentDayIndex(nextWorkoutIndex);
    }

    // Check if all days completed → increment week counter + auto-reset
    print('DEBUG: Checking if all days completed');
    if (allDaysCompleted) {
      print('DEBUG: All days completed, generating reports and resetting');
      final oldWeek = getWeekCount();
      await _incrementWeekCount();

      // Feature 3: Generate 6 Month (26 weeks) or 1 Year (52 weeks) Report
      if (oldWeek == 26 || oldWeek == 52) {
        await _generateMilestoneReport(oldWeek);
      }

      await resetProgram();
    }

    print('DEBUG: markDayDone finished successfully');
    return summary;
  }

  Future<void> _generateMilestoneReport(int milestoneWeek) async {
    // A quick way to get Week 1 data
    final logs = _logBox.values.toList();
    final week1Logs = logs.where((l) => l.weekNumber == 1).toList();
    final currentLogs =
        logs.where((l) => l.weekNumber == milestoneWeek).toList();

    List<String> lines = [];
    lines.add('Looking back at how far you have come since Week 1!');

    // Simplistic comparison for each exercise from week 1
    for (final w1 in week1Logs) {
      // Find matching log in the current milestone week
      final currentMatch =
          currentLogs.where((l) => l.exerciseId == w1.exerciseId).lastOrNull;
      if (currentMatch != null) {
        final weightDiff = currentMatch.weight - w1.weight;
        if (weightDiff >= 0) {
          lines.add(
              '${w1.exerciseName} — Week 1: ${w1.weight} lbs, Week $milestoneWeek: ${currentMatch.weight} lbs. Strength Increase: +$weightDiff lbs.');
        } else {
          lines.add(
              '${w1.exerciseName} — Week 1: ${w1.weight} lbs, Week $milestoneWeek: ${currentMatch.weight} lbs.');
        }
      }
    }

    if (lines.length == 1) {
      lines.add('Keep tracking to see your strength increase over time!');
    }

    final report = ProgressReport(
      milestoneWeek: milestoneWeek,
      dateGenerated: DateTime.now(),
      reportLines: lines,
    );
    await _reportBox.add(report);
  }

  List<ProgressReport> getProgressReports() =>
      _reportBox.values.toList().reversed.toList();

  /// Compares the current week's logs vs last week's logs per exercise.
  /// Sources exercises from ALL non-rest workout days (the full plan), then
  /// overlays log data for this week and last week.
  List<Map<String, dynamic>> getWeeklyComparison() {
    final currentWeek = getWeekCount();
    final lastWeek = currentWeek - 1;
    final allLogs = _logBox.values.toList();

    final Map<String, ProgressLog> thisWeekMap = {};
    final Map<String, ProgressLog> lastWeekMap = {};
    for (final log in allLogs) {
      if (log.weekNumber == currentWeek) {
        thisWeekMap[log.exerciseId] = log;
      } else if (log.weekNumber == lastWeek) {
        lastWeekMap[log.exerciseId] = log;
      }
    }

    final Map<String, String> exerciseNames = {};
    for (int i = 0; i < _box.length; i++) {
      final day = _box.getAt(i)!;
      if (day.isRestDay) continue;
      for (final ex in day.exercises) {
        exerciseNames.putIfAbsent(ex.exerciseId, () => ex.exerciseName);
      }
    }

    for (final log in allLogs) {
      if (log.weekNumber == currentWeek || log.weekNumber == lastWeek) {
        exerciseNames.putIfAbsent(log.exerciseId, () => log.exerciseName);
      }
    }

    if (exerciseNames.isEmpty) return [];

    final results = <Map<String, dynamic>>[];
    for (final entry in exerciseNames.entries) {
      final id = entry.key;
      final name = entry.value;
      final thisLog = thisWeekMap[id];
      final lastLog = lastWeekMap[id];

      final thisWeight = thisLog?.weight ?? 0.0;
      final thisReps = thisLog?.reps ?? 0;
      final lastWeight = lastLog?.weight ?? 0.0;
      final lastReps = lastLog?.reps ?? 0;

      results.add({
        'exerciseName': name,
        'thisWeight': thisWeight,
        'thisReps': thisReps,
        'lastWeight': lastWeight,
        'lastReps': lastReps,
        'weightDelta': thisWeight - lastWeight,
        'repsDelta': thisReps - lastReps,
        'hasThisWeek': thisLog != null,
        'hasLastWeek': lastLog != null,
      });
    }

    results.sort((a, b) {
      final aThis = a['hasThisWeek'] as bool;
      final bThis = b['hasThisWeek'] as bool;
      final aLast = a['hasLastWeek'] as bool;
      final bLast = b['hasLastWeek'] as bool;
      if (aThis && !bThis) return -1;
      if (!aThis && bThis) return 1;
      if (aLast && !bLast) return -1;
      if (!aLast && bLast) return 1;
      return (a['exerciseName'] as String).compareTo(b['exerciseName'] as String);
    });

    return results;
  }

  Future<void> resetProgram() async {
    for (int i = 0; i < _box.length; i++) {
      final day = _box.getAt(i)!;
      day.completionDate = null;
      // Feature 5/1: Reset reps to 0 for next session but NOT lastReps, and reset isCompleted
      for (final ex in day.exercises) {
        ex.reps = 0;
        ex.isCompleted = false;
      }
      await day.save();
    }
    await setCurrentDayIndex(0);
  }

  /// Unmarks a completed day — clears completionDate and resets exercise state.
  Future<void> unmarkDayDone(int index) async {
    final day = _box.getAt(index)!;
    day.completionDate = null;
    for (final ex in day.exercises) {
      ex.reps = 0;
      ex.isCompleted = false;
    }
    await day.save();

    // Recompute the current day index so the home screen points correctly
    final next = _firstIncompleteDayIndex();
    await setCurrentDayIndex(next >= 0 ? next : 0);
  }

  // ── Body Measurements ────────────────────────────────────

  BodyMeasurements getBodyMeasurements() => _bodyBox.getAt(0)!;

  Future<void> setPreferredBodyUnit(int unit) async {
    final b = getBodyMeasurements();
    b.preferredUnit = unit;
    await b.save();
  }

  Future<void> setHeightCm(double cm) async {
    final b = getBodyMeasurements();
    b.heightCm = cm.clamp(0, 300).toDouble();
    await b.save();
  }

  Future<void> setWeightKg(double kg) async {
    final b = getBodyMeasurements();
    b.weightKg = kg.clamp(0, 500).toDouble();
    await b.save();
  }

  Future<void> setMeasurementCm(String part, double cm) async {
    final b = getBodyMeasurements();
    b.measurementsCm[part] = cm.clamp(0, 300).toDouble();
    await b.save();
  }
}