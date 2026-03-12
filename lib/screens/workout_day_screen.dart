import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/workout_day.dart';
import '../models/exercise_instance.dart';
import '../services/workout_service.dart';
import '../services/timer_service.dart';
import '../utils/app_theme.dart';
import 'exercise_search_screen.dart';

class WorkoutDayScreen extends StatefulWidget {
  final WorkoutService workoutService;
  final int dayIndex;

  const WorkoutDayScreen({
    super.key,
    required this.workoutService,
    required this.dayIndex,
  });

  @override
  State<WorkoutDayScreen> createState() => _WorkoutDayScreenState();
}

class _WorkoutDayScreenState extends State<WorkoutDayScreen> {
  late WorkoutDay _day;

  // Rest timer state
  Timer? _restTimer;
  int _restSecondsLeft = 0;
  int _restTotalSeconds = 0;
  bool _timerRunning = false;

  @override
  void initState() {
    super.initState();
    _reload();
    _checkExistingTimer();
  }

  Future<void> _checkExistingTimer() async {
    final remaining = await TimerService().getRemainingSeconds();
    if (remaining > 0) {
      _startRestTimer(remaining, persist: false);
    }
  }

  @override
  void dispose() {
    _restTimer?.cancel();
    super.dispose();
  }

  void _reload() =>
      setState(() => _day = widget.workoutService.getDayAt(widget.dayIndex));

  // ── Weight / Reps ───────────────────────────────────────

  Future<void> _changeWeight(int exIdx, double delta) async {
    final cur = _day.exercises[exIdx].weight;
    // Round to nearest 0.5 to avoid floating-point drift
    final rawVal = (cur + delta).clamp(0.0, 1000.0);
    final val = (rawVal * 2).round() / 2.0;
    await widget.workoutService
        .updateExerciseWeight(widget.dayIndex, exIdx, val);
    _reload();
  }

  Future<void> _changeReps(int exIdx, int delta) async {
    // If complete, updating reps will un-complete it automatically
    final cur = _day.exercises[exIdx].reps;
    final val = (cur + delta).clamp(0, 100);
    _day.exercises[exIdx].reps = val;
    _day.exercises[exIdx].isCompleted = false;
    await _day.save();
    _reload();
  }

  Future<void> _toggleCompletion(int exIdx) async {
    final cur = _day.exercises[exIdx].isCompleted;
    _day.exercises[exIdx].isCompleted = !cur;
    await _day.save();
    _reload();
  }

  // ── Rest Timer ──────────────────────────────────────────

