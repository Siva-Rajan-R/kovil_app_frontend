import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sampleflutter/custom_controls/custom_appbar.dart';
import 'package:sampleflutter/custom_controls/leave_card.dart';
import 'package:sampleflutter/utils/global_variables.dart';
import 'package:sampleflutter/utils/network_request.dart';
import 'package:sampleflutter/utils/random_loading.dart';

class LeaveManagementPage extends StatefulWidget {
  const LeaveManagementPage({super.key});

  @override
  State<LeaveManagementPage> createState() => _LeaveManagementPageState();
}

class _LeaveManagementPageState extends State<LeaveManagementPage> {
  List waitingList=[];
  List rejectedList=[];
  List acceptedList=[];

  bool isLoading=true;

  void onleaveDelete(int leaveId,String forWhichList){
    List leaveListToDelete=waitingList;
    if (forWhichList=='rejected'){
      leaveListToDelete=rejectedList;
    }
    else if(forWhichList=='accepted'){
      leaveListToDelete=acceptedList;
    }
    setState(() {
      leaveListToDelete.removeWhere((leave)=>leave['id']==leaveId);
    });
    
  }

  void onleaveStatusUpdated(Map leaveDetails,String listToUpdateStr){
    String curLeaveList=leaveDetails['status'];
    List listToDelete=(curLeaveList=='waiting')? waitingList : (curLeaveList=='rejected')? rejectedList : acceptedList;
    List listToUpdate=(listToUpdateStr=='waiting')? waitingList : (listToUpdateStr=='rejected')? rejectedList : acceptedList;

    leaveDetails['status']=listToUpdateStr;

    setState(() {
      listToUpdate.insert(0, leaveDetails);
      listToDelete.removeWhere((leave)=>leave['id']==leaveDetails['id']);
    });
  }

  Widget leaveCardBuilder(List leaveDetails){
    if (leaveDetails.isNotEmpty){
      return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: leaveDetails.length,
        itemBuilder: (context,index){
          return LeaveCard(leaveDetails: leaveDetails[index],onDelete: onleaveDelete,onLeaveStatusUpdate: onleaveStatusUpdated,isLeaveManagement: true,);
        }
      );
    }

    else{
      return Center(
        child: Text("No data found"),
      );
    }
  }

  Future getuserLeave()async {
    final res=await NetworkService.sendRequest(path: '/user/leave?all=true', context: context);

    if (res!=null){
      List<Map> userLeaveList=List.from(res['leaves']);
      setState(() {
        waitingList=userLeaveList.where((leave)=>leave['status']=='waiting').toList();
        rejectedList=userLeaveList.where((leave)=> leave['status']=='rejected').toList();
        acceptedList=userLeaveList.where((leave)=>leave['status']=='accepted').toList();
        isLoading=false;
      });
     
    }
  }

  @override
  void initState(){
    super.initState();
    getuserLeave();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MediaQuery.of(context).size.width>phoneSize? null : KovilAppBar(withIcon: true,titleSize: 20,),
      body: isLoading? Center(
        child: Column(
          children: [
            LottieBuilder.asset(getRandomLoadings(),height: MediaQuery.of(context).size.height*0.5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Please wait while fetching users...",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w600,color: Colors.orange),),
                VerticalDivider(),
                SizedBox(width: 30,height: 30, child: CircularProgressIndicator(color: Colors.orange,padding: EdgeInsets.all(5),))
              ],
            )
          ],
        ),
      )
      : DefaultTabController(
          length: 3, 
          child: Column(
            children: [
              TabBar(
                labelColor: Colors.black,
                indicatorColor: Colors.orange,
                tabs: [
                  Tab(text: "Waiting",),
                  Tab(text:'Rejected'),
                  Tab(text:"Accepted")
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    leaveCardBuilder(waitingList),
                    leaveCardBuilder(rejectedList),
                    leaveCardBuilder(acceptedList)
                  ],
                ),
              )
            ],
          )
        )
    );
  }
}