import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sampleflutter/custom_controls/cust_textfield.dart';

// void main(){
//   runApp(LoginPage());
// }

class LoginPage extends StatelessWidget{
  LoginPage({super.key});
  final emailOrNo=TextEditingController();
  final password=TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              end: Alignment.topRight
            )
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child:SizedBox(
                    height: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/svg/hindu-temple-svgrepo-com.svg",
                              width: 40,
                              height: 40,
                            ),
                            Text(
                            "Nanmai Tharuvar Kovil",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold
                            ),
                                                  ),
                          ],
                        ),
                        
                      SizedBox(height: 10,),
                        
                      ],
                      ),
                  ),
                ),
            
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white70,
                     
                      borderRadius: BorderRadius.only(topLeft: Radius.elliptical(50,50),topRight: Radius.elliptical(50,50))
                    ),
                    child: Container(
                      margin: EdgeInsets.only(top: 10,left: 30,right: 30),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.orange.shade600,
                                fontSize: 25,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(height: 20),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomTextField(
                                  label: "Enter email or no",
                                  keyboardtype: TextInputType.text,
                                  controller: emailOrNo,
                                )
                              ),
                          
                            SizedBox(height: 20),
                            SizedBox(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomTextField(
                                  label: "Enter the password",
                                  keyboardtype: TextInputType.visiblePassword,
                                  controller: password,
                                )
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "Forgot Password ?",
                                    style: TextStyle(
                                      color: Colors.orange.shade900,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: (){
                                print("emailOrNo:${emailOrNo.text},passeord:${password.text}");
                                Navigator.pushReplacementNamed(context, "/home");
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                
                              ),
                              child: Text("Log in",style: TextStyle(color: Colors.white),)
                            ),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                        "Don't have an account ? ",
                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12
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
                                          fontSize: 12
                                        ),
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
        )
      );

  }
} 