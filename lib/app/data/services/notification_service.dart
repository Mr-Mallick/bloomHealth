import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../models/medicine_model.dart';

class NotificationService extends GetxService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<NotificationService> init() async {
    // await _initializeTimeZone();
    await _initializeNotifications();
    await _requestPermissions();
    return this;
  }

  Future<void> _initializeTimeZone() async {
    tz.initializeTimeZones();
    // Set local timezone - you can change this to your actual timezone
    tz.setLocalLocation(tz.getLocation('America/New_York')); // Change to your timezone
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );
  }

  Future<void> _requestPermissions() async {
    await Permission.notification.request();

    // Request exact alarm permission for Android 12+
    if (GetPlatform.isAndroid) {
      await Permission.scheduleExactAlarm.request();
    }
  }

  void _onNotificationTap(NotificationResponse notificationResponse) {
    // Handle notification tap
    // print('Notification tapped: ${notificationResponse.payload}');
  }

  // FIXED: Updated method with proper validation
  Future<void> schedulePeriodReminder({
    required int id,
    required DateTime scheduledTime,
    required String title,
    required String body,
  }) async {
    try {
      // Validate that the scheduled time is in the future
      final now = DateTime.now();
      if (scheduledTime.isBefore(now)) {
        // print('⚠️ Skipping notification $id: Scheduled time $scheduledTime is in the past (now: $now)');
        return;
      }

      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'period_channel',
        'Period Reminders',
        channelDescription: 'Notifications for period cycle reminders',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: false,
        icon: '@mipmap/ic_launcher',
      );

      const DarwinNotificationDetails iOSPlatformChannelSpecifics =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );

      final tzDateTime = _convertToTZDateTime(scheduledTime);
      
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzDateTime,
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'period_$id',
      );

      // print('✅ Period notification $id scheduled successfully for $tzDateTime');
    } catch (e) {
      // print('❌ Error scheduling period notification $id: $e');
      // Don't throw error, just log it
    }
  }

  Future<void> scheduleMedicineNotification({
    required int id,
    required String medicineName,
    required DateTime scheduledTime,
    required MedicineType type,
  }) async {
    try {
      // Validate future date
      if (scheduledTime.isBefore(DateTime.now())) {
        // print('⚠️ Skipping medicine notification $id: Time is in the past');
        return;
      }

      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'medicine_channel',
        'Medicine Reminders',
        channelDescription: 'Notifications for medicine reminders',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
        icon: '@mipmap/ic_launcher',
      );

      const DarwinNotificationDetails iOSPlatformChannelSpecifics =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );

      String typeEmoji = _getMedicineTypeEmoji(type);

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        'Medicine Reminder $typeEmoji',
        'Time to take your $medicineName',
        _convertToTZDateTime(scheduledTime),
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'medicine_$id',
      );

      print('✅ Medicine notification $id scheduled successfully');
    } catch (e) {
      // print('❌ Error scheduling medicine notification $id: $e');÷\
    }
  }

  Future<void> scheduleFluidReminder({
    required int id,
    required DateTime scheduledTime,
    required String message,
  }) async {
    try {
      // Validate future date
      if (scheduledTime.isBefore(DateTime.now())) {
        // print('⚠️ Skipping fluid notification $id: Time is in the past');
        return;
      }

      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'fluid_channel',
        'Fluid Reminders',
        channelDescription: 'Notifications for fluid intake reminders',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        showWhen: false,
        icon: '@mipmap/ic_launcher',
      );

      const DarwinNotificationDetails iOSPlatformChannelSpecifics =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        'Hydration Reminder 💧',
        message,
        _convertToTZDateTime(scheduledTime),
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'fluid_$id',
      );

      // print('✅ Fluid notification $id scheduled successfully');
    } catch (e) {
      // print('❌ Error scheduling fluid notification $id: $e');
    }
  }

  Future<void> scheduleRepeatingFluidReminder({
    required int id,
    required DateTime firstNotificationTime,
    required Duration interval,
    required String message,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'fluid_channel',
      'Fluid Reminders',
      channelDescription: 'Notifications for fluid intake reminders',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      showWhen: false,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.periodicallyShow(
      id,
      'Hydration Reminder 💧',
      message,
      _getRepeatInterval(interval),
      platformChannelSpecifics,
      payload: 'fluid_repeating_$id',
      androidAllowWhileIdle: true,
    );
  }

  RepeatInterval _getRepeatInterval(Duration interval) {
    if (interval.inMinutes <= 15) {
      return RepeatInterval.everyMinute;
    } else if (interval.inHours <= 1) {
      return RepeatInterval.hourly;
    } else {
      return RepeatInterval.daily;
    }
  }

  tz.TZDateTime _convertToTZDateTime(DateTime dateTime) {
    try {
      // Use the automatically detected local timezone
      return tz.TZDateTime.from(dateTime, tz.local);
    } catch (e) {
      // debugPrint('❌ Error converting timezone: $e');
      // Fallback to UTC if conversion fails
      final utc = tz.getLocation('UTC');
      return tz.TZDateTime.from(dateTime, utc);
    }
  }

  String _getMedicineTypeEmoji(MedicineType type) {
    switch (type) {
      case MedicineType.tablet:
        return '💊';
      case MedicineType.syrup:
        return '🧴';
      case MedicineType.drops:
        return '💧';
      case MedicineType.injection:
        return '💉';
      case MedicineType.capsule:
        return '💊';
    }
  }

  Future<void> cancelNotification(int id) async {
    try {
      await _flutterLocalNotificationsPlugin.cancel(id);
      // print('✅ Notification $id cancelled successfully');
    } catch (e) {
      // print('⚠️ Error cancelling notification $id: $e');
    }
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'instant_channel',
      'Instant Notifications',
      channelDescription: 'Instant notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  // Debug method to check pending notifications
  Future<void> debugScheduledNotifications() async {
    try {
      final pendingNotifications = await getPendingNotifications();
      // print('📱 Pending notifications: ${pendingNotifications.length}');
      
      for (var notification in pendingNotifications) {
        // print('  ID: ${notification.id}, Title: ${notification.title}');
      }
    } catch (e) {
      // print('Error getting pending notifications: $e');
    }
  }
}