import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sampleflutter/utils/network_request.dart';

// ignore: must_be_immutable
class EventNameAmountCard extends StatefulWidget {
  final int eventNameId;
  final String eventName;
  final String eventAmount;
  final bool isForNeivethiyam;
  final bool isForSpecial;
  final int curIndex;
  final void Function(bool isForNeivethiyam,bool isForSpecial,int indexToDelete) onDelete;

  const EventNameAmountCard({
    super.key,
    required this.eventNameId,
    required this.eventName,
    required this.eventAmount,
    required this.isForNeivethiyam,
    required this.isForSpecial,
    required this.curIndex,
    required this.onDelete
  });

  @override
  State<EventNameAmountCard> createState()=> _EventNameAmountCard();
}

class _EventNameAmountCard extends State<EventNameAmountCard>{
  bool isLoading=false;
  @override
  Widget build(BuildContext context) {
    final String eventName=widget.eventName;
    final String eventAmount=widget.eventAmount;

    return Stack(
      children: [
        Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: Container(
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
                              title: 'Delete Event Name',
                              desc: 'Are you sure , Do you Want to Delete $eventName ?',
                              btnCancelOnPress: () {},
                              btnOkOnPress: () async{
                                setState(() {
                                  isLoading=true;
                                });
                                String path="/event/name";
                                Map body={"event_name":eventName};
                                
                                if(widget.isForNeivethiyam){
                                  print("jiiiiiiii");
                                  path="/neivethiyam/name";
                                  body={"neivethiyam_name":eventName};
                                }
                                final res=await NetworkService.sendRequest(path: path, context: context,method: "DELETE",body: body);
                                  print("hello $res");
            
                                  setState(() {
                                  isLoading=false;
                                });
                                  if(res!=null){
                                    widget.onDelete(widget.isForNeivethiyam,widget.isForSpecial,widget.curIndex);
                                    // Navigator.pop(context);
                                  }
                                  
                                }
                            ).show();
                          }
                        },
                        itemBuilder: (context){
                          return [
                            PopupMenuItem(value: "delete",child: Text("Delete",style: TextStyle(color: Colors.orange.shade800)))
                          ];
                        }
                      )
                    ],
                  ),
                Row(
                    children: [
                      SvgPicture.asset(
                        "assets/svg/event svy.svg",
                        width: 20,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          eventName,
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
                        "assets/svg/money-bag-svgrepo-com.svg",
                        width: 20,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "$eventAmount ₹",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 18,
                            
                          ),
                          softWrap: true,
                          
                        ),
                      ),
                    ],
                  ),
              ],
            ),
              ),
          ),
        ),
        if(isLoading)
          Positioned.fill(child:Center(child: CircularProgressIndicator(color: Colors.white,),)),
      ],
    );
  }
}