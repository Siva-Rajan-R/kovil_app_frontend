import 'package:sampleflutter/utils/custom_print.dart';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sampleflutter/custom_controls/cust_snacbar.dart';
import 'package:sampleflutter/custom_controls/custom_dropdown.dart';
import 'package:sampleflutter/pages/assigned_events.dart';
import 'package:sampleflutter/utils/network_request.dart';

import 'package:sampleflutter/utils/open_phone.dart';

// ignore: must_be_immutable
class WorkersNameCard extends StatefulWidget {
  final String workerName;
  final String workerNo;
  final int workerParticipatedEvents;
  final List availableUsersList;
  final void Function(String workerName) onDelete;
  final void Function(Map updatedWorker,String workerNameToUpdate,String userIdToDelete) onUpdate;

  const WorkersNameCard({
    super.key,
    required this.workerName,
    required this.workerNo,
    required this.workerParticipatedEvents,
    required this.availableUsersList,
    required this.onDelete,
    required this.onUpdate
  });

  @override
  State<WorkersNameCard> createState()=> _WorkersNameCard();
}

class _WorkersNameCard extends State<WorkersNameCard>{
  bool isLoading=false;
  String selectedUserId='';
  String selectedUserName='';
  String selectedUserNo='';
  @override
  Widget build(BuildContext context) {
    final String workerName=widget.workerName;
    final String workerNo=widget.workerNo;
    final int workerParticipatedEvents=widget.workerParticipatedEvents;
    printToConsole(workerName);
    return PopScope(
      canPop: isLoading? false : true,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop){
          customSnackBar(content: "Wait until request complete...", contentType: AnimatedSnackBarType.info).show(context);
        }
      },
      child: Stack(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 500),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>AssignedEventsPage(workerName: workerName,canShowAppBar: true,)));
                  },
                  child: Container(
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
                                    width: MediaQuery.of(context).size.width>400? 500 : null,
                                    dialogType: DialogType.info,
                                    btnOkText: "Yes",
                                    animType: AnimType.topSlide,
                                    dismissOnBackKeyPress: false,
                                    dismissOnTouchOutside: false,
                                    title: 'Delete Worker Name',
                                    desc: 'Are you sure , Do you Want to Delete $workerName ?',
                                    btnCancelOnPress: () {},
                                    btnOkOnPress: () async{
                                      
                                      setState(() {
                                        
                                        isLoading=true;
                                      });
                                      
                                      final res=await NetworkService.sendRequest(path: "/worker", context: context,method: "DELETE",body: {"worker_name":workerName});
                                        printToConsole("hello $res");
                                        
                                        setState(() {
                                        isLoading=false;
                                      });
                                        if(res!=null){
                                          widget.onDelete(widget.workerName);
                                          // Navigator.pop(context);
                                        }
                                      }
                                  ).show();
                                }

                                if(value=='edit'){
                                  
                                  AwesomeDialog(
                                    context: context,
                                    width: MediaQuery.of(context).size.width>400? 500 : null,
                                    dialogType: DialogType.info,
                                    btnOkText: "Yes",
                                    animType: AnimType.topSlide,
                                    dismissOnBackKeyPress: false,
                                    dismissOnTouchOutside: false,
                                    title: 'Select the users',
                                    body: Column(
                                      children: [
                                        CustomDropdown(
                                          label: "Choose the user", 
                                          ddEntries: widget.availableUsersList.isNotEmpty? widget.availableUsersList.map((user){
                                            return DropdownMenuEntry(value: user, label: "${user['name']}-${user['role']}");
                                          }).toList() : [DropdownMenuEntry(value: null, label: "All the users are added")], 
                                          onSelected: (selectedValue){
                                            setState(() {
                                              selectedUserId=selectedValue['id'];
                                              selectedUserName=selectedValue['name'];
                                              selectedUserNo=selectedValue['mobile_number'];
                                            });
                                          },
                                        ),
                                        
                                      ],
                                    ),
                                    
                                    btnCancelOnPress: () {},
                                    btnOkOnPress: () async{
                                      setState(() {
                                          isLoading=true;
                                      });
                                      final res=await NetworkService.sendRequest(path: '/worker/user-id', context: context,method: 'PUT',body: {'worker_user_id':selectedUserId,'worker_name':workerName});
                                      setState(() {
                                        isLoading=false;
                                      });
                                      if (res!=null){
                                        final Map updatedWorkerInfo={
                                          'name':selectedUserName,
                                          'mobile_number':selectedUserNo,
                                        };
                                        widget.onUpdate(updatedWorkerInfo,workerName,selectedUserId);
                                      }
                                    }
                                  ).show();
                                }
                                
                              
                              },
                              itemBuilder: (context){
                                return [
                                  PopupMenuItem(value: "edit",child: Text("Have an app",style: TextStyle(color: Colors.orange.shade800))),
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
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap:()=> makePhoneCall(workerNo,context),
                                  child: Text(
                                    workerNo,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: 18,
                                      
                                    ),
                                    softWrap: true,
                                    
                                  ),
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
                ),
              ),
            ),
          ),
          if(isLoading)
            Positioned.fill(child:Center(child: CircularProgressIndicator(color: Colors.white,),)),
        ],
      ),
    );
  }
}