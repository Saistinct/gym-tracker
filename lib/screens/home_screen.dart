import 'package:flutter/material.dart';
import '../models/workout_day.dart';
import '../models/body_measurements.dart';
import '../services/workout_service.dart';
import '../utils/app_theme.dart';
import 'workout_day_screen.dart';

class HomeScreen extends StatefulWidget {
  final WorkoutService workoutService;
  const HomeScreen({super.key, required this.workoutService});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late List<WorkoutDay> _days;
  late BodyMeasurements _body;
  late TabController _tabController;
  bool _editingPlan = false;
  int _tabIndex = 0;

  // App version constants
  static const String _appVersion = '1.0.0';
  static const String _developer = 'Saistinct';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabIndex = _tabController.index;
    _tabController.addListener(() {
      if (!mounted) return;
      if (_tabController.indexIsChanging) return;
      if (_tabIndex != _tabController.index) {
        setState(() {
          _tabIndex = _tabController.index;
          if (_tabIndex != 1) _editingPlan = false;
        });
      }
    });
    _reload();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _reload() => setState(() {
        _days = widget.workoutService.getAllDays();
        _body = widget.workoutService.getBodyMeasurements();
      });

  Future<void> _reorderPlan(int oldIndex, int newIndex) async {
    await widget.workoutService.reorderDays(oldIndex, newIndex);
    _reload();
  }