  void _showRestTimerPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 10),
            Text('REST TIMER',
                style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2)),
            SizedBox(height: 10),
            Text('Choose your rest duration',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _timerOptionBtn(ctx, 2)),
                SizedBox(width: 10),
                Expanded(child: _timerOptionBtn(ctx, 3)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _timerOptionBtn(BuildContext ctx, int minutes) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(ctx);
        _startRestTimer(minutes * 60);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Column(
          children: [
            Text('$minutes',
                style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 36,
                    fontWeight: FontWeight.w800)),
            Text('minutes',
                style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  void _startRestTimer(int totalSeconds, {bool persist = true}) {
    _restTimer?.cancel();
    setState(() {
      _restTotalSeconds = totalSeconds;
      _restSecondsLeft = totalSeconds;
      _timerRunning = true;
    });

    if (persist) {
      TimerService().startRestTimer(totalSeconds);
    }

    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_restSecondsLeft <= 1) {
        timer.cancel();
        setState(() {
          _restSecondsLeft = 0;
          _timerRunning = false;
        });
        TimerService().cancelRestTimer();
        // Vibrate when done
        HapticFeedback.heavyImpact();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('⏰ Rest over! Time to lift! 💪'),
            backgroundColor: AppTheme.success,
            duration: Duration(seconds: 3),
          ));
        }
      } else {
        setState(() => _restSecondsLeft--);
      }
    });
  }

  void _cancelRestTimer() {
    _restTimer?.cancel();
    TimerService().cancelRestTimer();
    setState(() {
      _restSecondsLeft = 0;
      _timerRunning = false;
    });
  }

  String _formatTimer(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(1, '0')}:${s.toString().padLeft(2, '0')}';
  }

  // ── Mark Done + Summary ─────────────────────────────────

  Future<void> _markDone() async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(
            _day.isCompleted ? 'Mark as Done Again?' : 'Complete Workout?'),
        content: Text(
          _day.isCompleted
              ? 'This will update the completion record and sync your progress.'
              : 'Mark this session as done for today?\nProgress will be saved.',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child:
                Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Done! 💪',
                style: TextStyle(
                    color: AppTheme.success, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (yes == true) {
      final summary = await widget.workoutService.markDayDone(widget.dayIndex);
      _reload();
      if (mounted && summary != null) {
        await _showWorkoutSummary(summary);
      }
    }
  }

  Future<void> _showWorkoutSummary(List<Map<String, dynamic>> summary) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.85,
        expand: false,
        builder: (_, scrollCtrl) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 10),
              Text('🎉', style: TextStyle(fontSize: 40)),
              SizedBox(height: 10),
              Text('WORKOUT COMPLETE!',
                  style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2)),
              SizedBox(height: 10),
              Text('${_day.title} — Day ${_day.dayNumber}',
                  style:
                      TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
              SizedBox(height: 10),

              // Summary list
              Expanded(
                child: ListView.separated(
                  controller: scrollCtrl,
                  itemCount: summary.length,
                  separatorBuilder: (_, __) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Container(
                        height: 1,
                        color: AppTheme.divider.withValues(alpha: 0.5)),
                  ),
                  itemBuilder: (_, i) {
                    final s = summary[i];
                    final weightDelta = (s['weightDelta'] as double);
                    final repsDelta = (s['repsDelta'] as int);
                    final weight = s['weight'] as double;
                    final reps = s['reps'] as int;
                    final name = s['name'] as String;
                    final hasChange = weightDelta != 0 || repsDelta != 0;
                    final isFirstSession = (s['lastReps'] as int) == 0 &&
                        (s['lastWeight'] as double) == 0.0;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 10),
                          // Main session line
                          Text(
                            'You did $reps reps at ${weight.toStringAsFixed(1)} lbs on $name this session.',
                            style: TextStyle(
                                color: AppTheme.textSecondary, fontSize: 13),
                          ),
                          if (!isFirstSession && hasChange) ...[
                            SizedBox(height: 10),
                            Row(
                              children: [
                                if (repsDelta != 0)
                                  _changeBadge(
                                    label: repsDelta > 0
                                        ? '+$repsDelta reps added'
                                        : '$repsDelta reps',
                                    positive: repsDelta > 0,
                                  ),
                                if (repsDelta != 0 && weightDelta != 0)
                                  SizedBox(width: 10),
                                if (weightDelta != 0)
                                  _changeBadge(
                                    label:
                                        '${weightDelta > 0 ? '+' : ''}${weightDelta.toStringAsFixed(1)} lbs',
                                    positive: weightDelta > 0,
                                  ),
                              ],
                            ),
                          ] else if (isFirstSession) ...[
                            SizedBox(height: 10),
                            _changeBadge(
                                label: 'First session! 🔥', positive: true),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.success,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text('NICE!',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          letterSpacing: 2)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _changeBadge({required String label, required bool positive}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: positive
            ? AppTheme.success.withValues(alpha: 0.12)
            : AppTheme.danger.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: positive ? AppTheme.success : AppTheme.danger,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ── Remove Exercise ─────────────────────────────────────

  Future<void> _removeExercise(int exIdx) async {
    final ex = _day.exercises[exIdx];
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text('Remove Exercise?'),
        content: Text('Remove ${ex.exerciseName} from this workout?',
            style: TextStyle(color: AppTheme.textSecondary)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text('Cancel',
                  style: TextStyle(color: AppTheme.textSecondary))),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text('Remove', style: TextStyle(color: AppTheme.danger))),
        ],
      ),
    );
    if (yes == true) {
      await widget.workoutService.removeExerciseFromDay(widget.dayIndex, exIdx);
      _reload();
    }
  }

  Future<void> _confirmClearAll() async {
    if (_day.exercises.isEmpty) return;

    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text('Clear All Exercises?'),
        content: Text(
            'Are you sure you want to remove all exercises from this day?\nThis action cannot be undone.',
            style: TextStyle(color: AppTheme.textSecondary)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text('Cancel',
                  style: TextStyle(color: AppTheme.textSecondary))),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text('Clear All',
                  style: TextStyle(
                      color: AppTheme.danger, fontWeight: FontWeight.bold))),
        ],
      ),
    );
    if (yes == true) {
      _day.exercises.clear();
      await _day.save();
      _reload();
    }
  }

  // ── Build ───────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.isDarkModeNotifier,
      builder: (context, isDark, _) {
        return Scaffold(
          backgroundColor: AppTheme.background,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded,
                  color: AppTheme.textPrimary, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: Column(
              children: [
                Text('DAY ${_day.dayNumber}',
                    style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 10,
                        letterSpacing: 2.5)),
                Text(_day.title,
                    style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5)),
              ],
            ),
            actions: [
              // Rest timer always available
              IconButton(
                icon: Icon(Icons.timer_outlined,
                    color: AppTheme.textSecondary, size: 22),
                tooltip: 'Rest Timer',
                onPressed: _showRestTimerPicker,
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert_rounded,
                    color: AppTheme.textSecondary, size: 22),
                color: AppTheme.surface,
                onSelected: (value) {
                  if (value == 'import') {
                    _showImportModal();
                  } else if (value == 'clear') {
                    _confirmClearAll();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'import',
                    child: Row(
                      children: [
                        Icon(Icons.file_download_outlined,
                            color: AppTheme.textPrimary, size: 20),
                        SizedBox(width: 8),
                        Text('Import from another day',
                            style: TextStyle(color: AppTheme.textPrimary)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'clear',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline_rounded,
                            color: AppTheme.danger, size: 20),
                        SizedBox(width: 8),
                        Text('Clear all exercises',
                            style: TextStyle(color: AppTheme.danger)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: Column(
            children: [
              // Completed badge banner (non-blocking)
              if (_day.isCompleted)
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: AppTheme.success.withValues(alpha: 0.1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_rounded,
                          color: AppTheme.success, size: 15),
                      SizedBox(width: 10),
                      Text(
                        _day.completedToday
                            ? 'Completed today — you can still edit and re-submit'
                            : 'Previously completed — you can still edit and re-submit',
                        style: TextStyle(color: AppTheme.success, fontSize: 12),
                      ),
                    ],
                  ),
                ),

              // Timer bar (visible when running)
              if (_timerRunning) _timerBar(),

              // Exercise list or empty state
              Expanded(
                child: _day.exercises.isEmpty ? _emptyState() : _exerciseList(),
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: _buildFABs(),
        );
      },
    );
  }

  Widget _timerBar() {
    final progress =
        _restTotalSeconds > 0 ? _restSecondsLeft / _restTotalSeconds : 0.0;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.accent.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.timer_rounded, color: AppTheme.accent, size: 20),
          SizedBox(width: 10),
          Text(
            _formatTimer(_restSecondsLeft),
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 5,
                backgroundColor: AppTheme.surface,
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accent),
              ),
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: _cancelRestTimer,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(Icons.close_rounded,
                  color: AppTheme.textSecondary, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fitness_center_rounded,
                size: 72, color: AppTheme.textSecondary.withValues(alpha: 0.2)),
            SizedBox(height: 10),
            Text('No exercises added yet',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 17)),
            SizedBox(height: 10),
            Text('Tap  +  below to add exercises',
                style: TextStyle(
                    color: AppTheme.textSecondary.withValues(alpha: 0.5),
                    fontSize: 13)),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _showImportModal,
              icon: Icon(Icons.file_download_outlined,
                  color: AppTheme.textPrimary),
              label: Text(
                'Import Workouts From Another Day',
                style: TextStyle(
                    color: AppTheme.textPrimary, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.cardElevated,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      );

  void _showImportModal() {
    final allDays = widget.workoutService.getAllDays();
    final daysWithExercises = allDays
        .where((d) => d.exercises.isNotEmpty && d.dayNumber != _day.dayNumber)
        .toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: AppTheme.divider,
                    borderRadius: BorderRadius.circular(2))),
            SizedBox(height: 10),
            Text('Import From Day',
                style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            if (daysWithExercises.isEmpty)
              Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('No other days have exercises to import.',
                    style: TextStyle(color: AppTheme.textSecondary)),
              )
            else
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: daysWithExercises.length,
                  itemBuilder: (_, i) {
                    final d = daysWithExercises[i];
                    return ListTile(
                      title: Text(d.title,
                          style: TextStyle(color: AppTheme.textPrimary)),
                      subtitle: Text(
                          'Day ${d.dayNumber} - ${d.exercises.length} Exercises',
                          style: TextStyle(color: AppTheme.textSecondary)),
                      onTap: () async {
                        Navigator.pop(ctx);
                        for (final sourceEx in d.exercises) {
                          // Deep copy
                          final newEx = ExerciseInstance(
                            exerciseId: sourceEx.exerciseId,
                            exerciseName: sourceEx.exerciseName,
                            weight: sourceEx.weight,
                            reps: 0,
                            lastReps: sourceEx.lastReps,
                            lastWeight: sourceEx.lastWeight,
                            category: sourceEx.category,
                            equipment: sourceEx.equipment,
                          );
                          await widget.workoutService
                              .addExerciseToDay(widget.dayIndex, newEx);
                        }
                        _reload();
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _exerciseList() => ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
        itemCount: _day.exercises.length,
        itemBuilder: (_, i) => _exerciseCard(i),
      );

  Widget _buildFABs() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Always show + button so user can add exercises even on completed days
            FloatingActionButton(
              heroTag: 'fab_add',
              mini: true,
              backgroundColor: AppTheme.cardElevated,
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ExerciseSearchScreen(
                      workoutService: widget.workoutService,
                      dayIndex: widget.dayIndex,
                    ),
                  ),
                );
                _reload();
              },
              child: Icon(Icons.add, color: AppTheme.textPrimary),
            ),
            SizedBox(width: 10),
            FloatingActionButton.extended(
              heroTag: 'fab_done',
              backgroundColor: _day.isCompleted
                  ? AppTheme.success.withValues(alpha: 0.75)
                  : AppTheme.success,
              onPressed: _markDone,
              icon: Icon(
                _day.isCompleted
                    ? Icons.check_circle_rounded
                    : Icons.check_rounded,
                color: Colors.white,
              ),
              label: Text(
                _day.isCompleted ? 'DONE  ✓' : 'WORKOUT DONE',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5),
              ),
            ),
          ],
        ),
      );

  // ── Exercise Card ───────────────────────────────────────

  Widget _exerciseCard(int i) {
    final ex = _day.exercises[i];
    final hasHistory = ex.lastReps > 0;

    // Dim the entire card if it's completed
    final cardOpacity = ex.isCompleted ? 0.6 : 1.0;

    return Opacity(
      opacity: cardOpacity,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: ex.isCompleted ? AppTheme.surface : AppTheme.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: ex.isCompleted
                ? AppTheme.success.withAlpha(100)
                : AppTheme.divider,
            width: 1,
          ),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
            collapsedIconColor: AppTheme.textSecondary,
            iconColor: AppTheme.accent,
            title: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ex.exerciseName,
                          style: TextStyle(
                            color: ex.isCompleted
                                ? AppTheme.textSecondary
                                : AppTheme.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          )),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                              '${ex.weight.toStringAsFixed(1)} lbs × ${ex.reps} reps',
                              style: TextStyle(
                                  color: AppTheme.accent.withValues(alpha: 0.8),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600)),
                          if (hasHistory) ...[
                            SizedBox(width: 10),
                            _repDifferenceBadge(ex.reps - ex.lastReps),
                          ]
                        ],
                      ),
                    ],
                  ),
                ),
                // Custom Checkbox
                GestureDetector(
                  onTap: () => _toggleCompletion(i),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ex.isCompleted
                          ? AppTheme.success
                          : Colors.transparent,
                      border: Border.all(
                        color: ex.isCompleted
                            ? AppTheme.success
                            : AppTheme.divider,
                        width: 2,
                      ),
                    ),
                    child: ex.isCompleted
                        ? Icon(Icons.check, color: Colors.white, size: 18)
                        : null,
                  ),
                ),
              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _divider(),
                    SizedBox(height: 10),
                    _weightRow(ex, i),
                    SizedBox(height: 10),
                    _divider(),
                    SizedBox(height: 10),
                    _repsRow(ex, i),
                    SizedBox(height: 10),
                    _notesRow(ex, i),
                    if (hasHistory) ...[
                      SizedBox(height: 10),
                      Text(
                        'Last session: ${ex.lastWeight.toStringAsFixed(1)} lbs × ${ex.lastReps} reps',
                        style: TextStyle(
                            color:
                                AppTheme.textSecondary.withValues(alpha: 0.8),
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () => _removeExercise(i),
                        icon: Icon(Icons.delete_outline,
                            color: AppTheme.danger, size: 16),
                        label: Text('Remove',
                            style: TextStyle(color: AppTheme.danger)),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _repDifferenceBadge(int diff) {
    if (diff == 0) return SizedBox.shrink();
    final positive = diff > 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: positive
            ? AppTheme.success.withValues(alpha: 0.2)
            : AppTheme.danger.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '${positive ? '+' : ''}$diff',
        style: TextStyle(
          color: positive ? AppTheme.success : AppTheme.danger,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _divider() =>
      Container(height: 1, color: AppTheme.divider.withValues(alpha: 0.6));

  Widget _weightRow(ExerciseInstance ex, int i) {
    final kg = ex.weight * 0.453592;
    return Row(
      children: [
        Text('WEIGHT',
            style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 11,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w600)),
        const Spacer(),
        _ctrlBtn(
          icon: Icons.remove_rounded,
          onTap: () => _changeWeight(i, -2.5),
        ),
        SizedBox(width: 10),
        SizedBox(
          width: 100,
          child: Column(
            children: [
              Text(
                '${ex.weight.toStringAsFixed(1)} lbs',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 19,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '${kg.toStringAsFixed(1)} kg',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
              ),
            ],
          ),
        ),
        SizedBox(width: 10),
        _ctrlBtn(
          icon: Icons.add_rounded,
          onTap: () => _changeWeight(i, 2.5),
        ),
      ],
    );
  }

  Widget _repsRow(ExerciseInstance ex, int i) {
    return Row(
      children: [
        Text('REPS',
            style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 11,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w600)),
        const Spacer(),
        _ctrlBtn(
          icon: Icons.remove_rounded,
          onTap: () => _changeReps(i, -1),
        ),
        SizedBox(width: 10),
        SizedBox(
          width: 100,
          child: Text(
            '${ex.reps}',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(width: 10),
        _ctrlBtn(
          icon: Icons.add_rounded,
          onTap: () => _changeReps(i, 1),
        ),
      ],
    );
  }

  Widget _notesRow(ExerciseInstance ex, int i) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('NOTES (Optional)',
            style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 11,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w600)),
        SizedBox(height: 10),
        TextField(
          controller: TextEditingController(text: ex.notes)
            ..selection = TextSelection.collapsed(offset: ex.notes.length),
          style: TextStyle(color: AppTheme.textPrimary, fontSize: 13),
          decoration: InputDecoration(
            hintText: 'e.g. Felt easy, form was good...',
            hintStyle: TextStyle(color: AppTheme.textSecondary.withAlpha(100)),
            filled: true,
            fillColor: AppTheme.surface,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none),
          ),
          onChanged: (val) async {
            ex.notes = val;
            await _day
                .save(); // Not calling reload to avoid losing keyboard focus
          },
        ),
      ],
    );
  }

  Widget _ctrlBtn({
    required IconData icon,
    VoidCallback? onTap,
    bool highlight = false,
  }) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: enabled
              ? (highlight
                  ? AppTheme.warning.withValues(alpha: 0.12)
                  : AppTheme.cardElevated)
              : AppTheme.surface.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: enabled
                ? (highlight
                    ? AppTheme.warning.withValues(alpha: 0.35)
                    : AppTheme.divider)
                : Colors.transparent,
          ),
        ),
        child: Icon(
          icon,
          color: enabled
              ? (highlight ? AppTheme.warning : AppTheme.textPrimary)
              : AppTheme.textSecondary.withValues(alpha: 0.25),
          size: 24,
        ),
      ),
    );
  }
}
