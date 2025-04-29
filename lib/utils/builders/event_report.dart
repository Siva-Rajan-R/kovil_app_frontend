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
              onTap: () => showDialog(context: context, builder: (context)=>ImageShowerDialog(imageUrl: eventDetails["image_url"])),
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
                      SvgPicture.asset(
                        "assets/svg/date-svgrepo-com.svg",
                        width: 20,
                      ),
                      SizedBox(width: 10),
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
                  SvgPicture.asset(
                    "assets/svg/event svy.svg",
                    width: 20,
                  ),
                  SizedBox(width: 10),
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
                  SvgPicture.asset(
                    "assets/svg/event svy.svg",
                    width: 20,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Feedback : ${eventDetails["feedback"]}",
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
                    "assets/svg/event svy.svg",
                    width: 20,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Tips : ${eventDetails["tips"]}",
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
                    "assets/svg/event svy.svg",
                    width: 20,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Poojai : ${eventDetails["poojai"]}",
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
                    "assets/svg/event svy.svg",
                    width: 20,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Abisegam : ${eventDetails["abisegam"]}",
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
                    "assets/svg/event svy.svg",
                    width: 20,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Helper : ${eventDetails["helper"]}",
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
                    "assets/svg/event svy.svg",
                    width: 20,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Poo : ${eventDetails["poo"]}",
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
                    "assets/svg/event svy.svg",
                    width: 20,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Read : ${eventDetails["read"]}",
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
                    "assets/svg/event svy.svg",
                    width: 20,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Prepare : ${eventDetails["prepare"]}",
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
                    "assets/svg/event svy.svg",
                    width: 20,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Tips Shared : ${eventDetails["tips_shared"]}",
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
                    "assets/svg/event svy.svg",
                    width: 20,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Tips Given To : ${eventDetails["tips_given_to"]}",
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
