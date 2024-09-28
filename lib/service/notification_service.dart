import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService() {
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    // Khởi tạo dữ liệu timezone
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher'); // Thay đổi thành tên icon của bạn

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleNotification(int id, String title, String body, DateTime scheduledTime) async {
    // Chuyển đổi DateTime thành TZDateTime
    final tz.TZDateTime tzDateTime = tz.TZDateTime.from(scheduledTime, tz.local);

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id', // ID kênh
      'your_channel_name', // Tên kênh
      channelDescription: 'your_channel_description', // Mô tả kênh
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzDateTime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
