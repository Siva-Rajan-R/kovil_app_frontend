import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:sampleflutter/pages/home.dart';
import 'package:sampleflutter/utils/network_request.dart';

import 'package:sampleflutter/utils/open_phone.dart';

// ignore: must_be_immutable
class WorkersNameCard extends StatefulWidget {
  final String workerName;
  final String workerNo;
  final int workerParticipatedEvents;

  const WorkersNameCard({
    super.key,
    required this.workerName,
    required this.workerNo,
    required this.workerParticipatedEvents
  });

  @override
  State<WorkersNameCard> createState()=> _WorkersNameCard();
}

class _WorkersNameCard extends State<WorkersNameCard>{
  bool isLoading=false;
  @override
  Widget build(BuildContext context) {
    final String workerName=widget.workerName;
    final String workerNo=widget.workerNo;
    final int workerParticipatedEvents=widget.workerParticipatedEvents;
    print("$workerName");
    return Stack(
      children: [
        Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        width: double.infinity,
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
        child: Column(
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PopupMenuButton(
                    icon: Icon(Icons.more_horiz,color: Colors.white,),
                    onSelected: (value)async{
                      if(value=="delete"){
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.info,
                          btnOkText: "Yes",
                          animType: AnimType.topSlide,
                          dismissOnBackKeyPress: false,
                          dismissOnTouchOutside: false,
                          title: 'Delete Worker Name',
                          desc: 'Are you sure , Do you Want to Delete ${workerName} ?',
                          btnCancelOnPress: () {},
                          btnOkOnPress: () async{
                            setState(() {
                              isLoading=true;
                            });
                            
                            final res=await NetworkService.sendRequest(path: "/worker", context: context,method: "DELETE",body: {"worker_name":workerName});
                              print("hello ${res}");
                              
                              setState(() {
                              isLoading=false;
                            });
                              if(res!=null){
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  CupertinoPageRoute(builder: (context) => HomePage()),
                                  (route) => false,
                                );
                              }
                            }
                        ).show();
                      }
                      
                    
                    },
                    itemBuilder: (context){
                      return [
                        PopupMenuItem(value: "delete",child: Text("Delete",style: TextStyle(color: Colors.orange.shade800))),
                      ];
                    }
                  )
                ],
              ),
            Row(
                children: [
                  SvgPicture.asset(
                    "assets/svg/user-svgrepo-com.svg",
                    width: 20,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      workerName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 18
                      ),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  SvgPicture.asset(
                    "assets/svg/mobile-phone-svgrepo-com.svg",
                    width: 20,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap:()=> makePhoneCall(workerNo,context),
                      child: Text(
                        "$workerNo",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 18,
                          
                        ),
                        softWrap: true,
                        
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/svg/event svy.svg",
                          width: 20,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "$workerParticipatedEvents",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 18,
                            
                          ),
                          softWrap: true,
                          
                        ),
                      ],
                    ),
                  ),
                  
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/svg/money-cash-svgrepo-com.svg",
                        width: 20,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "${workerParticipatedEvents*50} ₹",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 18,
                          
                        ),
                        softWrap: true,
                        
                      ),
                      SizedBox(width: 10)
                    ],
                  ),
                ],
              ),
          ],
        ),
          ),
        if(isLoading)
          Positioned.fill(child:Center(child: CircularProgressIndicator(color: Colors.white,),)),
      ],
    );
  }
}