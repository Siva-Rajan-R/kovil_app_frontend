
import 'package:sampleflutter/utils/custom_print.dart';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sampleflutter/custom_controls/cust_snacbar.dart';

import 'package:sampleflutter/custom_controls/cust_textfield.dart';
import 'package:sampleflutter/utils/global_variables.dart';
import 'package:sampleflutter/utils/network_request.dart';


class ForgotPage extends StatefulWidget {
  const ForgotPage({super.key});

  @override
  State<ForgotPage> createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  final emailOrNo = TextEditingController();
  final password = TextEditingController();
  List<FocusNode> focusNodes = List.generate(2, (_) => FocusNode());
  bool isLoading = false;

  Future onForgotPassword()async{
    setState(() {
      isLoading = true;
    });

    printToConsole("emailOrNo:${emailOrNo.text},password:${password.text}");
    final res = await NetworkService.sendRequest(
        path: '/forgot',
        context: context,
        method: 'PUT',
        body: {
          'email_or_no': emailOrNo.text,
          'new_password': password.text,
          'fcm_token':fcmToken,

          },
        isLoginPage: true
    );

    if (res!=null) {
      Navigator.pushReplacementNamed(
          context, "/login");
    } 

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: isLoading? false : true,
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
                    Colors.orange.shade800
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.topRight)),
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
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
                            topRight: Radius.elliptical(50, 50))),
                    child: Container(
                      margin: EdgeInsets.only(top: 10, left: 30, right: 30),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Forgot",
                              style: TextStyle(
                                  color: Colors.orange.shade600,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
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
                                )),
                            SizedBox(height: 20),
                            SizedBox(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CustomTextField(
                                    label: "Enter the New password",
                                    keyboardtype: TextInputType.visiblePassword,
                                    controller: password,
                                    focusNode: focusNodes[1],
                                    onSubmitted: isLoading
                                    ? null
                                    : (_) => onForgotPassword(),
                                  )),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () => onForgotPassword(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                ),
                                child: Text(
                                  isLoading ? "Forgetting..." : "Forgot",
                                  style: TextStyle(color: Colors.white),
                                )),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Go to login page ? ",
                                  style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12),
                                ),
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () => Navigator.pushReplacementNamed(
                                        context, "/login"),
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                          color: Colors.orange.shade900,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
