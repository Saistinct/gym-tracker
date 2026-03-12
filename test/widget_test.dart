import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gym_workout_tracker/services/workout_service.dart';
import 'package:gym_workout_tracker/screens/home_screen.dart';

void main() {
  testWidgets('Home screen shows 7 days', (WidgetTester tester) async {
    final service = WorkoutService();
    await service.init();

    await tester.pumpWidget(MaterialApp(
      home: HomeScreen(workoutService: service),
    ));

    await tester.pumpAndSettle();
    expect(find.textContaining('Day 1'), findsWidgets);
  });
}
