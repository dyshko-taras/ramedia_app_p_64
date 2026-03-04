import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../constants/app_strings.dart';
import '../data/repositories/settings_repository.dart';

class NotificationsService {
  NotificationsService._();

  static final NotificationsService instance = NotificationsService._();

  static const _dailyReminderId = 1001;
  static const _channelId = 'daily_reminder';
  static const _channelName = 'Daily Reminder';
  static const _channelDescription = 'Daily reminder to open the app.';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  bool _syncedOnLaunch = false;

  Future<void> initialize() async {
    if (_initialized) return;

    tz.initializeTimeZones();
    final info = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(info.identifier));

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(android: android, iOS: ios);

    await _plugin.initialize(settings);
    _initialized = true;
  }

  Future<bool> hasPermission() async {
    final status = await Permission.notification.status;
    return status.isGranted;
  }

  Future<bool> requestPermission() async {
    await initialize();

    if (Platform.isIOS || Platform.isMacOS) {
      final ok =
          await _plugin
              .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin
              >()
              ?.requestPermissions(alert: true, badge: true, sound: true);
      if (ok == true) return true;

      final okMac =
          await _plugin
              .resolvePlatformSpecificImplementation<
                MacOSFlutterLocalNotificationsPlugin
              >()
              ?.requestPermissions(alert: true, badge: true, sound: true);
      if (okMac == true) return true;

      return hasPermission();
    }

    final status = await Permission.notification.request();
    return status.isGranted;
  }

  Future<void> syncDailyReminderOnLaunch({
    required SettingsRepository settingsRepository,
  }) async {
    if (_syncedOnLaunch) return;
    _syncedOnLaunch = true;

    await initialize();

    final enabled = settingsRepository.getDailyReminderEnabled();
    if (!enabled) return;

    final status = await Permission.notification.status;
    if (!status.isGranted) return;

    await scheduleDailyReminder();
  }

  Future<void> scheduleDailyReminder({
    TimeOfDay time = const TimeOfDay(hour: 20, minute: 0),
  }) async {
    await initialize();

    await _plugin.cancel(_dailyReminderId);

    final scheduled = _nextInstanceOfTime(time);
    await _plugin.zonedSchedule(
      _dailyReminderId,
      AppStrings.dailyReminderTitle,
      AppStrings.dailyReminderBody,
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'daily_reminder',
    );
  }

  Future<void> cancelDailyReminder() async {
    await initialize();
    await _plugin.cancel(_dailyReminderId);
  }

  Future<void> showTestNotification() async {
    await initialize();
    await _plugin.show(
      2001,
      AppStrings.testNotificationTitle,
      AppStrings.testNotificationBody,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: 'test_notification',
    );
  }

  tz.TZDateTime _nextInstanceOfTime(TimeOfDay time) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
