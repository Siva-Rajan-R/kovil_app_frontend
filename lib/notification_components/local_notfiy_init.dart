
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';




final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


Future<void> showForegroundImageNotification(String? title, String? body, String? imageUrl) async {
  BigPictureStyleInformation? style;
  AndroidBitmap<Object>? largeIconBitmap;
  if (imageUrl != null) {
    try {
      final http.Response response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final Uint8List bytes = response.bodyBytes;
        final imageBitmap = ByteArrayAndroidBitmap(bytes);
        largeIconBitmap=imageBitmap;
        style = BigPictureStyleInformation(
          imageBitmap,
          contentTitle: title,
          summaryText: body,
          
        );
      } else {
        // Image not found or server error, skip image
        style = null;
      }
    } catch (e) {
      // Any network or decoding error, skip image
      print('Error loading image: $e');
      style = null;
    }
  }

  final androidDetails = AndroidNotificationDetails(
    'high_importance_channel',
    'High Importance Notifications',
    channelDescription: 'Used for important notifications',
    importance: Importance.max,
    priority: Priority.max,
    styleInformation: style,
    largeIcon: largeIconBitmap
  );

  final windowsDetails=WindowsNotificationDetails(

  );
  int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  await flutterLocalNotificationsPlugin.show(
    notificationId,
    title,
    body,
    NotificationDetails(android: androidDetails,windows: windowsDetails),
  );
}



Future<void> setupFlutterNotifications() async {

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@drawable/ic_cust');

  const WindowsInitializationSettings initializationSettingsWindows=
      WindowsInitializationSettings(
        appName: "guruvuthasan",
        appUserModelId: "com.example.sampleflutter",
        guid: '65a347f6-9288-441d-9d68-f75c36f98b79',
        iconPath: '@drawable/ic_cust'
      );

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid,windows: initializationSettingsWindows);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // ID
    'High Importance Notifications', // Name
    description: 'Used for important notifications',
    importance: Importance.high,
    

  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}