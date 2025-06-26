
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sampleflutter/custom_controls/custom_appbar.dart';
import 'package:sampleflutter/custom_controls/workers_card.dart';
import 'package:sampleflutter/utils/builders/workers.dart';
import 'package:sampleflutter/utils/network_request.dart';
import 'package:sampleflutter/utils/random_loading.dart';


class AddWorkerPage extends StatefulWidget{

  const AddWorkerPage({super.key});

  @override
  State<AddWorkerPage> createState() => _AddWorkerPageState();
}

class _AddWorkerPageState extends State<AddWorkerPage> {
  List workersNameList=[];
  List availableUsersList=[];
  bool isLoading=true;

  void removeWorkers(String workerName){
    setState(() {
      workersNameList.removeWhere((worker)=> worker['name']==workerName);
    });
    
  }

  void onWorkerUpdate(Map updatedWorker,String workerToUpdate,String userIdToDelete){

    int oldWorkerIndex=workersNameList.indexWhere((worker)=>worker['name']==workerToUpdate);

    setState(() {
      workersNameList[oldWorkerIndex]['name']=updatedWorker['name'];
      workersNameList[oldWorkerIndex]['mobile_number']=updatedWorker['mobile_number'];
      availableUsersList.removeWhere((user)=>user['id']==userIdToDelete);
    });

  }

  Widget makeWorkersNameCard(List workersName){
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: workersName.length,
      itemBuilder: (context,index){
        return RepaintBoundary(child: WorkersNameCard(availableUsersList: availableUsersList,onDelete: removeWorkers,onUpdate: onWorkerUpdate,workerName: workersName[index]['name'], workerNo: workersName[index]['mobile_number'],workerParticipatedEvents: workersName[index]["no_of_participated_events"] ?? 0,));
      }
    );
  }

  Future getWorkersNames({required BuildContext context})async {
    final res=await NetworkService.sendRequest(path: '/workers?include_users=true', context: context);
    if (res!=null){
      setState(() {
        workersNameList=List.from(res['workers']);
        availableUsersList=List.from(res['available_users']);
        isLoading=false;
      });
      
    }
    else{
      setState(() {
        workersNameList=[];
        isLoading=false;
      });
    }
  }

  @override
  void initState(){
    super.initState();
    getWorkersNames(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MediaQuery.of(context).size.width>400? null : KovilAppBar(
        withIcon: true,
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              labelColor: Colors.black,
              indicatorColor: Colors.orange,
              tabs:  [
                Tab(text: 'New'),
                Tab(text: 'Exists'),
              ],
            ),
            Expanded(
              child: isLoading? Center(
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
              : TabBarView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: AddWorkers(onAdd: (addedWorker) => setState(() {
                      workersNameList.insert(0, addedWorker);
                    }),availableusersList: availableUsersList,),
                  ),
                  workersNameList.isNotEmpty? makeWorkersNameCard(workersNameList)
                    : Center(child: Text("No data found"),),
                  
                ],
              )
                  
            ),
          ]
        ),
      ),
    );
  }
}