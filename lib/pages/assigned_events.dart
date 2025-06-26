import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sampleflutter/custom_controls/assigned_events_card.dart';
import 'package:sampleflutter/custom_controls/custom_appbar.dart';
import 'package:sampleflutter/utils/network_request.dart';
import 'package:sampleflutter/utils/random_loading.dart';

class AssignedEventsPage extends StatefulWidget {
  final String? workerName;
  final bool canShowAppBar;
  const AssignedEventsPage({this.canShowAppBar=false,this.workerName,super.key});

  @override
  State<AssignedEventsPage> createState() => _AssignedEventsPageState();
}

class _AssignedEventsPageState extends State<AssignedEventsPage> {
  bool isLoading=true;
  List assignedEvents=[];

  Future getAssignedEvents()async {
    String path='/event/assign';
    if (widget.workerName!=null && widget.workerName!.isNotEmpty){
      path='/event/assign?worker_name=${widget.workerName}';
    }
    final res=await NetworkService.sendRequest(path: path,method: "GET", context: context);
    if (res!=null){
      assignedEvents=res['assigned_events'];
    }
    setState(() {
      assignedEvents=assignedEvents;
      isLoading=false;
    });
    
  }
  
  @override
  void initState(){
    super.initState();
    getAssignedEvents();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (MediaQuery.of(context).size.width>400) && widget.canShowAppBar==false? null : KovilAppBar(withIcon: true,),
      body: isLoading? Center(
      child: Column(
        children: [
          LottieBuilder.asset(getRandomLoadings(),height: MediaQuery.of(context).size.height*0.5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Please wait while fetching workers...",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w600,color: Colors.orange),),
              VerticalDivider(),
              SizedBox(width: 30,height: 30, child: CircularProgressIndicator(color: Colors.orange,padding: EdgeInsets.all(5),))
            ],
          )
        ],
      )
    )
     
    : assignedEvents.isNotEmpty? ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: assignedEvents.length,
        itemBuilder: (context,index){
          return AssignedEventsCard(assignedEvents: assignedEvents[index]);
        }
      ) : Center(child: Text("There is no assigned events"),)
    );
  }
}