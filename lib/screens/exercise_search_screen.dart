import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../models/exercise_instance.dart';
import '../services/exercise_database.dart';
import '../services/workout_service.dart';
import '../utils/app_theme.dart';

class ExerciseSearchScreen extends StatefulWidget {
  final WorkoutService workoutService;
  final int dayIndex;

  const ExerciseSearchScreen({
    super.key,
    required this.workoutService,
    required this.dayIndex,
  });

  @override
  State<ExerciseSearchScreen> createState() => _ExerciseSearchScreenState();
}

class _ExerciseSearchScreenState extends State<ExerciseSearchScreen> {
  final _searchCtrl = TextEditingController();

  final List<String> _categories = [
    'All',
    'Chest',
    'Back',
    'Legs',
    'Glutes',
    'Calves',
    'Shoulders',
    'Biceps',
    'Triceps',
    'Forearms',
    'Core',
    'Neck',
    'Cardio',
  ];
  String _selectedCat = 'All';

  List<Exercise> _all = [];
  List<Exercise> _filtered = [];
  Set<String> _addedIds = {};

  @override
  void initState() {
    super.initState();
    _all = ExerciseDatabase.getAllExercises();
    _filtered = _all;
    _addedIds = widget.workoutService
        .getDayAt(widget.dayIndex)
        .exercises
        .map((e) => e.exerciseId)
        .toSet();
    _searchCtrl.addListener(_filter);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _filter() {
    final q = _searchCtrl.text.toLowerCase().trim();
    setState(() {
      _filtered = _all.where((e) {
        final matchCat = _selectedCat == 'All' ||
            e.category.startsWith(_selectedCat) ||
            (_selectedCat == 'Core' && e.category.startsWith('Abs'));
        final matchText = q.isEmpty ||
            e.name.toLowerCase().contains(q) ||
            e.equipment.toLowerCase().contains(q);
        return matchCat && matchText;
      }).toList();
    });
  }

  void _selectCategory(String cat) {
    setState(() => _selectedCat = cat);
    _filter();
  }

  Future<void> _addExercise(Exercise ex) async {
    if (_addedIds.contains(ex.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${ex.name} is already in this workout.')));
      return;
    }
    // Check if this exercise was previously used — retain its weight/reps
    final existing = widget.workoutService.getLatestExerciseState(ex.id);
    final double weight;
    final double lastWeight;
    final int reps;
    final int lastReps;
    if (existing != null) {
      weight = existing.weight;
      lastWeight = existing.lastWeight;
      reps = existing.reps;
      lastReps = existing.lastReps;
    } else {
      weight = ex.equipment == 'Bodyweight' ? 0.0 : 45.0;
      lastWeight = weight;
      reps = 0;
      lastReps = 0;
    }
    final instance = ExerciseInstance(
      exerciseId: ex.id,
      exerciseName: ex.name,
      category: ex.category,
      equipment: ex.equipment,
      weight: weight,
      lastWeight: lastWeight,
      reps: reps,
      lastReps: lastReps,
    );
    await widget.workoutService.addExerciseToDay(widget.dayIndex, instance);
    setState(() => _addedIds.add(ex.id));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${ex.name} added!'),
          backgroundColor: AppTheme.success.withValues(alpha: 0.85),
          duration: const Duration(seconds: 1)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.isDarkModeNotifier,
      builder: (context, isDark, _) {
        return Scaffold(
          backgroundColor: AppTheme.background,
          appBar: AppBar(title: Text('ADD EXERCISES')),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                child: TextField(
                  controller: _searchCtrl,
                  style: TextStyle(color: AppTheme.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Search by name or equipment…',
                    prefixIcon: Icon(Icons.search_rounded,
                        color: AppTheme.textSecondary),
                    suffixIcon: _searchCtrl.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear_rounded,
                                color: AppTheme.textSecondary, size: 18),
                            onPressed: () {
                              _searchCtrl.clear();
                              _filter();
                            },
                          )
                        : null,
                  ),
                ),
              ),
              SizedBox(
                height: 48,
                child: ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (_, i) {
                    final cat = _categories[i];
                    final selected = cat == _selectedCat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => _selectCategory(cat),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 5),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppTheme.accent.withValues(alpha: 0.15)
                                : AppTheme.card,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: selected
                                    ? AppTheme.accent.withValues(alpha: 0.5)
                                    : Colors.transparent),
                          ),
                          child: Text(cat,
                              style: TextStyle(
                                  color: selected
                                      ? AppTheme.accent
                                      : AppTheme.textSecondary,
                                  fontSize: 13,
                                  fontWeight: selected
                                      ? FontWeight.w600
                                      : FontWeight.normal)),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 4, 18, 4),
                child: Row(
                  children: [
                    Text(
                      '${_filtered.length} exercise${_filtered.length != 1 ? 's' : ''}',
                      style: TextStyle(
                          color: AppTheme.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _filtered.isEmpty
                    ? Center(
                        child: Text('No exercises found',
                            style: TextStyle(
                                color: AppTheme.textSecondary
                                    .withValues(alpha: 0.5))),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: _filtered.length,
                        itemBuilder: (_, i) => _exerciseTile(_filtered[i]),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _exerciseTile(Exercise ex) {
    final added = _addedIds.contains(ex.id);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: added ? AppTheme.card.withValues(alpha: 0.5) : AppTheme.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: added
                ? AppTheme.success.withValues(alpha: 0.25)
                : Colors.transparent),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: _catColor(ex.category).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(_catIcon(ex.category),
              color: _catColor(ex.category), size: 20),
        ),
        title: Text(ex.name,
            style: TextStyle(
                color: added ? AppTheme.textSecondary : AppTheme.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500)),
        subtitle: Text('${ex.equipment}  •  ${ex.category}',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
        trailing: GestureDetector(
          onTap: added ? null : () => _addExercise(ex),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: added
                  ? AppTheme.success.withValues(alpha: 0.15)
                  : AppTheme.accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              added ? Icons.check_rounded : Icons.add_rounded,
              color: added ? AppTheme.success : AppTheme.accent,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Color _catColor(String cat) {
    if (cat.startsWith('Chest')) return const Color(0xFFFF6B6B);
    if (cat.startsWith('Back') || cat.startsWith('Neck'))
      return const Color(0xFF4DA6FF);
    if (cat.startsWith('Legs') ||
        cat.startsWith('Glutes') ||
        cat.startsWith('Calves')) return const Color(0xFF4ADE80);
    if (cat.startsWith('Shoulders')) return const Color(0xFFFFA94D);
    if (cat.startsWith('Biceps') ||
        cat.startsWith('Triceps') ||
        cat.startsWith('Forearms')) return const Color(0xFFB57BFF);
    if (cat.startsWith('Core') || cat.startsWith('Abs'))
      return const Color(0xFFFFD93D);
    if (cat.startsWith('Cardio')) return const Color(0xFFFF8CC8);
    return AppTheme.accent;
  }

  IconData _catIcon(String cat) {
    if (cat.startsWith('Chest')) return Icons.fitness_center_rounded;
    if (cat.startsWith('Back') || cat.startsWith('Neck'))
      return Icons.accessibility_new_rounded;
    if (cat.startsWith('Legs') ||
        cat.startsWith('Glutes') ||
        cat.startsWith('Calves')) return Icons.directions_run_rounded;
    if (cat.startsWith('Shoulders')) return Icons.sports_handball_rounded;
    if (cat.startsWith('Biceps') ||
        cat.startsWith('Triceps') ||
        cat.startsWith('Forearms')) return Icons.sports_martial_arts_rounded;
    if (cat.startsWith('Core') || cat.startsWith('Abs'))
      return Icons.crop_square_rounded;
    if (cat.startsWith('Cardio')) return Icons.monitor_heart_rounded;
    return Icons.fitness_center_rounded;
  }
}
