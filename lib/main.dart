import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/exercise.dart';
import 'models/exercise_instance.dart';
import 'models/body_measurements.dart';
import 'models/workout_day.dart';
import 'models/user_profile.dart';
import 'models/progress_log.dart';       // ← ADDED
import 'models/progress_report.dart';    // ← ADDED
import 'services/workout_service.dart';
import 'utils/app_theme.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Force portrait orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Dark status bar
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  // Hive init
  await Hive.initFlutter();
  Hive.registerAdapter(ExerciseAdapter());
  Hive.registerAdapter(ExerciseInstanceAdapter());
  Hive.registerAdapter(WorkoutDayAdapter());
  Hive.registerAdapter(UserProfileAdapter());
  Hive.registerAdapter(BodyMeasurementsAdapter());
  Hive.registerAdapter(ProgressLogAdapter());      // ← ADDED
  Hive.registerAdapter(ProgressReportAdapter());   // ← ADDED

  // Service init
  final workoutService = WorkoutService();
  await workoutService.init();

  // Theme init
  await AppTheme.initTheme();

  runApp(GymTrackerApp(workoutService: workoutService));
}

class GymTrackerApp extends StatelessWidget {
  final WorkoutService workoutService;
  const GymTrackerApp({super.key, required this.workoutService});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.isDarkModeNotifier,
      builder: (context, isDark, child) {
        return MaterialApp(
          title: 'SaiZone',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.currentTheme,
          home: SplashScreen(workoutService: workoutService),
        );
      },
    );
  }
}