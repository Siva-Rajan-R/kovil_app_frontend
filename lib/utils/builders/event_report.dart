import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sampleflutter/custom_controls/custom_ad.dart';
import 'package:sampleflutter/utils/convert_utc_to_local.dart';
import 'package:sampleflutter/utils/enums.dart';
import 'package:sampleflutter/utils/global_variables.dart';
import 'package:sampleflutter/utils/network_request.dart';

Widget buildRows(String title){
  return Row(
      children: [
        
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontSize: 18
            ),
            softWrap: true,
          ),
        ),
      ]
    );
}

Widget buildEventReport(Map eventDetails,BuildContext context,{bool isForAssign=false}){
  print(eventDetails["updated_at"]);
  
  String updatedAt=eventDetails["completed_updated_at"] ?? "Not Updated";
  String updatedDate=eventDetails["completed_updated_date"] ?? "Not Updated";
  List containerRows=[
    "Added By : ${eventDetails['event_added_by']?? ''}",
    "Updated By : ${eventDetails["updated_by"]?? ''}",
    "நிகழ்வு கருத்து : ${eventDetails["feedback"] ?? ''}",
    "ஸ்தல அர்ச்சகர் : ${eventDetails["archagar"]?? ''}",
    "அபிஷேகம் : ${eventDetails["abisegam"] ?? ''}",
    "அபிஷேகம் உதவி : ${eventDetails["helper"] ?? ''}",
    "பூ அர்ச்சனை : ${eventDetails["poo"] ?? ''}",
    "நாமா வழி சொல்பவர் : ${eventDetails["read"] ?? ''}",
    "பொருட்கள் சேகரித்தவர் : ${eventDetails["prepare"] ?? ''}"
  ];

  if (isForAssign==true){
    containerRows=[
      "Assigned By : ${eventDetails['assigned_by']?? ''}",
      "ஸ்தல அர்ச்சகர் : ${eventDetails["assigned_archagar"]?? ''}",
      "அபிஷேகம் : ${eventDetails["assigned_abisegam"]?? ''}",
      "அபிஷேகம் உதவி : ${eventDetails["assigned_helper"]?? ''}",
      "பூ அர்ச்சனை : ${eventDetails["assigned_poo"] ?? ''}",
      "நாமா வழி சொல்பவர் : ${eventDetails["assigned_read"] ?? ''}",
      "பொருட்கள் சேகரித்தவர் : ${eventDetails["assigned_prepare"] ?? ''}"
    ];

    List<String> datetime=eventDetails['assigned_datetime']!=null? formatUtcToLocal(eventDetails['assigned_datetime']).split("/") : ['Not assigned','Not assigned'];
    updatedDate=datetime[0];
    updatedAt=datetime[1];

    print("/////////////////////////riiruf $updatedDate");

  }


  
  if ((eventDetails["event_status"].toLowerCase() == "pending" || eventDetails["event_status"].toLowerCase() == "canceled") && isForAssign==false){
    updatedAt=eventDetails["pending_canceled_updated_at"] ?? "Not Updated";
    updatedDate=eventDetails["pending_canceled_updated_date"] ?? "Not Updated";
    print("hello world please $updatedAt $isForAssign");
    
  }

  List<Widget> status=[
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
              updatedDate,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 14
              ),
            ),
          ],
        ),
        SizedBox(height: 10,),
        Row(
          children: [
            SvgPicture.asset(
              "assets/svg/alarm-clock-svgrepo-com.svg",
              width: 20,
            ),
            SizedBox(width: 10),
            Text(
              updatedAt,
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
              
  ];
  
  for (String i in containerRows){
    status.addAll(
      [
        buildRows(i),
        SizedBox(height: 10,)
      ]
    );
  }

  if ((eventDetails["event_status"].toLowerCase() == "pending" || eventDetails["event_status"].toLowerCase() == "canceled") && isForAssign==false){
    print("..................................vvan ");
    status=[
      ...status.sublist(0,5),
      SizedBox(height: 10,),
      Row(
        children: [
          Expanded(
            child: Text(
              "${eventDetails['event_status']?? ''} Reason : ${eventDetails["event_pending_canceled_description"] ?? ''}",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 18
              ),
              softWrap: true,
            ),
          ),
        ],
      )
    ];
     print("..................................vvan .........................");
  }

  return SizedBox(
    height: 100,
    child: SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          eventDetails["image_url"]!=null && eventDetails['image_url'].toString().isNotEmpty && isForAssign==false
            ?GestureDetector(
              onTap: () => Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context)=>ImageShowerDialog(imageUrl: eventDetails["image_url"])
                )
              ),
              child: Container(
                height: 250,
                margin: EdgeInsets.all(10),
                child: CachedNetworkImage(
                  imageUrl:eventDetails["image_url"],
                  placeholder: (context, url) {
                    return SizedBox(
                      height: 100,
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.orange,),
                      ),
                    );
                  },
                  errorWidget: (context, error, stackTrace) {
                    print("Image load error: $error"); // 👈 debug print
                    return const Center(
                      child: SizedBox(
                        height: 100,
                        child: Text(
                          '⚠️ Unable to load image. Check your internet connection.',
                          style: TextStyle(color: Colors.red,fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,

                        ),
                      ),
                    );
                  },
                ),
              ),
            )
            : Text(isForAssign==true? "" : "There is no image for this event",style: TextStyle(fontWeight: FontWeight.w600),) ,
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500),
            child: Container(
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
                ],
                
              ),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        (currentUserRole==UserRoleEnum.ADMIN.name && isForAssign==true && updatedAt!='Not assigned')?
                          PopupMenuButton(
                            icon: Icon(Icons.more_horiz,color: Colors.white,),
                            onSelected: (value)async{
                              if(value=="delete"){
                                AwesomeDialog(
                                  width: MediaQuery.of(context).size.width>400? 500 : null,
                                  context: context,
                                  btnOkText: "Yes",
                                  dismissOnTouchOutside: false,
                                  dismissOnBackKeyPress: false,
                                  dialogType: DialogType.info,
                                  animType: AnimType.topSlide,
                                  title: 'Delete Assign',
                                  desc: 'Are you sure , Do you Want to Delete Assigned Workers ?',
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () async {
                                    final res=await NetworkService.sendRequest(path: "/event/assign", context: context,method: "DELETE",body: {"event_id":eventDetails['event_id']});
                                    print(res);
                                    
                                    if(res!=null){
                                      Navigator.pop(context);
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
                        : Text("")
                      ],
                    ),
                  ...status
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}
