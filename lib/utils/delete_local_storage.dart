
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sampleflutter/utils/secure_storage_init.dart';

Future<void> deleteStoredLocalStorageValues()async {

  await FirebaseMessaging.instance.unsubscribeFromTopic("all");
  await FirebaseMessaging.instance.deleteToken();
  
  await secureStorage.delete(key: 'accessToken');
  await secureStorage.delete(key: 'refreshToken');
  await secureStorage.delete(key: 'role');
  await secureStorage.delete(key: 'refreshTokenExpDate');
  await secureStorage.write(key: 'isLoggedIn', value: 'false');
}