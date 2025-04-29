import 'dart:convert';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sampleflutter/custom_controls/cust_snacbar.dart';
import 'package:sampleflutter/custom_controls/custom_ad.dart';
import 'package:sampleflutter/custom_controls/custom_appbar.dart';
import 'package:sampleflutter/custom_controls/event_card.dart';
import 'package:sampleflutter/utils/event.dart';
import 'package:sampleflutter/utils/network_request.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';


Widget _buildEvents(List<Map> events,int currentTabIndex,BuildContext context){
  return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context,index){
        return EventCard(eventDetails: events[index],currentTabIndex: currentTabIndex,);
      }
    );
}

class AllEventsPage extends StatefulWidget {
  const AllEventsPage({super.key});

  @override
  State<AllEventsPage> createState() => _AllEventsPageState();
}

class _AllEventsPageState extends State<AllEventsPage> with TickerProviderStateMixin {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay=DateTime.now();

  List<Map> customEvents=events;
  Future getEvents()async {
    print(DateFormat("yyyy-MM-dd").format(_selectedDay));
    final res=await NetworkService.sendRequest(path: "/event/specific?date=${DateFormat("yyyy-MM-dd").format(_selectedDay)}", context: context);
    final decodedRes=jsonDecode(res.body);
    print(decodedRes);
    if (res.statusCode==200){
      final List<Map> eventsList=List.from(decodedRes['events']);
      final List<Map> pending=eventsList.where((e)=>e["event_status"]=="pending").toList();
      final List<Map> cancled=eventsList.where((e)=>e["event_status"]=="canceled").toList();
      final List<Map> finished=eventsList.where((e)=>e["event_status"]=="completed").toList();
      print("specif $finished");
      return {
        "pending":pending,
        "canceled":cancled,
        "finished":finished
      };
    }
    else{
      customSnackBar(content: decodedRes['detail'], contentType: AnimatedSnackBarType.error);
      return {
        "pending":[],
        "canceled":[],
        "finished":[]
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
            builder: (context)=>ImageShowerDialog(imageUrl: "$BASEURL/panchagam/calendar?date=${DateFormat("yyyy-MM-dd").format(_selectedDay)}",)
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
      TableCalendar(
        firstDay: DateTime.utc(2025, 1, 1),
        lastDay: DateTime.utc(2026, 1, 1),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        calendarStyle: CalendarStyle(
          selectedDecoration: BoxDecoration(
            color: Colors.orange.shade800,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: Colors.orange.shade400,
            shape: BoxShape.circle,
          ),
        ),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
            _calendarFormat = CalendarFormat.week;
          });
        },
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
      ),
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
          future: getEvents(), 
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }
            else{
              final List<Map> pending=snapshot.data['pending'] ?? [];
              final List<Map> cancled=snapshot.data['canceled']?? [];
              final List<Map> finished=snapshot.data['finished'] ?? [];
              print("hahhh $snapshot");
              return TabBarView(
                children: [
                  pending.isNotEmpty? _buildEvents(pending, 0,context) : Center(child: Text("No Data Found"),),
                  cancled.isNotEmpty? _buildEvents(cancled, 1,context) : Center(child: Text("No Data Found"),),
                  finished.isNotEmpty? _buildEvents(finished,2, context) : Center(child: Text("No Data Found"),),
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


