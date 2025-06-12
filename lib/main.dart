
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sampleflutter/notification_components/fcm_init.dart';
import 'package:sampleflutter/notification_components/local_notfiy_init.dart';
import 'package:sampleflutter/pages/forgot.dart';
import 'package:sampleflutter/pages/home.dart';
import 'package:sampleflutter/pages/login.dart';
import 'package:sampleflutter/pages/register.dart';
import 'package:sampleflutter/pages/tamil_calendar.dart';
import 'package:sampleflutter/utils/builders/mandatory_update.dart';
import 'package:sampleflutter/utils/get_device_info.dart';
import 'package:sampleflutter/utils/global_variables.dart';
import 'package:sampleflutter/utils/random_loading.dart';
import 'package:sampleflutter/utils/secure_storage_init.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';






void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp();
  await setupFlutterNotifications();
  runApp(MyKovilApp());
}

class MyKovilApp extends StatefulWidget {
  const MyKovilApp({super.key});

  @override
  State<MyKovilApp> createState() => _MyKovilAppState();
}

class _MyKovilAppState extends State<MyKovilApp> {
  late Future futureCheckLogin;

  Future checkLogin(BuildContext context) async {
    String? loggedIn = await secureStorage.read(key: 'isLoggedIn');
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    deviceId=await getDeviceId() ?? "unkonown device";
    print("device id is the bestaid $deviceId");
    print(loggedIn);
    // final res=await NetworkService.sendRequest(path: "/app/version", context: context);
    final res={
      "current_version": "1.0.0",
      "is_debug": false,
      "is_mandatory": true,
      "android_update_url": "https://drive.google.com/file/d/1jcStDM7QhCcxKHhQasmIiuhBx-phXdjb/view?usp=drive_link",
      "is_trigger_login":false
    };
    return {
      "loggedIn": loggedIn == 'true',
      "packageInfo":packageInfo,
      "version_update_info":res
    };
  }

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initFCM(context);
    });
    futureCheckLogin=checkLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder(
      future: futureCheckLogin,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LottieBuilder.asset(getRandomLoadings()),
                    SizedBox(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Please wait while fetching",style: TextStyle(fontWeight: FontWeight.w600,color: Colors.orange),),
                        VerticalDivider(),
                        SizedBox(width: 30,height: 30, child: CircularProgressIndicator(color: Colors.orange,padding: EdgeInsets.all(5),))
                      ],
                    )
                  ],
                )
              )
            )
          );
          
        } 
        else if (snapshot.hasError || snapshot.data == null) {
          
            return MaterialApp(
              color: Colors.orange,
              home: Scaffold(
                body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LottieBuilder.asset("assets/lotties/something_went_wrong.json"),
                    SizedBox(),
                    Text("Something went wrong, check your connection",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w600,color: Colors.orange,fontSize: 20),),
                    TextButton(
                      onPressed: (){
                        setState(() {
                        futureCheckLogin=checkLogin(context);
                      });
                    }, 
                    child: Text("Try again",style: TextStyle(color: Colors.green),))
                  ],
                )
              )
              ),
            );
        }
        else {
          final bool isLoggedIn = snapshot.data['loggedIn'] ?? false;
          final PackageInfo packageInfo=snapshot.data["packageInfo"];
          final Map? versionUpdateInfo=snapshot.data["version_update_info"];
          String packageVersion=packageInfo.version;

          Map triggerVersionDialogInfo={
              "triggerDialog":false,
              "currentVersion":packageVersion,
              "oldVersion":packageVersion,
              "isMandatory":false,
              "updateUrl":"",
              "isTriggerLogin":false
          };

          if (versionUpdateInfo!=null){
            print("hii welocome to gere $versionUpdateInfo $packageVersion");
            String curVersion=versionUpdateInfo['current_version'];
            bool isMandatory=versionUpdateInfo["is_mandatory"];
            String updateUrl="";
            //   if (kIsWeb) {
            //   updateUrl = versionUpdateInfo["web_update_url"] ?? "";
            // } else if (defaultTargetPlatform == TargetPlatform.android) {
            //   updateUrl = versionUpdateInfo["android_update_url"] ?? "";
            // } else if (defaultTargetPlatform == TargetPlatform.iOS) {
            //   updateUrl = versionUpdateInfo["ios_update_url"] ?? "";
            // } else if (defaultTargetPlatform == TargetPlatform.windows) {
            //   updateUrl = versionUpdateInfo["windows_update_url"] ?? "";
            // } else if (defaultTargetPlatform == TargetPlatform.macOS) {
            //   updateUrl = versionUpdateInfo["macos_update_url"] ?? "";
            // }
            if(Platform.isAndroid){
              updateUrl=versionUpdateInfo["android_update_url"];
            }
            else if(Platform.isIOS){
              updateUrl=versionUpdateInfo["ios_update_url"];
            }
            else if(Platform.isWindows){
              updateUrl=versionUpdateInfo["windows_update_url"];
            }
            else{
              updateUrl=versionUpdateInfo["macos_update_url"];
            }

            if (curVersion!=packageVersion){
              triggerVersionDialogInfo["triggerDialog"]=true;
              triggerVersionDialogInfo["currentVersion"]=curVersion;
              triggerVersionDialogInfo["isMandatory"]=isMandatory;
              triggerVersionDialogInfo["updateUrl"]=updateUrl;
              triggerVersionDialogInfo['isTriggerLogin']=versionUpdateInfo['is_trigger_login'];
            }
          }

          print(triggerVersionDialogInfo['isMandatory']);
          return  triggerVersionDialogInfo['isMandatory']?
          MaterialApp(
            debugShowCheckedModeBanner: false,
            home: ShowMandatoryUpdate(triggerVersionDialogInfo: triggerVersionDialogInfo,)
          )
          : MaterialApp(
            debugShowCheckedModeBanner: false,
            home: isLoggedIn ? HomePage(triggerVersionDialogInfo: triggerVersionDialogInfo,) :  LoginPage(),
            routes: {
              "/login": (context) =>  LoginPage(),
              "/register": (context) =>  RegisterPage(),
              "/forgot":(context)=>ForgotPage(),
              "/home": (context) =>  HomePage(),
              "/tamil-calendar": (context) =>  TamilCalendarPage(),
              
            },
          );
        }
      },
    );
  }
}