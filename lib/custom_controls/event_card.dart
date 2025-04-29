import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sampleflutter/pages/detailed_event.dart';
import 'package:sampleflutter/pages/status_update.dart';

List<Widget> eventStatusUpdateButtonsBuilder(List<String> labels,String eventId,BuildContext context){
  final List<Widget> buttons=[];
  for(int i=0;i<labels.length;i++){
    buttons.add(
      ElevatedButton(
        onPressed: ()=>Navigator.push(context, CupertinoPageRoute(builder: (context)=>StatusUpdatePage(eventStatus: labels[i],eventId: eventId,))),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
        ),
        child: Text(labels[i],style: TextStyle(color: Colors.white),)
      ),
    );
  }
  return buttons;
}
class EventCard extends StatelessWidget{
  final Map eventDetails;
  final int currentTabIndex;
  
  const EventCard({
    required this.eventDetails,
    required this.currentTabIndex,
    super.key
  });
   
  @override
  Widget build(BuildContext context) {
    List<String> labels=[
      "pending",
      "canceled",
      "completed"
    ];
    List<Widget> buttons=[];
    final List<String> eventStartAt=eventDetails["event_start_at"].split(":");
    final List<String> eventEndAt=eventDetails["event_end_at"].split(":");
    print(currentTabIndex);
    if (currentTabIndex==0){
      buttons.addAll(eventStatusUpdateButtonsBuilder([labels[1],labels[2]],eventDetails['event_id'],context));
    }
    else if(currentTabIndex==1){
      buttons.addAll(eventStatusUpdateButtonsBuilder([labels[0],labels[2]],eventDetails['event_id'],context));
    }
    else{
      buttons.addAll(eventStatusUpdateButtonsBuilder([labels[0],labels[1]],eventDetails['event_id'],context));
    }

    return GestureDetector(
      onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (context)=>DetailedEventPage(eventDetails: eventDetails,eventStatusUpdateButtons: buttons,))),
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
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    "assets/svg/event svy.svg",
                    width: 20,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      eventDetails["event_name"],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 18,                        
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
                    "assets/svg/user-svgrepo-com.svg",
                    width: 20,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      eventDetails["client_name"],
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
                    "assets/svg/mobile-phone-svgrepo-com.svg",
                    width: 20,
                  ),
                  SizedBox(width: 10),
                  Text(
                    eventDetails["client_mobile_number"],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 18
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15,),
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
                        eventDetails["event_date"],
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
                        "${eventStartAt[0]}:${eventStartAt[1]}-${eventEndAt[0]}:${eventEndAt[1]}",
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
              
            ],
          ),
        ),
      ),
    );
  }
}