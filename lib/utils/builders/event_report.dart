import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sampleflutter/custom_controls/custom_ad.dart';


Widget buildEventReport(Map eventDetails,BuildContext context){
  print(eventDetails["updated_at"]);
  final List<String> eventStatusUpdatedAt=eventDetails["updated_at"].split(":") ?? "Not Updated";
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
                child: Image.network(
                  eventDetails["image_url"],
                  gaplessPlayback: true,
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
                        eventDetails["updated_date"] ?? "Not Updated",
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
                        "${eventStatusUpdatedAt[0]}:${eventStatusUpdatedAt[1]}",
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
                      
                      Text(
                        "Added By : ${eventDetails['event_added_by']}",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 18
                        ),
                      ),
                    ]
                  ),
              SizedBox(height: 10,),
              Row(
                children: [
                
                  Expanded(
                    child: Text(
                      "Updated By : ${eventDetails["updated_by"]}",
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
                  
                  Expanded(
                    child: Text(
                      "நிகழ்வு கருத்து : ${eventDetails["feedback"]}",
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
                  
                  Expanded(
                    child: Text(
                      "ஸ்தல அர்ச்சகர் : ${eventDetails["archagar"]}",
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
                  
                  Expanded(
                    child: Text(
                      "அபிஷேகம் : ${eventDetails["abisegam"]}",
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
                  
                  Expanded(
                    child: Text(
                      "அபிஷேகம் உதவி : ${eventDetails["helper"]}",
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

                  Expanded(
                    child: Text(
                      "பூ அர்ச்சனை : ${eventDetails["poo"]}",
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
                  
                  Expanded(
                    child: Text(
                      "நாமா வழி சொல்பவர் : ${eventDetails["read"]}",
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
                 
                  Expanded(
                    child: Text(
                      "பொருட்கள் சேகரித்தவர் : ${eventDetails["prepare"]}",
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
              ],
            ),
          )
        ],
      ),
    ),
  );
}
