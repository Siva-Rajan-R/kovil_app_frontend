
import 'dart:io';
import 'package:sampleflutter/utils/custom_print.dart';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sampleflutter/custom_controls/cust_snacbar.dart';
import 'package:sampleflutter/custom_controls/cust_textfield.dart';
import 'package:sampleflutter/utils/global_variables.dart';
import 'package:sampleflutter/utils/network_request.dart';
import 'package:sampleflutter/utils/secure_storage_init.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailOrNo = TextEditingController();
  final password = TextEditingController();
  List<FocusNode> focusNodes = List.generate(2, (_) => FocusNode());

  bool _isLoading = false;

  Future<void> _login(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    final res = await NetworkService.sendRequest(
      path: '/login',
      context: context,
      method: 'POST',
      body: {
        'email_or_no': emailOrNo.text,
        'password': password.text,
      },
      isLoginPage: true
    );
    if (!mounted) return;

    if (Platform.isAndroid || Platform.isIOS){
      await NetworkService.sendRequest(
        path: "/app/notify/register-update", 
        context: context,
        method: "POST",
        body: {
          "fcm_token":fcmToken,
          "device_id":deviceId,
          "user_email_or_no":emailOrNo.text
        },
        isLoginPage: true
      );
    }

    if (!mounted) return;

    
    if (res!=null) {
      printToConsole("1234567890`0`hruihrf ulla ${context.mounted}");
      if (Platform.isAndroid || Platform.isIOS){
        await FirebaseMessaging.instance.subscribeToTopic("all");
        await FirebaseMessaging.instance.subscribeToTopic("test");
      }
      await secureStorage.write(key: "accessToken", value: res['access_token']);
      await secureStorage.write(key: "refreshToken", value: res['refresh_token']);
      printToConsole("999999999999999999999999999999999999999999999999${await secureStorage.read(key: "refreshToken")}");
      await secureStorage.write(key: 'role', value: res['role']);
      await secureStorage.write(key: 'refreshTokenExpDate', value: res['refresh_token_exp_date']);
      await secureStorage.write(key: 'isLoggedIn', value: 'true');

      currentUserRole=res['role'];

      await Navigator.pushReplacementNamed(context, MediaQuery.of(context).size.width>600? '/desktop-home' : '/home');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _isLoading? false : true,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop){
          customSnackBar(content: "Wait until request complete...", contentType: AnimatedSnackBarType.info).show(context);
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.orange.shade400,
                Colors.orange.shade700,
                Colors.orange.shade800,
              ],
              begin: Alignment.topLeft,
              end: Alignment.topRight,
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/svg/hindu-temple-svgrepo-com.svg",
                          width: 60,
                        ),
                        Text(
                          "Guruvudhasan",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.elliptical(50, 50),
                        topRight: Radius.elliptical(50, 50),
                      ),
                    ),
                    child: Container(
                      margin: EdgeInsets.only(top: 10, left: 30, right: 30),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.orange.shade600,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomTextField(
                                label: "Enter email or number",
                                keyboardtype: TextInputType.text,
                                controller: emailOrNo,
                                focusNode: focusNodes[0],
                                onSubmitted: (_){
                                  FocusScope.of(context).requestFocus(focusNodes[1]);
                                },
                              ),
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomTextField(
                                label: "Enter the password",
                                keyboardtype: TextInputType.visiblePassword,
                                controller: password,
                                focusNode: focusNodes[1],
                                onSubmitted: _isLoading ? null : (_) => _login(context)
                                ,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () => Navigator.popAndPushNamed(context, '/forgot'),
                                      child: Text(
                                        "Forgot Password ?",
                                        style: TextStyle(
                                          color: Colors.orange.shade900,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _isLoading ? null : () => _login(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                              ),
                              child: _isLoading
                                  ? SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.0,
                                      ),
                                    )
                                  : Text(
                                      "Log in",
                                      style: TextStyle(color: Colors.white),
                                    ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account ? ",
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () => Navigator.pushReplacementNamed(context, "/register"),
                                    child: Text(
                                      "Register",
                                      style: TextStyle(
                                        color: Colors.orange.shade900,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
