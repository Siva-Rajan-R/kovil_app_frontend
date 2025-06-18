import 'package:hive_flutter/hive_flutter.dart';
import 'package:sampleflutter/utils/secure_storage_init.dart';

Future<void> deleteStoredLocalStorageValues()async {
  await Hive.box("eTagBox").clear();
  await Hive.box("eTagCachedDatasBox").clear();
  // await FirebaseMessaging.instance.unsubscribeFromTopic("all");
  // await FirebaseMessaging.instance.unsubscribeFromTopic("test");
  // await FirebaseMessaging.instance.deleteToken();
  
  await secureStorage.delete(key: 'accessToken');
  await secureStorage.delete(key: 'refreshToken');
  await secureStorage.delete(key: 'role');
  await secureStorage.delete(key: 'refreshTokenExpDate');
  await secureStorage.write(key: 'isLoggedIn', value: 'false');
}