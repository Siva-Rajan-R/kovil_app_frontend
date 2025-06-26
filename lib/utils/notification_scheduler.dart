import "dart:io";

import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:sampleflutter/notification_components/local_notfiy_init.dart";
import "package:timezone/timezone.dart" as tz;


Future scheduleFlutterLocalNotification(
  {
    required String title,
    required String body,
    required DateTime dateTime
  }
)async {
  final androidNotificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
      'custom_color_channel',
      'Custom Color Channel',
      channelDescription: 'Used for important notifications',
      importance: Importance.max,
      priority: Priority.max,
    ),
    windows: WindowsNotificationDetails()
  );

  if(Platform.isAndroid || Platform.isIOS){
    await flutterLocalNotificationsPlugin.zonedSchedule(
      DateTime.now().millisecondsSinceEpoch ~/ 1000, 
      title, 
      body, 
      tz.TZDateTime.from(dateTime,tz.local), 
      androidNotificationDetails, 
      androidScheduleMode: AndroidScheduleMode.exact,
      matchDateTimeComponents: DateTimeComponents.dateAndTime
    );
  }
}