  Future<void> _resetProgram() async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text('Start New Week?'),
        content: Text(
          'This will reset all completion dates.\n'
          'Your exercises, weights and reps will be kept.',
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
            child: Text('Reset',
                style: TextStyle(
                    color: AppTheme.danger, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
    if (yes == true) {
      await widget.workoutService.resetProgram();
      _reload();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Program reset! Ready for a new week'),
          backgroundColor: AppTheme.success,
        ));
      }
    }
  }

  Future<void> _editDayTitle(int index) async {
    final day = _days[index];
    final controller = TextEditingController(text: day.title);
    final newTitle = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text('Edit Day Title'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          style: TextStyle(color: AppTheme.textPrimary, fontSize: 16),
          decoration: InputDecoration(
            hintText: 'e.g. Push Day',
            filled: true,
            fillColor: AppTheme.card,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppTheme.accent, width: 1),
            ),
          ),
          onSubmitted: (v) => Navigator.pop(ctx, v.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child:
                Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: Text('Save',
                style: TextStyle(
                    color: AppTheme.success, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => controller.dispose());

    if (!mounted) return;
    if (newTitle != null && newTitle.isNotEmpty && newTitle != day.title) {
      await widget.workoutService.updateDayTitle(index, newTitle);
      if (mounted) _reload();
    }
  }

  void _showAbout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 8),
            Text(
              'SAIZONE',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: 3,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Version $_appVersion',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Developed by $_developer',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
              ),
            ),
            SizedBox(height: 8),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('OK',
                style: TextStyle(
                    color: AppTheme.accent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final username = widget.workoutService.getUsername();
    final weekCount = widget.workoutService.getWeekCount();
    final currentDayIdx = widget.workoutService.getCurrentDayIndex();
    final allDone = widget.workoutService.allDaysCompleted;

    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.isDarkModeNotifier,
      builder: (context, isDark, _) {
        return Scaffold(
          backgroundColor: AppTheme.background,
          appBar: AppBar(
            title: Text('SAIZONE'),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: AppTheme.accent,
              indicatorWeight: 2.5,
              labelColor: AppTheme.textPrimary,
              unselectedLabelColor: AppTheme.textSecondary,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelStyle: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                letterSpacing: 1.0,
              ),
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              tabs: const [
                Tab(text: 'DASHBOARD'),
                Tab(text: 'WORKOUT'),
                Tab(text: 'BODY'),
                Tab(text: 'NUTRITION'),
              ],
            ),
            actions: [
              if (_tabIndex == 1)
                IconButton(
                  icon: Icon(
                    _editingPlan
                        ? Icons.check_rounded
                        : Icons.edit_calendar_rounded,
                    color: AppTheme.textSecondary,
                  ),
                  tooltip: _editingPlan ? 'Done' : 'Edit plan',
                  onPressed: () => setState(() => _editingPlan = !_editingPlan),
                ),
              // Info button
              IconButton(
                icon: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: AppTheme.textSecondary.withValues(alpha: 0.5),
                        width: 1.5),
                  ),
                  child: Center(
                    child: Text(
                      '!',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                tooltip: 'About',
                onPressed: _showAbout,
              ),
              ValueListenableBuilder<bool>(
                valueListenable: AppTheme.isDarkModeNotifier,
                builder: (context, isDark, _) {
                  return IconButton(
                    icon: Icon(
                      isDark
                          ? Icons.light_mode_rounded
                          : Icons.dark_mode_rounded,
                      color: AppTheme.textSecondary,
                      size: 22,
                    ),
                    tooltip: isDark ? 'Light Mode' : 'Dark Mode',
                    onPressed: AppTheme.toggleTheme,
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.refresh_rounded,
                    color: AppTheme.textSecondary, size: 22),
                tooltip: 'Start New Week',
                onPressed: _resetProgram,
              ),
            ],
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _dashboardTab(username, weekCount, currentDayIdx, allDone),
              _workoutTab(currentDayIdx),
              _bodyTab(),
              _comingSoonTab(
                icon: Icons.restaurant_menu_rounded,
                title: 'Nutrition & Calories',
                subtitle: 'Log your meals and track macros',
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Dashboard Tab ────────────────────────────────────────

  Widget _dashboardTab(
      String username, int weekCount, int currentDayIdx, bool allDone) {
    final completed = _days.where((d) => d.isCompleted).length;
    final total = _days.length;
    final progress = total > 0 ? completed / total : 0.0;

    final int displayDayNum;
    final String displayDayTitle;
    if (allDone) {
      displayDayNum = total;
      displayDayTitle = 'Week Complete!';
    } else if (currentDayIdx >= 0 && currentDayIdx < _days.length) {
      displayDayNum = _days[currentDayIdx].dayNumber;
      displayDayTitle = _days[currentDayIdx].title;
    } else {
      displayDayNum = 1;
      displayDayTitle = 'Ready to train';
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting
          Text(
            'Hey, $username!',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.success.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Week $weekCount',
              style: TextStyle(
                color: AppTheme.success,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Total Weeks Trained: $weekCount',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),

          // Day circle
          Center(
            child: _dayCircle(displayDayNum, displayDayTitle, allDone),
          ),
          SizedBox(height: 10),

          // Progress section
          Row(
            children: [
              Text(
                'Week Progress',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '$completed / $total days',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppTheme.surface,
              valueColor: AlwaysStoppedAnimation<Color>(
                allDone ? AppTheme.success : AppTheme.accent,
              ),
            ),
          ),
          SizedBox(height: 10),

          // Quick stats
          _quickStatsRow(completed, total),
          SizedBox(height: 10),

          // Progress History Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _showProgressHistory,
              icon: Icon(Icons.history_rounded, color: AppTheme.textPrimary),
              label: Text(
                'Progress History',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.cardElevated,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: AppTheme.divider),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showProgressHistory() {
    final reports = widget.workoutService.getProgressReports();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, scrollCtrl) {
          if (reports.isEmpty) {
            return Padding(
              padding: EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.history_toggle_off_rounded,
                      size: 64, color: AppTheme.textSecondary),
                  SizedBox(height: 16),
                  Text(
                    'No reports yet.',
                    style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Reports are generated at 6 months (Week 26) and 1 year (Week 52) milestones.',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(24),
            controller: scrollCtrl,
            itemCount: reports.length + 1,
            separatorBuilder: (_, __) => SizedBox(height: 16),
            itemBuilder: (_, i) {
              if (i == 0) {
                return Text(
                  'Milestone Reports',
                  style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w800),
                );
              }
              final report = reports[i - 1];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.divider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Week ${report.milestoneWeek} Milestone',
                      style: TextStyle(
                          color: AppTheme.accent,
                          fontWeight: FontWeight.w700,
                          fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    ...report.reportLines.map((line) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text('• $line',
                              style: TextStyle(
                                  color: AppTheme.textSecondary, fontSize: 13)),
                        )),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Dashboard shortcut buttons intentionally removed.

  Widget _dayCircle(int dayNum, String title, bool allDone) {
    const double size = 190;
    const double strokeWidth = 10;

    return Column(
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: strokeWidth,
                  strokeCap: StrokeCap.round,
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.surface),
                ),
              ),
              SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  value: allDone ? 1.0 : (dayNum / 7.0).clamp(0.0, 1.0),
                  strokeWidth: strokeWidth,
                  strokeCap: StrokeCap.round,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    allDone ? AppTheme.success : AppTheme.accent,
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (allDone)
                    Icon(Icons.check_circle_rounded,
                        color: AppTheme.success, size: 48)
                  else ...[
                    Text(
                      'DAY',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      '$dayNum',
                      style: TextStyle(
                        color:
                            allDone ? AppTheme.success : AppTheme.textPrimary,
                        fontSize: 54,
                        fontWeight: FontWeight.w900,
                        height: 1.0,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Text(
          title,
          style: TextStyle(
            color: allDone ? AppTheme.success : AppTheme.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _quickStatsRow(int completed, int total) {
    final remaining = total - completed;
    final weekCount = widget.workoutService.getWeekCount();
    return Row(
      children: [
        Expanded(
            child:
                _statCard('Weeks', '$weekCount', Icons.calendar_today_rounded)),
        SizedBox(width: 10),
        Expanded(
            child: _statCard(
                'Done', '$completed', Icons.check_circle_outline_rounded)),
        SizedBox(width: 10),
        Expanded(
            child: _statCard('Left', '$remaining', Icons.pending_outlined)),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.accent, size: 18),
          SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ── Workout Tab ──────────────────────────────────────────

  Widget _workoutTab(int currentDayIdx) {
    if (_editingPlan) {
      return ReorderableListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        onReorder: _reorderPlan,
        buildDefaultDragHandles: false,
        proxyDecorator: (child, _, __) => Material(
          color: Colors.transparent,
          child: child,
        ),
        itemCount: _days.length,
        itemBuilder: (_, i) {
          final day = _days[i];
          return ReorderableDragStartListener(
            key: ValueKey(day),
            index: i,
            child: _dayCard(i, currentDayIdx, editing: true),
          );
        },
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: _days.length,
      itemBuilder: (_, i) => _dayCard(i, currentDayIdx, editing: false),
    );
  }

  Widget _dayCard(int index, int currentDayIdx, {required bool editing}) {
    final day = _days[index];
    final isCurrent = index == currentDayIdx && !day.isCompleted;

    return GestureDetector(
      onTap: (editing || day.isRestDay)
          ? null
          : () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WorkoutDayScreen(
                    workoutService: widget.workoutService,
                    dayIndex: index,
                  ),
                ),
              );
              _reload();
            },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isCurrent ? AppTheme.cardElevated : AppTheme.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isCurrent
                ? AppTheme.accent.withValues(alpha: 0.4)
                : day.isCompleted
                    ? AppTheme.success.withValues(alpha: 0.3)
                    : AppTheme.divider,
            width: isCurrent ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: day.isCompleted
                    ? AppTheme.success.withValues(alpha: 0.15)
                    : isCurrent
                        ? AppTheme.accent.withValues(alpha: 0.12)
                        : AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: day.isCompleted
                    ? Icon(Icons.check_rounded,
                        color: AppTheme.success, size: 22)
                    : day.isRestDay
                        ? Icon(Icons.hotel_rounded,
                            color: AppTheme.textSecondary, size: 20)
                        : Text(
                            '${day.dayNumber}',
                            style: TextStyle(
                              color: isCurrent
                                  ? AppTheme.textPrimary
                                  : AppTheme.textSecondary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    day.title,
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    day.isCompleted
                        ? (day.completedToday ? 'Completed today' : 'Completed')
                        : day.isRestDay
                            ? 'Recovery'
                            : isCurrent
                                ? 'Up next'
                                : '${day.exercises.length} exercise${day.exercises.length != 1 ? 's' : ''}',
                    style: TextStyle(
                      color: day.isCompleted
                          ? AppTheme.success
                          : AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (editing)
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      await widget.workoutService
                          .setRestDay(index, isRestDay: !day.isRestDay);
                      _reload();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        day.isRestDay
                            ? Icons.fitness_center_rounded
                            : Icons.hotel_rounded,
                        color: AppTheme.textSecondary,
                        size: 18,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.drag_handle_rounded,
                        color: AppTheme.textSecondary, size: 18),
                  ),
                ],
              )
            else if (!day.isRestDay)
              GestureDetector(
                onTap: () => _editDayTitle(index),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.edit_outlined,
                      color: AppTheme.textSecondary, size: 16),
                ),
              ),
            if (!editing && !day.isRestDay) SizedBox(width: 14),
            if (!editing && !day.isRestDay)
              Icon(Icons.chevron_right_rounded,
                  color: AppTheme.textSecondary, size: 22),
          ],
        ),
      ),
    );
  }

  // ── Body Tab ─────────────────────────────────────────────

  static const List<String> _bodyParts = [
    'Neck',
    'Shoulders',
    'Chest',
    'Waist',
    'Hips/Buttocks',
    'Arms',
    'Forearms',
    'Thighs',
    'Calves',
  ];

  double _cmToIn(double cm) => cm / 2.54;
  double _inToCm(double inches) => inches * 2.54;

  String _fmt(double v) => v.toStringAsFixed(1);

  bool get _useInches => _body.preferredUnit == 1;

  String _lenUnitLabel() => _useInches ? 'in' : 'cm';

  double _displayLen(double cm) => _useInches ? _cmToIn(cm) : cm;

  double _parseLenToCm(String raw) {
    final v = double.tryParse(raw.trim().replaceAll(',', '.'));
    if (v == null) return -1;
    return _useInches ? _inToCm(v) : v;
  }

  Future<void> _editLength({
    required String title,
    required double currentCm,
    required Future<void> Function(double cm) onSave,
  }) async {
    final controller = TextEditingController(
      text: currentCm <= 0 ? '' : _fmt(_displayLen(currentCm)),
    );
    final newRaw = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          style: TextStyle(color: AppTheme.textPrimary, fontSize: 16),
          decoration: InputDecoration(
            hintText: 'Enter value (${_lenUnitLabel()})',
            filled: true,
            fillColor: AppTheme.card,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppTheme.accent, width: 1),
            ),
          ),
          onSubmitted: (v) => Navigator.pop(ctx, v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child:
                Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: Text('Save',
                style: TextStyle(
                    color: AppTheme.success, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => controller.dispose());

    if (!mounted) return;
    if (newRaw == null) return;

    final cm = _parseLenToCm(newRaw);
    if (cm < 0) return;
    await onSave(cm);
    _reload();
  }

  Future<void> _editWeightKg() async {
    final controller = TextEditingController(
      text: _body.weightKg <= 0 ? '' : _fmt(_body.weightKg),
    );
    final newRaw = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text('Edit Weight'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          style: TextStyle(color: AppTheme.textPrimary, fontSize: 16),
          decoration: InputDecoration(
            hintText: 'Enter weight (kg)',
            filled: true,
            fillColor: AppTheme.card,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppTheme.accent, width: 1),
            ),
          ),
          onSubmitted: (v) => Navigator.pop(ctx, v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child:
                Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: Text('Save',
                style: TextStyle(
                    color: AppTheme.success, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => controller.dispose());

    if (!mounted) return;
    if (newRaw == null) return;
    final kg = double.tryParse(newRaw.trim().replaceAll(',', '.'));
    if (kg == null) return;
    await widget.workoutService.setWeightKg(kg);
    _reload();
  }

  double? _bmi() {
    final hM = _body.heightCm / 100.0;
    final w = _body.weightKg;
    if (hM <= 0 || w <= 0) return null;
    return w / (hM * hM);
  }

  ({String label, Color color}) _bmiCategory(double bmi) {
    if (bmi < 18.5) return (label: 'Underweight', color: AppTheme.warning);
    if (bmi < 25) return (label: 'Normal', color: AppTheme.success);
    if (bmi < 30) return (label: 'Overweight', color: AppTheme.warning);
    return (label: 'Obese', color: AppTheme.danger);
  }

  Widget _metricCard({
    required String label,
    required String value,
    required String sub,
    required VoidCallback onEdit,
    IconData icon = Icons.edit_outlined,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.6)),
                SizedBox(height: 10),
                Text(value,
                    style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w800)),
                SizedBox(height: 10),
                Text(sub,
                    style:
                        TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          GestureDetector(
            onTap: onEdit,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppTheme.textSecondary, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bodyTab() {
    final bmi = _bmi();
    final bmiText = bmi == null ? '--' : _fmt(bmi);
    final bmiCat = bmi == null ? null : _bmiCategory(bmi);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('BODY',
                  style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2)),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.divider),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: _body.preferredUnit,
                    dropdownColor: AppTheme.surface,
                    style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w700),
                    items: const [
                      DropdownMenuItem(value: 0, child: Text('cm')),
                      DropdownMenuItem(value: 1, child: Text('in')),
                    ],
                    onChanged: (v) async {
                      if (v == null) return;
                      await widget.workoutService.setPreferredBodyUnit(v);
                      _reload();
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),

          // Height / Weight
          Row(
            children: [
              Expanded(
                child: _metricCard(
                  label: 'HEIGHT',
                  value: _body.heightCm <= 0
                      ? '--'
                      : '${_fmt(_displayLen(_body.heightCm))} ${_lenUnitLabel()}',
                  sub: 'Tap to edit',
                  onEdit: () => _editLength(
                    title: 'Edit Height',
                    currentCm: _body.heightCm,
                    onSave: (cm) => widget.workoutService.setHeightCm(cm),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _metricCard(
                  label: 'WEIGHT',
                  value:
                      _body.weightKg <= 0 ? '--' : '${_fmt(_body.weightKg)} kg',
                  sub: 'Tap to edit',
                  onEdit: _editWeightKg,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),

          // BMI
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: BoxDecoration(
              color: AppTheme.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('BMI',
                    style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.6)),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      bmiText,
                      style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 28,
                          fontWeight: FontWeight.w900),
                    ),
                    SizedBox(width: 10),
                    if (bmiCat != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: bmiCat.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                              color: bmiCat.color.withValues(alpha: 0.25)),
                        ),
                        child: Text(
                          bmiCat.label.toUpperCase(),
                          style: TextStyle(
                              color: bmiCat.color,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.0),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 10),
                _bmiChart(bmi),
              ],
            ),
          ),
          SizedBox(height: 10),
          Text('MEASUREMENTS',
              style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.2)),
          SizedBox(height: 10),
          ..._bodyParts.map((part) => _measurementRow(part)),
        ],
      ),
    );
  }

  Widget _bmiChart(double? bmi) {
    const ranges = [
      (label: 'Under', min: 0.0, max: 18.5),
      (label: 'Normal', min: 18.5, max: 25.0),
      (label: 'Over', min: 25.0, max: 30.0),
      (label: 'Obese', min: 30.0, max: 60.0),
    ];

    Color rangeColor(String label) {
      switch (label) {
        case 'Normal':
          return AppTheme.success;
        case 'Obese':
          return AppTheme.danger;
        default:
          return AppTheme.warning;
      }
    }

    bool inRange(double v, double min, double max) => v >= min && v < max;

    return Row(
      children: ranges.map((r) {
        final active = bmi != null && inRange(bmi, r.min, r.max);
        final c = rangeColor(r.label);
        return Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 6),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: active ? c.withValues(alpha: 0.16) : AppTheme.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: active ? c.withValues(alpha: 0.35) : AppTheme.divider),
            ),
            child: Column(
              children: [
                Text(r.label,
                    style: TextStyle(
                        color: active ? c : AppTheme.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5)),
                SizedBox(height: 10),
                Text(
                  '${r.min.toStringAsFixed(0)}–${r.max.toStringAsFixed(0)}',
                  style: TextStyle(
                      color: active
                          ? AppTheme.textPrimary
                          : AppTheme.textSecondary.withValues(alpha: 0.7),
                      fontSize: 10,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _measurementRow(String part) {
    final cm = _body.measurementsCm[part] ?? 0;
    final valueText =
        cm <= 0 ? '--' : '${_fmt(_displayLen(cm))} ${_lenUnitLabel()}';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(part,
                    style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700)),
                SizedBox(height: 10),
                Text(valueText,
                    style:
                        TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _editLength(
              title: 'Edit $part',
              currentCm: cm,
              onSave: (newCm) =>
                  widget.workoutService.setMeasurementCm(part, newCm),
            ),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.edit_outlined,
                  color: AppTheme.textSecondary, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  // ── Coming Soon Tab ──────────────────────────────────────

  // FOR FUTURE DEVELOPMENT
  Widget _comingSoonTab({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.divider),
              ),
              child: Icon(icon,
                  size: 38,
                  color: AppTheme.textSecondary.withValues(alpha: 0.5)),
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              subtitle,
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.divider),
              ),
              child: Text(
                'For Future Development',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
