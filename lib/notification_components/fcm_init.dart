import 'package:flutter/material.dart';
import 'package:sampleflutter/notification_components/local_notfiy_init.dart';
import 'package:sampleflutter/utils/global_variables.dart';
import 'package:sampleflutter/utils/network_request.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:sampleflutter/utils/secure_storage_init.dart';


Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
      await Firebase.initializeApp();
      final notification = message.notification;
      final android = notification?.android;
      final imageUrl = android?.imageUrl;

      if (notification != null && android != null) {
        await showForegroundImageNotification(
          notification.title,
          notification.body,
          imageUrl,
        );
      }
    }

Future<void> initFCM(BuildContext context) async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request permissions (iOS only)
  await messaging.requestPermission();
  
  
  
  // Get FCM token
  String? token = await messaging.getToken();
  fcmToken=token;
  print("FCM Token: $fcmToken");
  
  final storedFcmToken=await secureStorage.read(key: 'fcmToken');
  if (storedFcmToken==null){
    await secureStorage.write(key: "fcmToken", value: fcmToken);
  }

  if (storedFcmToken!=fcmToken){
    print("triggers new token =======================================");
    NetworkService.sendRequest(
      path: "/app/notify/register-update", 
      context: context,
      method: "POST",
      body: {
        "fcm_token":fcmToken,
        "device_id":deviceId
      }
    );

    await secureStorage.write(key: "fcmToken", value: fcmToken);
  }
  //sending token to backend
  messaging.onTokenRefresh.listen((newFcmToken){
    print("triggred --------------------------------------------------- new token");
    NetworkService.sendRequest(
      path: "/app/notify/register-update", 
      context: context,
      method: "POST",
      body: {
        "fcm_token":newFcmToken,
        "device_id":deviceId
      }
    );
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  print('Foreground notification: ${message.notification}');
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  final notificationImageUrl = message.notification?.android?.imageUrl;

  if (notification != null && android != null) {
    // flutterLocalNotificationsPlugin.show(
    //   notification.hashCode,
    //   notification.title,
    //   notification.body,
    //   NotificationDetails(
    //     android: AndroidNotificationDetails(
    //       'high_importance_channel', // same ID
    //       'High Importance Notifications',
    //       importance: Importance.high,
    //       priority: Priority.high,
    //       icon: '@drawable/ic_cust',
    //       color: Colors.orange,
    //     ),
    //   ),
    // );

    showForegroundImageNotification(notification.title, notification.body, notificationImageUrl);
  }
});

FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  print('Notification clicked: ${message.notification?.title}');
  String screen=message.data["screen"];
  print("this is the go to screen $screen");

  if (screen=="events"){
    Navigator.pushNamed(context, "/tamil-calendar");
  }
});


}