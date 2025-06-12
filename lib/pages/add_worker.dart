
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sampleflutter/custom_controls/custom_appbar.dart';
import 'package:sampleflutter/custom_controls/workers_card.dart';
import 'package:sampleflutter/utils/builders/workers.dart';
import 'package:sampleflutter/utils/network_request.dart';
import 'package:sampleflutter/utils/random_loading.dart';

Widget makeWorkersNameCard(List workersName){
  
  return ListView.builder(
    itemCount: workersName.length,
    itemBuilder: (context,index){
      return WorkersNameCard(workerName: workersName[index]['name'], workerNo: workersName[index]['mobile_number'],workerParticipatedEvents: workersName[index]["no_of_participated_events"] ?? 0,);
    }
  );
}

class AddWorkerPage extends StatelessWidget{

  const AddWorkerPage({super.key});

  Future getWorkersNames({required BuildContext context})async {
    final res=await NetworkService.sendRequest(path: '/workers', context: context);
    if (res!=null){
      final List workersNameList=List.from(res['workers']);
      print("hello $workersNameList");
      return workersNameList;
    }
    else{
      return [];
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KovilAppBar(
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
              child: FutureBuilder(
                future: getWorkersNames(context: context), 
                builder: (context,snapshot){
                  if(snapshot.connectionState==ConnectionState.waiting){
                    return Center(
                      child: Column(
                        
                        children: [
                          LottieBuilder.asset(getRandomLoadings()),
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
                    );
                  }
                  else{
                    final List workersName=snapshot.data ?? [];
                    print("${snapshot.data},$workersName");
                    return TabBarView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: AddWorkers(),
                        ),
                        workersName.isNotEmpty? makeWorkersNameCard(workersName)
                         : Center(child: Text("No data found"),),
                        
                      ],
                    );
                  }
                }
              )
            ),
          ],
        ),
      ),
    );
  }
}