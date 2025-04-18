import 'package:flutter/material.dart';
import 'package:sampleflutter/custom_controls/cust_textfield.dart';
import 'package:flutter_svg/flutter_svg.dart';

// void main(){
//   runApp(RegisterPage());
// }

class RegisterPage extends StatelessWidget{
  RegisterPage({super.key});
  final TextEditingController name=TextEditingController();
  final TextEditingController email=TextEditingController();
  final TextEditingController mobileNumber=TextEditingController();
  final TextEditingController role=TextEditingController();
  final TextEditingController password=TextEditingController();
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
                    height:100,
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
                          "Register",
                          style: TextStyle(
                            color: Colors.orange.shade600,
                            fontSize: 25,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(height: 10,),
                            SizedBox(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomTextField(
                                  label: "Enter the name",
                                  controller: name,
                                  keyboardtype: TextInputType.name,
                                )
                              ),
                            ),
                            SizedBox(height: 10,),
                            Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CustomTextField(
                                    label: "Enter email",
                                    controller: email,
                                    keyboardtype: TextInputType.emailAddress,
                                  )
                                ),
                            
                            SizedBox(height: 10,),
                            SizedBox(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomTextField(
                                  label: "Enter mobile number",
                                  controller: mobileNumber,
                                  keyboardtype: TextInputType.number,
                                )
                              ),
                            ),
                            SizedBox(height: 10),
                            SizedBox(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomTextField(
                                  label: "Enter the password",
                                  controller: password,
                                  keyboardtype: TextInputType.visiblePassword,
                                )
                              ),
                            ),
                            SizedBox(height: 10,),
                            DropdownMenu(
                              width: 280,
                              label: Text("Role"),
                              controller: role,
                              menuStyle: MenuStyle(
                                backgroundColor: MaterialStatePropertyAll<Color>(Colors.orange.shade100)
                              ),
                              dropdownMenuEntries: [
                                DropdownMenuEntry(value: "admin", label: "Admin"),
                                DropdownMenuEntry(value: "user", label: "User")
                              ],
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () => print("${name.text},${email.text},${mobileNumber.text},${role.text},${password.text}"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                
                              ),
                              child: Text("Register",style: TextStyle(color: Colors.white),)
                            ),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                        "Already have an account ? ",
                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12
                                        ),
                                      ),
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: ()=>Navigator.pushReplacementNamed(context, "/login"),
                                    child: Text(
                                        "Log in",
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