import 'package:flutter/material.dart';
import 'package:sampleflutter/pages/home.dart';
import 'package:sampleflutter/pages/login.dart';
import 'package:sampleflutter/pages/register.dart';
import 'package:sampleflutter/pages/tamil_calendar.dart';

void main(){
  runApp(MyKovilApp());
}

class MyKovilApp extends StatelessWidget{
  const MyKovilApp({super.key});
  final isLoggedIn=false;
  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? HomePage() : LoginPage(),
      routes: {
        "/login":(context)=>LoginPage(),
        "/register":(context)=>RegisterPage(),
        "/home":(context)=>HomePage(),
        "/tamil-calendar":(context)=>TamilCalendarPage()
      },
    );
  }
}