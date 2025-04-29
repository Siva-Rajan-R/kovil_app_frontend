import 'dart:convert';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sampleflutter/custom_controls/cust_snacbar.dart';
import 'package:sampleflutter/custom_controls/cust_textfield.dart';
import 'package:sampleflutter/pages/home.dart';
import 'package:sampleflutter/utils/network_request.dart';


Widget addNewEventName({required BuildContext context}){
  final TextEditingController eventName=TextEditingController();
  final TextEditingController eventPrice=TextEditingController();
  return Column(
    children: [
      CustomTextField(label: "Event name",controller: eventName,),
      SizedBox(height: 10,),
      CustomTextField(label: "Event price",controller: eventPrice,keyboardtype: TextInputType.number,),
      SizedBox(height: 10,),
      ElevatedButton(
        onPressed: ()async{
          print("${eventName.text} ${eventPrice.text}");
          final res=await NetworkService.sendRequest(
            path: "/event/name", 
            context: context,
            method: "POST",
            body: {
              "event_name":eventName.text.trim(),
              "event_amount":eventPrice.text.isNotEmpty? int.parse(eventPrice.text) : 0
            }
          );

          final decodedRes=jsonDecode(res.body);
          print(decodedRes);
          if (res.statusCode==201){
            customSnackBar(content: decodedRes, contentType: AnimatedSnackBarType.success).show(context);
            Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(builder: (context) => HomePage()),
              (route) => false,
            );

            

          }

          else if (res.statusCode==422){
            customSnackBar(content: "Input Fields Couldn't be Empty", contentType: AnimatedSnackBarType.info).show(context);
          }

          else{
            customSnackBar(content: decodedRes, contentType: AnimatedSnackBarType.error).show(context);
          }
        }, 
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
        ),
        child: Text("Register",style: TextStyle(color: Colors.white),)
      )
    ],
  );
} 