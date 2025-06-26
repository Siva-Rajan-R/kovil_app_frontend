import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sampleflutter/notification_components/fcm_init.dart';
import 'package:sampleflutter/notification_components/local_notfiy_init.dart';
import 'package:sampleflutter/pages/desktop_home.dart';
import 'package:sampleflutter/pages/forgot.dart';
import 'package:sampleflutter/pages/home.dart';
import 'package:sampleflutter/pages/login.dart';
import 'package:sampleflutter/pages/register.dart';
import 'package:sampleflutter/pages/tamil_calendar.dart';
import 'package:sampleflutter/utils/get_device_info.dart';
import 'package:sampleflutter/utils/global_variables.dart';
import 'package:sampleflutter/utils/secure_storage_init.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;






void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    if (Platform.isAndroid || Platform.isIOS){
      await Firebase.initializeApp();
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    }
    await setupFlutterNotifications();
    
    await Hive.initFlutter();
    await Hive.openBox("eTagBox");
    await Hive.openBox("eTagCachedDatasBox");
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation("Asia/Kolkata"));
    
  
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
    
    // gloablls
      deviceId=await getDeviceId() ?? "unkonown device";

      currentUserRole=await secureStorage.read(key: 'role');

      packageInfo = await PackageInfo.fromPlatform();

    print("device id is the bestaid $deviceId");
    print(loggedIn);
    
    // await Future.delayed(Duration(seconds: 60));
    return {
      "loggedIn": loggedIn == 'true',
    };
  }
  double _scale=0.5;
  @override
  void initState(){
    super.initState();
    if (Platform.isAndroid || Platform.isIOS){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        initFCM(context);
      });
    }
    futureCheckLogin=checkLogin(context);
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _scale = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder(
      future: futureCheckLogin,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              backgroundColor: Colors.orange.shade50,
              body: Center(
                child: AnimatedScale(
                  scale: _scale,
                  duration: Duration(seconds: 1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/svg/temple-india-svgrepo-com.svg",width: 100,height: 100,),
                      SizedBox(height: 10,),
                      Text("Guruvudhasan",style: TextStyle(color: Colors.orange,fontSize: 38,fontWeight: FontWeight.w700),),
                      SizedBox(height: 40,),
                    ],
                  ),
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
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'BalooThambi2',
              textTheme: ThemeData.light().textTheme.copyWith(
                bodyLarge: TextStyle(fontFamily: 'BalooThambi2'),
                bodyMedium: TextStyle(fontFamily: 'BalooThambi2'),
              ),
            ),
            home: isLoggedIn ? (MediaQuery.of(context).size.width>400) ? DesktopHomePage() : HomePage() :  LoginPage(),
            routes: {
              "/login": (context) =>  LoginPage(),
              "/register": (context) =>  RegisterPage(),
              "/forgot":(context)=>ForgotPage(),
              "/home": (context) =>  HomePage(),
              '/desktop-home':(context)=> DesktopHomePage(),
              "/tamil-calendar": (context) =>  TamilCalendarPage(),
              
              
            },
          );
        }
      },
    );
  }
}