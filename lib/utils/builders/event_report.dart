import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sampleflutter/custom_controls/custom_ad.dart';

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

Widget buildEventReport(Map eventDetails,BuildContext context){
  print(eventDetails["updated_at"]);
  
  String updatedAt=eventDetails["completed_updated_at"] ?? "Not Updated";
  String updatedDate=eventDetails["completed_updated_date"] ?? "Not Updated";
  List containerRows=[
    "Added By : ${eventDetails['event_added_by']}",
    "Updated By : ${eventDetails["updated_by"]}",
    "நிகழ்வு கருத்து : ${eventDetails["feedback"]}",
    "ஸ்தல அர்ச்சகர் : ${eventDetails["archagar"]}",
    "அபிஷேகம் : ${eventDetails["abisegam"]}",
    "அபிஷேகம் உதவி : ${eventDetails["helper"]}",
    "பூ அர்ச்சனை : ${eventDetails["poo"]}",
    "நாமா வழி சொல்பவர் : ${eventDetails["read"]}",
    "பொருட்கள் சேகரித்தவர் : ${eventDetails["prepare"]}"
  ];


  
  if (eventDetails["event_status"].toLowerCase() == "pending" || eventDetails["event_status"].toLowerCase() == "canceled"){
    updatedAt=eventDetails["pending_canceled_updated_at"] ?? "Not Updated";
    updatedDate=eventDetails["pending_canceled_updated_date"] ?? "Not Updated";
    print("hello world please $updatedAt");
    
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

  if (eventDetails["event_status"].toLowerCase() == "pending" || eventDetails["event_status"].toLowerCase() == "canceled"){
    status=[
      ...status.sublist(0,5),
      SizedBox(height: 10,),
      Row(
        children: [
          Expanded(
            child: Text(
              "${eventDetails['event_status']} Reason : ${eventDetails["event_pending_canceled_description"]}",
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
  }

  return SizedBox(
    height: 100,
    child: SingleChildScrollView(
      child: Column(
        children: [
          eventDetails["image_url"]!=null && eventDetails['image_url'].toString().isNotEmpty
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
            : Text("There is no image for this event",style: TextStyle(fontWeight: FontWeight.w600),),
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
              ],
              
            ),
            child: Column(
              children: [
                ...status
              ],
            ),
          )
        ],
      ),
    ),
  );
}
