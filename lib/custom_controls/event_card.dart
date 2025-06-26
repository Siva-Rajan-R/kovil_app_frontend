
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sampleflutter/custom_controls/cust_snacbar.dart';
import 'package:sampleflutter/pages/add_events.dart';
import 'package:sampleflutter/pages/detailed_event.dart';
import 'package:sampleflutter/pages/status_update.dart';
import 'package:sampleflutter/utils/enums.dart';
import 'package:sampleflutter/utils/global_variables.dart';
import 'package:sampleflutter/utils/network_request.dart';
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
class EventCard extends StatefulWidget{
  final Map eventDetails;
  final int currentTabIndex;
  
  const EventCard({
    required this.eventDetails,
    required this.currentTabIndex,
    super.key
  });

  @override
  State<EventCard> createState()=> _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool isEventloading=false;
  bool isContactAddLoading=false;
  TextEditingController contactDescription=TextEditingController();

  getContactDescription(String eventId)async {
    setState(() {
      isEventloading=true;
    });
    contactDescription.text=widget.eventDetails['contact_description'] ?? "";
    // final res=await NetworkService.sendRequest(path: "/event/contact-description?event_id=$eventId", context: context);
    setState(() {
      isEventloading=false;
    });
    // if(res!=null){
    //   final List des=res;
    //   contactDescription.text=des.isNotEmpty? des[0]['description'] : "";
    // }

    
  }

  Future saveContactDescription(String eventId) async {
    setState(() {
      isContactAddLoading=true;
    });
     print("biiii $isContactAddLoading");
    final res=await NetworkService.sendRequest(path: "/event/contact-description", context: context,method: 'POST',body: {"event_id":eventId,"contact_description":contactDescription.text.trim()});
    print(res);

    setState(() {
      isContactAddLoading=false;
    });

    Navigator.pop(context);
  }

