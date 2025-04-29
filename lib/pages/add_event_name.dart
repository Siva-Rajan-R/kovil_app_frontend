import 'dart:convert';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:sampleflutter/custom_controls/cust_snacbar.dart';
import 'package:sampleflutter/custom_controls/custom_appbar.dart';
import 'package:sampleflutter/utils/builders/event_name.dart';
import 'package:sampleflutter/utils/evvent_name_amt.dart';
import 'package:sampleflutter/utils/network_request.dart';

Widget makeEventNamesAmountCard(List eventNamesAmount){
  
  return ListView.builder(
    itemCount: eventNamesAmount.length,
    itemBuilder: (context,index){
      return eventNamesAmountCard(eventName: eventNamesAmount[index]['name'], eventAmount: eventNamesAmount[index]['amount'].toString());
    }
  );
}

class AddEventName extends StatelessWidget{

  AddEventName({super.key});

  Future getEventNames({required BuildContext context})async {
    final res=await NetworkService.sendRequest(path: '/event/name', context: context);
    final decodedRes=jsonDecode(res.body);
    print("response $decodedRes ${res.statusCode}");
    if (res.statusCode==200){
      final List eventNamesAmountList=List.from(decodedRes['event_names']);
      print("hello $eventNamesAmountList");
      return eventNamesAmountList;
    }
    else{
      customSnackBar(content: decodedRes['detail'], contentType: AnimatedSnackBarType.error);
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
              tabs: const [
                Tab(text: 'New'),
                Tab(text: 'Exists'),
              ],
            ),
            Expanded(
              child: FutureBuilder(
                future: getEventNames(context: context), 
                builder: (context,snapshot){
                  if(snapshot.connectionState==ConnectionState.waiting){
                    return Center(child:CircularProgressIndicator());
                  }
                  else{
                    final List eventNamesAmount=snapshot.data ?? [];
                    print(eventNamesAmount);
                    return TabBarView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: addNewEventName(context: context),
                        ),
                        eventNamesAmount.isNotEmpty? makeEventNamesAmountCard(eventNamesAmount)
                         : Center(child: Text("No data found"),)
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