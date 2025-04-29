
import 'dart:convert';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sampleflutter/custom_controls/cust_bottom_appbar.dart';
import 'package:sampleflutter/custom_controls/cust_snacbar.dart';
import 'package:sampleflutter/custom_controls/cust_textfield.dart';
import 'package:sampleflutter/custom_controls/custom_appbar.dart';
import 'package:sampleflutter/pages/home.dart';
import 'package:sampleflutter/utils/network_request.dart';

class StatusUpdatePageNext extends StatelessWidget{
  final Map previousPageData;

  final TextEditingController abisegam=TextEditingController();
  final TextEditingController helper=TextEditingController();
  final TextEditingController poo=TextEditingController();
  final TextEditingController read=TextEditingController();
  final TextEditingController prepare=TextEditingController();
  final TextEditingController tipsShared=TextEditingController();
  final TextEditingController tipsGivenTo=TextEditingController();

  StatusUpdatePageNext(
    {
      required this.previousPageData,
      super.key
    }
  );

  @override
  Widget build(BuildContext context) {
    print("image ${previousPageData['imageFile']}");
    return Scaffold(
      bottomNavigationBar: CustomBottomAppbar(
        bottomAppbarChild:Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                print(previousPageData['eventStatus']);
                Map formData={
                  "event_id":previousPageData['eventId'],
                  "event_status":previousPageData['eventStatus'],
                  "feedback":previousPageData["feedback"],
                  "tips":previousPageData["tips"],
                  "poojai":previousPageData['poojai'],
                  "abisegam":abisegam.text,
                  "helper":helper.text,
                  "poo":poo.text,
                  "read":read.text,
                  "prepare":prepare.text,
                  "tips_shared":tipsShared.text,
                  "tips_given_to":tipsGivenTo.text
                };
                
                final res=await NetworkService.sendRequest(
                  path: "/event/status", 
                  context: context,
                  method: "PUT",
                  isJson: false,
                  isMultipart: true,
                  imageFile: previousPageData['imageFile'],
                  body: formData
                );
                final decodedRes=jsonDecode(res.body);
                if(res.statusCode==200){
                  customSnackBar(content: decodedRes, contentType: AnimatedSnackBarType.success).show(context);
                  
                  Navigator.pushAndRemoveUntil(
                    context,
                    CupertinoPageRoute(builder: (context) => HomePage()),
                    (route) => false,
                  );
                }
                else if(res.statusCode==422){
                  customSnackBar(content: "Inputs Fields Couldn't be Empty", contentType: AnimatedSnackBarType.info).show(context);
                }
                else{
                  customSnackBar(content: decodedRes['detail'], contentType: AnimatedSnackBarType.error).show(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                
              ),
              child: Row(
                children: [
                  Text("Submit",style: TextStyle(color: Colors.white),),
                  SizedBox(width: 10,),
                  Icon(Icons.arrow_forward,color: Colors.white,)
                ],
              )
            ),
          ],
        ) 
      ),
      appBar: KovilAppBar(withIcon: true,),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: CustomTextField(
                label: "Abisegam",
                controller: abisegam,
              )
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(10),
              child: CustomTextField(
                label: "Helper",
                controller: helper,
              )
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(10),
              child: CustomTextField(
                label: "Poo",
                controller: poo,
              )
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(10),
              child: CustomTextField(
                label: "Read",
                controller: read,
              )
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(10),
              child: CustomTextField(
                label: "Prepare",
                controller: prepare,
              )
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: CustomTextField(
                label: "Tips shared",
                controller: tipsShared,
              )
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(10),
              child: CustomTextField(
                label: "Tips given to",
                controller: tipsGivenTo,
              )
            ),
            
            SizedBox(height: 20,),
            
          ],
          
        ),
      ),
    );
  }
}