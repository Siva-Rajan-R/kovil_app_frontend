import 'dart:convert';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:sampleflutter/custom_controls/cust_snacbar.dart';
import 'package:sampleflutter/custom_controls/custom_appbar.dart';
import 'package:sampleflutter/custom_controls/workers_card.dart';
import 'package:sampleflutter/utils/builders/workers.dart';
import 'package:sampleflutter/utils/network_request.dart';

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
    final decodedRes=jsonDecode(utf8.decode(res.bodyBytes));
    print("response $decodedRes ${res.statusCode}");
    if (res.statusCode==200){
      final List workersNameList=List.from(decodedRes['workers']);
      print("hello $workersNameList");
      return workersNameList;
    }
    else{
      customSnackBar(content: decodedRes['detail'], contentType: AnimatedSnackBarType.error).show(context);
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
                    return Center(child:CircularProgressIndicator(color: Colors.orange,));
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