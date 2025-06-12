import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

Future<String?> getDeviceId() async {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print(androidInfo.id);
    String androidDeviceId=androidInfo.id;

    return androidDeviceId.replaceAll(".", "");

  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    print(iosInfo.identifierForVendor);
    String? iosDeviceid=iosInfo.identifierForVendor;
    if (iosDeviceid==null){
      return iosDeviceid;
    }
    return iosDeviceid.replaceAll(".", "");

  } else {
    return 'unsupported_platform';
  }
}
