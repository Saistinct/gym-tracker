import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TimerService {
  static final TimerService _instance = TimerService._internal();
  factory TimerService() => _instance;
  TimerService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String _endTimeKey = 'rest_timer_end_time';

  Future<void> init() async {
    tz.initializeTimeZones();

    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
    );
  }

  Future<void> startRestTimer(int seconds) async {
    final now = DateTime.now();
    final endTime = now.add(Duration(seconds: seconds));

    // Save targeted end time
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_endTimeKey, endTime.millisecondsSinceEpoch);

    // Schedule notification
    const androidDetails = AndroidNotificationDetails(
      'rest_timer_channel',
      'Rest Timer',
      channelDescription: 'Notifications for workout rest timers',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );
    const iosDetails = DarwinNotificationDetails(
      presentSound: true,
      presentAlert: true,
      presentBadge: true,
    );
    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: 0,
      title: 'Rest Timer Finished',
      body: 'Ready for your next set! 💪',
      scheduledDate: tz.TZDateTime.from(endTime, tz.local),
      notificationDetails: notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> cancelRestTimer() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_endTimeKey);
    await flutterLocalNotificationsPlugin.cancel(id: 0);
  }

  /// Returns the remaining seconds if a timer is active, otherwise 0.
  Future<int> getRemainingSeconds() async {
    final prefs = await SharedPreferences.getInstance();
    final endTimeMs = prefs.getInt(_endTimeKey);
    if (endTimeMs == null) return 0;

    final endTime = DateTime.fromMillisecondsSinceEpoch(endTimeMs);
    final now = DateTime.now();
    if (endTime.isAfter(now)) {
      return endTime.difference(now).inSeconds;
    } else {
      // Timer finished while app was closed
      await prefs.remove(_endTimeKey);
      return 0;
    }
  }
}
