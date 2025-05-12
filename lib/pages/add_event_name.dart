import 'dart:convert';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:sampleflutter/custom_controls/cust_snacbar.dart';
import 'package:sampleflutter/custom_controls/custom_appbar.dart';
import 'package:sampleflutter/utils/builders/event_name.dart';
import 'package:sampleflutter/custom_controls/event_name_card.dart';
import 'package:sampleflutter/utils/network_request.dart';

Widget makeEventNamesAmountCard(List eventNamesAmount,bool isForNeivethiyam){
  
  return ListView.builder(
    itemCount: eventNamesAmount.length,
    itemBuilder: (context,index){
      return EventNameAmountCard(eventNameId: eventNamesAmount[index]['id'],eventName: eventNamesAmount[index]['name'], eventAmount: eventNamesAmount[index]['amount'].toString(),isForNeivethiyam: isForNeivethiyam,);
    }
  );
}

class AddEventName extends StatelessWidget{

  const AddEventName({super.key});

  Future getEventNames({required BuildContext context})async {
    final res=await NetworkService.sendRequest(path: '/event/name', context: context);
    final decodedRes=jsonDecode(utf8.decode(res.bodyBytes));
    print("response $decodedRes ${res.statusCode}");
    if (res.statusCode==200){
      final eventNamesAmountList=List.from(decodedRes['event_names']);
      final normalEventsAmnt=eventNamesAmountList.where((e)=>e['is_special']==false).toList();
      final specialEventsAmnt=eventNamesAmountList.where((e)=>e['is_special']==true).toList();
      print("hello $eventNamesAmountList");

      return {
        "normalEventsAmnt":normalEventsAmnt,
        "specialEventsAmnt":specialEventsAmnt
      };
    }
    else{
      customSnackBar(content: decodedRes['detail'], contentType: AnimatedSnackBarType.error).show(context);
      return [];
    }
  }

  Future getNeivethiyamNames({required BuildContext context})async {
    final res=await NetworkService.sendRequest(path: '/neivethiyam/name', context: context);
    final decodedRes=jsonDecode(utf8.decode(res.bodyBytes));
    print("response $decodedRes ${res.statusCode}");
    if (res.statusCode==200){
      final List neivethiyamNamesAmountList=List.from(decodedRes['neivethiyam_names']);
      print("hello $neivethiyamNamesAmountList");
      return neivethiyamNamesAmountList;
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
        length: 4,
        child: Column(
          children: [
            TabBar(
              labelColor: Colors.black,
              indicatorColor: Colors.orange,
              isScrollable: true,
              tabAlignment: TabAlignment.center,
              labelPadding: EdgeInsets.only(left: 25,right: 25),
              tabs:  [
                Tab(text: 'New'),
                Tab(text: 'Event Names'),
                Tab(text: "Special Event",),
                Tab(text: "Neivethiyam",),
                
              ],
            ),
            Expanded(
              child: FutureBuilder(
                future: Future.wait(
                  [
                    getEventNames(context: context),
                    getNeivethiyamNames(context: context)
                  ]
                ), 
                builder: (context,snapshot){
                  if(snapshot.connectionState==ConnectionState.waiting){
                    return Center(child:CircularProgressIndicator(color: Colors.orange,));
                  }
                  else{
                    
                    final normalEventsAmnt=snapshot.data?[0]["normalEventsAmnt"] ?? [];
                    final specialEventsAmnt=snapshot.data?[0]['specialEventsAmnt'] ?? [];
                    final neivethiyamNamesAmount=snapshot.data?[1] ?? [];
                    print("[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[$normalEventsAmnt $specialEventsAmnt");
                    return TabBarView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: AddEventNewName(),
                        ),
                        normalEventsAmnt.isNotEmpty? makeEventNamesAmountCard(normalEventsAmnt,false)
                         : Center(child: Text("No data found"),),
                        specialEventsAmnt.isNotEmpty? makeEventNamesAmountCard(specialEventsAmnt,false)
                         : Center(child: Text("No data found"),),
                        neivethiyamNamesAmount.isNotEmpty? makeEventNamesAmountCard(neivethiyamNamesAmount,true)
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