import 'dart:convert';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:sampleflutter/custom_controls/cust_snacbar.dart';
import 'package:sampleflutter/custom_controls/event_card.dart';
import 'package:sampleflutter/custom_controls/custom_appbar.dart';
import 'package:sampleflutter/custom_controls/custom_ad.dart';
import 'package:sampleflutter/utils/event.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:sampleflutter/utils/network_request.dart';

Widget _buildEvents(List<Map> events,int currentTabIndex,BuildContext context){
  return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context,index){
        return EventCard(eventDetails: events[index],currentTabIndex: currentTabIndex,);
      }
    );
}
// ignore: must_be_immutable
class TodayEventsPage extends StatelessWidget{
  
  TodayEventsPage({super.key});

  List<Map> customEvents=events;
  Future getEvents(BuildContext context)async {
    final res=await NetworkService.sendRequest(path: "/event/specific?date=${DateFormat("yyyy-MM-dd").format(DateTime.now())}", context: context);
    final decodedRes=jsonDecode(res.body);
    if (res.statusCode==200){
      final eventsList=List<Map>.from(decodedRes['events']);
      print(eventsList);
      final pending=eventsList.where((e)=>e["event_status"]=="pending").toList();
      final cancled=eventsList.where((e)=>e["event_status"]=="canceled").toList();
      final finished=eventsList.where((e)=>e["event_status"]=="completed").toList();

      return {
        'pending':pending,
        'canceled':cancled,
        'finished':finished
      };
    }

    else{
      customSnackBar(content: decodedRes['detail'], contentType: AnimatedSnackBarType.error).show(context);
      return {
        'pending':[],
        'canceled':[],
        'finished':[]
      };
    }

  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: KovilAppBar(withIcon: true,titleSize: 20,actions: [Padding(
        padding: const EdgeInsets.all(10),
        child: GestureDetector(
          onTap:()=>showDialog(
            context: context, 
            builder: (context)=>ImageShowerDialog(imageUrl: "$BASEURL/panchagam/calendar?date=${DateFormat("yyyy-MM-dd").format(DateTime.now())}",)
          ),
          child:  SvgPicture.asset(
            "assets/svg/calendar-svgrepo-com.svg",
            width: 30,
          )
        ),
      )],
      ),
      body: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              const SizedBox(height: 10),
              const TabBar(
                labelColor: Colors.black,
                indicatorColor: Colors.orange,
                tabs: [
                  Tab(text: 'Pending'),
                  Tab(text: 'Canceled'),
                  Tab(text: 'Completed'),
                ],
              ),
          Expanded(
            child: FutureBuilder(
              future: getEvents(context), 
              builder: (context,snapshot){
                if (snapshot.connectionState==ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator());
                }
                else{
                  List<Map> pending=snapshot.data['pending'] ?? [];
                  List<Map> cancled=snapshot.data['canceled'] ?? [];
                  List<Map> finished=snapshot.data['finished'] ?? [];
                  return TabBarView(
                        children: [
                          pending.isNotEmpty?  _buildEvents(pending, 0,context) : Center(child: Text("No Data Found"),),
                          cancled.isNotEmpty? _buildEvents(cancled, 1,context) : Center(child: Text("No Data Found"),),
                          finished.isNotEmpty? _buildEvents(finished, 2,context) :Center(child: Text("No Data Found"),),
                        ],
                  );
                }
              }
          )
      ),
    
    ],
    )
  )
  );
}
}

