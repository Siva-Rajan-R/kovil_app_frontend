
import 'package:sampleflutter/utils/custom_print.dart';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sampleflutter/custom_controls/cust_snacbar.dart';
import 'package:sampleflutter/pages/add_events.dart';
import 'package:sampleflutter/pages/detailed_event.dart';
import 'package:sampleflutter/pages/status_update.dart';
import 'package:sampleflutter/utils/open_phone.dart';



List<Widget> eventStatusUpdateButtonsBuilder(List<String> labels,String eventId,BuildContext context,Map eventDetails){
  final List<Widget> buttons=[];
  for(int i=0;i<labels.length;i++){
    buttons.add(
      ElevatedButton(
        onPressed: ()=>Navigator.push(context, CupertinoPageRoute(builder: (context)=>StatusUpdatePage(eventStatus: labels[i],eventId: eventId,existingEventDetails: eventDetails,isForAssign: false,))),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
        ),
        child: Text(labels[i],style: TextStyle(color: Colors.white),)
      ),
    );
  }
  return buttons;
}
class BookedEventCard extends StatefulWidget{
  final Map eventDetails;
  
  const BookedEventCard({
    required this.eventDetails,
    super.key
  });

  @override
  State<BookedEventCard> createState()=> _BookedEventCardState();
}

class _BookedEventCardState extends State<BookedEventCard> {
  bool isEventloading=false;
  bool isContactAddLoading=false;


  @override
  void dispose(){
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    final Map eventDetails=widget.eventDetails;

    printToConsole("ederdrdfffyf $eventDetails");
    List<Map> labels=[
      {'label':'Accept','action':0},
      {'label':'Cancel','action':1}
    ];
    List<Widget> buttons=[];
    final eventStartAtStr = eventDetails["event_start_at"] ?? "";
    final eventEndAtStr = eventDetails["event_end_at"] ?? "";

    for(Map i in labels){
      buttons.add(OutlinedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.orange),
          shadowColor: WidgetStatePropertyAll(Colors.orange),
          overlayColor: WidgetStatePropertyAll(Colors.orange),
          side: WidgetStatePropertyAll(BorderSide(color: Colors.orange))
        ),
        onPressed: ()=>i['action']==0? Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>AddEventsPage(existingEventDetails: eventDetails,))) : Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>StatusUpdatePage(eventStatus: "canceled", eventId: eventDetails['event_id'],isForAssign: false,isForBookedEvents: true,))), 
        child: Text(i['label'],style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white),)
      ));
    }

    return PopScope(
      canPop: isEventloading? false : true,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop){
          customSnackBar(content: "Wait until request complete...", contentType: AnimatedSnackBarType.info).show(context);
        }
      },
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (context)=>DetailedEventPage(eventDetails: eventDetails,eventStatusUpdateButtons: buttons,isForBookedEvents: true,))),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 500),
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 2.0,bottom: 2.0,left: 4,right: 4),
                            
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(6))
                            ),
                            child: Text(
                              eventDetails['is_special_event'] == null
                              ? "Neivethiyam"
                              : eventDetails['is_special_event'] == true
                                  ? "Special"
                                  : "Normal",
                      
                              style: TextStyle(color: Colors.orange,fontWeight: FontWeight.w600),
                            ),
                          )
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
                          Expanded(
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () => makePhoneCall(eventDetails["client_mobile_number"],context),
                                child: Text(
                                  eventDetails["client_mobile_number"],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                  overflow: TextOverflow.ellipsis,
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
                                "$eventStartAtStr-$eventEndAtStr",
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
                      SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for(Map i in labels)
                            OutlinedButton(
                              style: ButtonStyle(
                              
                                shadowColor: WidgetStatePropertyAll(Colors.orange),
                                overlayColor: WidgetStatePropertyAll(Colors.orange),
                                side: WidgetStatePropertyAll(BorderSide(color: Colors.white))
                              ),
                              onPressed: ()=>i['action']==0? Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>AddEventsPage(existingEventDetails: eventDetails,))) : Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>StatusUpdatePage(eventStatus: "canceled", eventId: eventDetails['event_id'],isForAssign: false,isForBookedEvents: true,))), 
                              child: Text(i['label'],style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white),)
                            )
                          
                        ],
                      )
                      
                    ],
                  ),
                ),
              ),
            ),
          ),
          if(isEventloading)
            Positioned.fill(child: Center(child: CircularProgressIndicator(color: Colors.white,),))
        ],
      ),
    );
  }
}