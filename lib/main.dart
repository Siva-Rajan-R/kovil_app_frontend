
import 'package:flutter/material.dart';
import 'package:sampleflutter/pages/home.dart';
import 'package:sampleflutter/pages/login.dart';
import 'package:sampleflutter/pages/register.dart';
import 'package:sampleflutter/pages/tamil_calendar.dart';
import 'package:sampleflutter/utils/secure_storage_init.dart';


void main() {
  runApp(const MyKovilApp());
}

class MyKovilApp extends StatelessWidget {
  const MyKovilApp({super.key});

  Future checkLogin() async {
    String? loggedIn = await secureStorage.read(key: 'isLoggedIn');
    print(loggedIn);
    return {
      "loggedIn": loggedIn == 'true',
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkLogin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator())));
        } else {
          final bool isLoggedIn = snapshot.data['loggedIn'] ?? false;
          
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: isLoggedIn ? HomePage() :  LoginPage(),
            routes: {
              "/login": (context) =>  LoginPage(),
              "/register": (context) =>  RegisterPage(),
              "/home": (context) =>  HomePage(),
              "/tamil-calendar": (context) =>  TamilCalendarPage(),
            },
          );
        }
      },
    );
  }
}