  @override
  void dispose(){
    contactDescription.dispose();
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    final Map eventDetails=widget.eventDetails;
    final int currentTabIndex=widget.currentTabIndex;
    final String curUser=currentUserRole!;

    print("ederdrdfffyf $eventDetails");
    List<String> labels=[
      "pending",
      "canceled",
      "completed"
    ];
    List<Widget> buttons=[];
    final eventStartAtStr = eventDetails["event_start_at"] ?? "";
    final eventEndAtStr = eventDetails["event_end_at"] ?? "";

    final List<String> eventStartAt = eventStartAtStr.contains(":") ? eventStartAtStr.split(":") : ["00", "00"];
    final List<String> eventEndAt = eventEndAtStr.contains(":") ? eventEndAtStr.split(":") : ["00", "00"];

    print(currentTabIndex);
    if (currentTabIndex==0){
      buttons.addAll(eventStatusUpdateButtonsBuilder([labels[1],labels[2]],eventDetails['event_id'],context,eventDetails));
    }
    else if(currentTabIndex==1){
      buttons.addAll(eventStatusUpdateButtonsBuilder([labels[0],labels[2]],eventDetails['event_id'],context,eventDetails));
    }
    else{
      buttons.addAll(eventStatusUpdateButtonsBuilder([labels[0],labels[1]],eventDetails['event_id'],context,eventDetails));
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
            onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (context)=>DetailedEventPage(eventDetails: eventDetails,eventStatusUpdateButtons: buttons,))),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          curUser==UserRoleEnum.ADMIN.name?
                            PopupMenuButton(
                              icon: Icon(Icons.more_horiz,color: Colors.white,),
                              onSelected: (value)async{
                                if (value=='assign'){
                                  await Navigator.push(context, CupertinoPageRoute(builder: (context)=> StatusUpdatePage(eventStatus: 'completed', eventId: eventDetails['event_id'],existingEventDetails: eventDetails,isForAssign: true,)));
                                }
                                if(value=='edit'){
                                  await Navigator.push(context, CupertinoPageRoute(builder: (context)=> AddEventsPage(existingEventDetails: eventDetails,)));
                                }
                                else if(value=="delete"){
                                  AwesomeDialog(
                                    context: context,
                                    width: MediaQuery.of(context).size.width>400? 500 : null,
                                    btnOkText: "Yes",
                                    dismissOnTouchOutside: false,
                                    dismissOnBackKeyPress: false,
                                    dialogType: DialogType.info,
                                    animType: AnimType.rightSlide,
                                    title: 'Delete Event',
                                    desc: 'Are you sure , Do you Want to Delete ${eventDetails['event_name']} ?',
                                    btnCancelOnPress: () {},
                                    btnOkOnPress: () async {
                                      setState(() {
                                        isEventloading=true;
                                      });
                                      final res=await NetworkService.sendRequest(path: "/event", context: context,method: "DELETE",body: {"event_id":eventDetails['event_id']});
                                      setState(() {
                                        isEventloading=false;
                                      });
                                      if(res!=null){
                                        Navigator.popUntil(context, (route) => route.isFirst);
                                      }
                                    }
                                  ).show();
                                }
                  
                                else if (value == "contact") {
                                    await getContactDescription(eventDetails['event_id']);
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                      ),
                                      builder: (context) => DraggableScrollableSheet(
                                        initialChildSize: 0.7,
                                        minChildSize: 0.0,
                                        maxChildSize: 0.7,
                                        expand: false,
                                        builder: (context, scrollController) {
                                          bool localLoading = false; // Local state for the button
                                          return StatefulBuilder(
                                            builder: (BuildContext context, StateSetter setModalState) {
                                              return SingleChildScrollView(
                                                controller: scrollController,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(16.0),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        height: 5,
                                                        width: 40,
                                                        margin: const EdgeInsets.only(bottom: 10),
                                                        decoration: BoxDecoration(
                                                          color: Colors.grey[300],
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                      ),
                                                      const Text(
                                                        "Contact Description",
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 20,
                                                          color: Colors.orange,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 10),
                                                      TextField(
                                                        controller: contactDescription,
                                                        style: const TextStyle(
                                                            color: Colors.black, fontWeight: FontWeight.w600),
                                                        cursorColor: Colors.orange,
                                                        minLines: 4,
                                                        decoration: InputDecoration(
                                                          hintText: 'Write a contact description...',
                                                          hintStyle: const TextStyle(
                                                              color: Colors.grey, fontWeight: FontWeight.w500),
                                                          enabledBorder: const OutlineInputBorder(
                                                            borderSide: BorderSide(color: Colors.black38),
                                                          ),
                                                          focusedBorder: const OutlineInputBorder(
                                                            borderSide: BorderSide(color: Colors.orange),
                                                          ),
                                                          alignLabelWithHint: true,
                                                        ),
                                                        keyboardType: TextInputType.multiline,
                                                        maxLines: 5,
                                                      ),
                                                      const SizedBox(height: 20),
                                                      ElevatedButton(
                                                        onPressed: localLoading
                                                            ? null
                                                            : () async {
                                                                setModalState(() => localLoading = true);
                                                                await saveContactDescription(
                                                                    eventDetails['event_id']);
                                                                setModalState(() => localLoading = false);
                                                              },
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor: Colors.orange,
                                                        ),
                                                        child: localLoading
                                                            ? Row(
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: const [
                                                                  SizedBox(
                                                                    width: 18,
                                                                    height: 18,
                                                                    child: CircularProgressIndicator(
                                                                      color: Colors.white,
                                                                      strokeWidth: 2,
                                                                    ),
                                                                  ),
                                                                  SizedBox(width: 8),
                                                                  Text(
                                                                    "Saving...",
                                                                    style: TextStyle(color: Colors.white),
                                                                  ),
                                                                ],
                                                              )
                                                            : const Text(
                                                                "Save",
                                                                style: TextStyle(color: Colors.white),
                                                              ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    );
                                  }
                  
                              },
                              itemBuilder: (context){
                                return [
                                  if (eventDetails['event_status']=='pending' || eventDetails['event_status']=='canceled')
                                    PopupMenuItem(value: "assign",child: Text("Assign Workers",style: TextStyle(color: Colors.orange.shade800),)),
                                  PopupMenuItem(value: "edit",child: Text("Edit",style: TextStyle(color: Colors.orange.shade800),)),
                                  PopupMenuItem(value: "delete",child: Text("Delete",style: TextStyle(color: Colors.orange.shade800))),
                                  PopupMenuItem(value: "contact",child: Text("Contact Description",style: TextStyle(color: Colors.orange.shade800)))
                                ];
                              }
                            )
                          : Text("")
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
            ),
          ),
          if(isEventloading)
            Positioned.fill(child: Center(child: CircularProgressIndicator(color: Colors.white,),))
        ],
      ),
    );
  }
}