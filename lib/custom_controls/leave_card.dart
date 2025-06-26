import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sampleflutter/utils/convert_utc_to_local.dart';
import 'package:sampleflutter/utils/enums.dart';
import 'package:sampleflutter/utils/global_variables.dart';
import 'package:sampleflutter/utils/network_request.dart';

class LeaveCard extends StatefulWidget {
  final Map leaveDetails;
  final bool isLeaveManagement;
  final void Function(int leaveId,String listToDelete) onDelete;
  final void Function(Map leaveDetails,String listToUpdate) onLeaveStatusUpdate;

  const LeaveCard(
    {
      super.key,
      required this.leaveDetails,
      required this.onDelete,
      required this.onLeaveStatusUpdate,
      this.isLeaveManagement=false
    }
  );

  @override
  State<LeaveCard> createState() => _LeaveCardState();
}

class _LeaveCardState extends State<LeaveCard> {
  bool isLoading=false;
  String selectedStatus='';
 

  @override
  Widget build(BuildContext context) {
    final leaveDetails=widget.leaveDetails;
     List labels=(leaveDetails['status']=='waiting')? ['rejected','accepted'] : (leaveDetails['status']=='rejected')? ['waiting','accepted'] : ['waiting','rejected'];
    return Stack(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 500),
              child: Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.orange.shade400,
                      Colors.orange.shade600,
                      Colors.orange.shade800
                    ]),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/svg/date-svgrepo-com.svg",
                                width: 15,
                              ),
                              SizedBox(width: 10),
                              Text(
                                formatUtcToLocal(leaveDetails['datetime']),
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  fontSize: 12,
                            
                                ),
                              ),
                            ],
                          ),

                          ((currentUserRole==UserRoleEnum.ADMIN.name && widget.isLeaveManagement) || (leaveDetails['status']=='waiting'))? 
                          PopupMenuButton(
                            icon: Icon(Icons.more_horiz,color: Colors.white,),
                            onSelected: (value){
                              if(value=="delete"){
                                AwesomeDialog(
                                  width: MediaQuery.of(context).size.width>400? 500 : null,
                                  context: context,
                                  btnOkText: "Yes",
                                  dismissOnTouchOutside: false,
                                  dismissOnBackKeyPress: false,
                                  dialogType: DialogType.info,
                                  animType: AnimType.topSlide,
                                  title: 'Delete Leave',
                                  desc: 'Are you sure , Do you Want to Delete Leave Request ?',
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    final res=await NetworkService.sendRequest(path: "/user/leave", context: context,method: "DELETE",body: {"leave_id":leaveDetails['id']});
                                    print(res);
                                    setState(() {
                                        isLoading=false;
                                      });
                                    if(res!=null){
                                      
                                      widget.onDelete(leaveDetails['id'],leaveDetails['status']);
                                    //  Navigator.pop(context);
                                    }
                                  },
                                ).show();
                              }
                            },
                            itemBuilder: (context)=>[PopupMenuItem(value: "delete",child: Text("Delete",style: TextStyle(color: Colors.orange.shade800))),]
                          ) : Text(''),
                        ],
                      ),
                    (currentUserRole==UserRoleEnum.ADMIN.name)
                     ? Row(
                        children: [
                          SvgPicture.asset(
                            "assets/svg/user-svgrepo-com.svg",
                            width: 15,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              leaveDetails["name"]?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 16
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ) : Text(''),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/svg/question-mark-svgrepo-com.svg",
                            width: 15,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              leaveDetails['reason']?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 16
                              ),
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              "${leaveDetails['from_date']?? ''}  to  ${leaveDetails['to_date']?? ''}",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 16
                              ),
                              softWrap: true,
                              textAlign: TextAlign.center,
                              
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),
                      ((currentUserRole==UserRoleEnum.ADMIN.name) && widget.isLeaveManagement)?
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for(String labelName in labels)
                            OutlinedButton(
                              style: ButtonStyle(
                                shadowColor: WidgetStatePropertyAll(Colors.white),
                                overlayColor: WidgetStatePropertyAll(Colors.orange),
                                side: WidgetStatePropertyAll(BorderSide(color: Colors.white))
                              ),
                              onPressed: ()async{
                                setState(() {
                                  isLoading=true;
                                });

                                final res=await NetworkService.sendRequest(path: '/user/leave/status', context: context,method: 'PUT',body: {'leave_id':leaveDetails['id'],'leave_status':labelName});

                                
                                  setState(() {
                                    isLoading=false;
                                  });
                                  
                                  if (res!=null){
                                    widget.onLeaveStatusUpdate(leaveDetails,labelName);
                                  }
                                
                              }, 
                              child: Text(labelName,style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white),)
                            )
                        ],
                      ): SizedBox.shrink()
                    ],
                  ),
              ),
            ),
          ),
      
          if(isLoading)
            Positioned.fill(
              child: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
            
          
        ],
      );
  }
}