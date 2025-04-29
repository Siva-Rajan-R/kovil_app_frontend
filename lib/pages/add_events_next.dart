import 'dart:convert';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sampleflutter/custom_controls/cust_bottom_appbar.dart';
import 'package:sampleflutter/custom_controls/cust_snacbar.dart';
import 'package:sampleflutter/custom_controls/custom_appbar.dart';
import 'package:sampleflutter/custom_controls/cust_textfield.dart';
import 'package:sampleflutter/pages/home.dart';
import 'package:sampleflutter/utils/network_request.dart';

class AddEventsNextPage extends StatelessWidget{

  final Map previousPageData;
  

  AddEventsNextPage(
    {
      required this.previousPageData,
      super.key
    }
  );
  
  @override
  Widget build(BuildContext context) {
    final TextEditingController clientName=TextEditingController();
    final TextEditingController clientCity=TextEditingController();
    final TextEditingController clientNumber=TextEditingController();
    final TextEditingController totalAmount=TextEditingController(text: previousPageData['eventAmount']);
    final TextEditingController paidAmount=TextEditingController();
    final TextEditingController paymentStatus=TextEditingController();
    final TextEditingController paymentMode=TextEditingController();
    
    print("${previousPageData['startTime']} ${previousPageData['endTime']}");
    return Scaffold(
      bottomNavigationBar: CustomBottomAppbar(
        bottomAppbarChild: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: ()async{
                      final res=await NetworkService.sendRequest(
                        path: "/event",
                        context: context,
                        method: 'POST',
                        body: {
                          "event_name": previousPageData['eventName'],
                          "event_description": previousPageData['eventDes'],
                          "event_date": previousPageData['eventDate'],
                          "event_start_at": previousPageData['startTime'],
                          "event_end_at": previousPageData['endTime'],
                          "client_name": clientName.text,
                          "client_mobile_number": clientNumber.text,
                          "client_city": clientCity.text,
                          "total_amount": totalAmount.text.isNotEmpty? int.parse(totalAmount.text) : 0,
                          "paid_amount": paidAmount.text.isNotEmpty? int.parse(paidAmount.text) : 0,
                          "payment_status": paymentStatus.text,
                          "payment_mode": paymentMode.text
                        }
                      );
                      final decodedRes=jsonDecode(res.body);
                      print(decodedRes);
                      if(res.statusCode==201){
                        customSnackBar(content: decodedRes, contentType: AnimatedSnackBarType.success).show(context);
                        
                        Navigator.pushAndRemoveUntil(
                          context,
                          CupertinoPageRoute(builder: (context) => HomePage()),
                          (route) => false,
                        );
                      }
                      else if(res.statusCode==422){
                        customSnackBar(content: "Input Fields Couldn't Be Empty", contentType: AnimatedSnackBarType.info).show(context);
                      }
                      else{
                        customSnackBar(content: decodedRes['detail'], contentType: AnimatedSnackBarType.error).show(context);
                      }
                      
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      
                    ),
                    child: Text("Submit",style: TextStyle(color: Colors.white),)
                  ),
              ],
            ),
      ),
      appBar: KovilAppBar(height: 100,),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.orange.shade400,
                  Colors.orange.shade600,
                  Colors.orange.shade800
                ]),
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.shade800,
                    blurRadius: 5,
                    spreadRadius: 2,
                    blurStyle: BlurStyle.outer
                  )
                ]
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Client Info",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 20
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    CustomTextField(label:"Client name" ,themeColor: Colors.white,fontColor: Colors.white,controller: clientName,),
                    SizedBox(height: 20,),
                    CustomTextField(label: "Client Number",themeColor: Colors.white,fontColor: Colors.white,keyboardtype: TextInputType.number,controller: clientNumber,),
                    SizedBox(height: 20,),
                    CustomTextField(label: "Client place",themeColor: Colors.white,fontColor: Colors.white,keyboardtype: TextInputType.streetAddress,controller: clientCity,),
                    SizedBox(height: 20,),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.orange.shade400,
                  Colors.orange.shade600,
                  Colors.orange.shade800
                ]),
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.shade800,
                    blurRadius: 5,
                    spreadRadius: 2,
                    blurStyle: BlurStyle.outer
                  )
                ]
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Payment Info",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 20
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    CustomTextField(label:"Total amount" ,themeColor: Colors.white,fontColor: Colors.white,keyboardtype: TextInputType.number,controller: totalAmount,),
                    SizedBox(height: 20,),
                    CustomTextField(label: "Paid amount",themeColor: Colors.white,fontColor: Colors.white,keyboardtype: TextInputType.number,controller: paidAmount,),
                    SizedBox(height: 20,),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          DropdownMenu(
                              width: 280,
                              controller: paymentMode,
                              label: Text("Payment mode"),
                              menuStyle: MenuStyle(
                                backgroundColor: WidgetStatePropertyAll<Color>(Colors.orange.shade100)
                              ),
                              dropdownMenuEntries: [
                                DropdownMenuEntry(value: "online", label: "online"),
                                DropdownMenuEntry(value: "offline", label: "offline")
                              ],
                            ),
                            SizedBox(width: 10,),
                            DropdownMenu(
                              width: 280,
                              controller: paymentStatus,
                              label: Text("Payment status"),
                              menuStyle: MenuStyle(
                                backgroundColor: WidgetStatePropertyAll<Color>(Colors.orange.shade100)
                              ),
                              dropdownMenuEntries: [
                                DropdownMenuEntry(value: "fully paid", label: "fully paid"),
                                DropdownMenuEntry(value: "partially paid", label: "partially paid"),
                                DropdownMenuEntry(value: "not paid", label: "not paid")
                              ],
                            ),
                        ],
                      ),
                    ),
                    
                  ],
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
