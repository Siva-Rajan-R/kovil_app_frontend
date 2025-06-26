import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:sampleflutter/custom_controls/cust_snacbar.dart';
import 'package:sampleflutter/utils/network_request.dart';

// ignore: must_be_immutable
class ContactDescCard extends StatefulWidget {
  final eventDetails;

  
  const ContactDescCard({
    required this.eventDetails,
    super.key,
  });

  @override
  State<ContactDescCard> createState()=> _ContactDescCard();
}

class _ContactDescCard extends State<ContactDescCard>{
  bool isLoading=false;
  @override
  Widget build(BuildContext context) {
    final eventDetails=widget.eventDetails;
    return eventDetails['contact_description']==null? Center(child: Text("No data found"),)
    : PopScope(
      canPop: isLoading? false : true,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop){
          customSnackBar(content: "Wait until request complete...", contentType: AnimatedSnackBarType.info).show(context);
        }
      },
      child: Stack(
        children: [
          Column(
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 500),
                  child: Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.only(left: 10,right: 10,bottom: 10,top: 5),
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
                                      btnOkText: "Yes",
                                      width: MediaQuery.of(context).size.width>400? 500 : null,
                                      dismissOnTouchOutside: false,
                                      dismissOnBackKeyPress: false,
                                      dialogType: DialogType.info,
                                      animType: AnimType.topSlide,
                                      title: 'Delete Contact Description',
                                      desc: 'Are you sure , Do you Want to Delete Contact Description ?',
                                      btnCancelOnPress: () {},
                                      btnOkOnPress: () async {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        final res=await NetworkService.sendRequest(path: "/event/contact-description", context: context,method: "DELETE",body: {"contact_desc_id":eventDetails['contact_description_id']});
                                        setState(() {
                                            isLoading=false;
                                          });
                  
                                        if(res!=null){
                                          Navigator.popUntil(context, (route) => route.isFirst);
                                        }
                                      },
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/svg/date-svgrepo-com.svg",
                                    width: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    eventDetails["contact_description_updated_date"],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: 14
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/svg/alarm-clock-svgrepo-com.svg",
                                    width: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "${eventDetails["contact_description_updated_at"]}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: 14
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                            
                          SizedBox(height: 20,),
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/svg/user-svgrepo-com.svg",
                                width: 20,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "${eventDetails['contact_description_updated_by']}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: 18
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/svg/information-svgrepo-com.svg",
                              width: 20,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                eventDetails["contact_description"],
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
            ],
          ),
      
          if(isLoading)
            Positioned.fill(
              child: Center(
                child: CircularProgressIndicator(color: Colors.black),
              ),
            ),
        ],
      ),
    );
  }
}