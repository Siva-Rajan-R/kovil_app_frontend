import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sampleflutter/pages/detailed_event.dart';
import 'package:sampleflutter/utils/convert_utc_to_local.dart';
import 'package:sampleflutter/utils/network_request.dart';

class AssignedEventsCard extends StatefulWidget {
  final Map assignedEvents;
  const AssignedEventsCard({required this.assignedEvents,super.key});

  @override
  State<AssignedEventsCard> createState() => _AssignedEventsCardState();
}

class _AssignedEventsCardState extends State<AssignedEventsCard> {
  bool isLoading=false;

  Future getEventsDetails()async{
    setState(() {
      isLoading=true;
    });
    final res=await NetworkService.sendRequest(path: "/event/specific?date=${widget.assignedEvents['event_date']}&event_id=${widget.assignedEvents['event_id']}", context: context);
    setState(() {
      isLoading=false;
    });
    print(res);
    if (res!=null){
      return res['events'][0];

    }
    return [];
  }
  
  @override
  Widget build(BuildContext context) {

    Map assignedEvents=widget.assignedEvents;
    String assignedAt=formatUtcToLocal(assignedEvents['assigned_datetime']);

    return Stack(
      children: [
        Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () async {
                  final eventDetails=await getEventsDetails();
                  print(eventDetails);
                  await Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>DetailedEventPage(eventDetails: eventDetails)));
                },
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
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/svg/date-svgrepo-com.svg",
                              width: 20,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Assigned at : $assignedAt",
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
                            Text(
                              "By : ${assignedEvents['assigned_by']}",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 14
                              ),
                            ),
                          ],
                        ),
                      
                        SizedBox(height: 10,),
                      
                      Column(
                        children: [
                          Text(
                            assignedEvents['event_name'],
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontSize: 16
                            ),
                            softWrap: true,
                          
                          ),
                          SizedBox(height: 20,),
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
                                    assignedEvents['event_date'],
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
                                    assignedEvents['event_start_at'],
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
                    ],
                  ),
                ),
              ),
            )
          ),
        ),

        if(isLoading)
          Positioned.fill(child: Center(child: CircularProgressIndicator(color: Colors.white,),))
        
      ],
    );
  }
}