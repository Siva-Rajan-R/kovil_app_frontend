import 'package:sampleflutter/utils/custom_print.dart';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sampleflutter/utils/network_request.dart';
import 'package:sampleflutter/custom_controls/custom_appbar.dart';
import 'package:sampleflutter/custom_controls/event_dashboard_container.dart';
import 'package:sampleflutter/utils/random_loading.dart';

List<Widget> rowBuilder(List items,eventTotCount) {
  printToConsole("items ${items.length}");
  List<Widget> rows = [];
  List<Widget> temp = [];
  if (items.isNotEmpty) {
    int count = 0;
    // FeaturesContainer(svgLink: items[i]["svg"], label: items[i]["label"], shadowColor: items[i]["sc"], containerColor: items[i]["cc"])
    for (int i = 0; i < items.length; i++) {
      printToConsole("$i");
      temp.add(
        EventDashboardContainer(
          eventCount: items[i]['count'],
          totCount: eventTotCount,
          eventStatus: items[i]['status'],
          eventAmnt: items[i]['total_amount'],
          themeColor:
              items[i]['status'] == 'pending'
                  ? Colors.orange
                  : items[i]['status'] == 'canceled'
                  ? Colors.red
                  : Colors.green,
        ),
      );
      count++;
      if (count == 2) {
        rows.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.from(temp),
          ),
        );
        rows.add(SizedBox(height: 10));
        temp.clear();
        count = 0;
      }
    }
    if (temp.isNotEmpty) {
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.from(temp),
        ),
      );
      temp.clear();
    }
    printToConsole("rows length $rows");
    return rows;
  }
  return [Center(child: Text("No data found, select a different date",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15),))];
}

class EventDashboardPage extends StatefulWidget {
  const EventDashboardPage({super.key});
  @override
  State<EventDashboardPage> createState() => _EventDashboardPageState();
}

class _EventDashboardPageState extends State<EventDashboardPage> {
  final DateTime tdyDate=DateTime.now();
  DateTime? fromDate;
  DateTime? toDate;
  List eventsDashboard = [];
  bool isLoading = false;
  int eventTotCount=0;
  double eventTotAmnt=0.0;

  Future getEventDashboard(BuildContext context) async {
    printToConsole("$fromDate");
    setState(() {
      isLoading = true;
    });
    final res = await NetworkService.sendRequest(
      path: '/event/dashboard?from_date=$fromDate&to_date=$toDate',
      context: context,
    );
    printToConsole("res $res");
    setState(() {
      isLoading = false;
    });

    if (res != null) {

      eventTotAmnt=0.0;
      eventTotCount=0;

      eventsDashboard = List<Map>.from(res['events_dashboard']);
      for(int index=0;index<eventsDashboard.length;index++){
        eventTotAmnt+=(eventsDashboard[index]['total_amount'] as num).toDouble();
        eventTotCount+=(eventsDashboard[index]['count'] as num).toInt();
        printToConsole("vanakam pangaki $eventTotAmnt");
      }
    }
  }
  
  @override
  void initState() {
    super.initState();
    fromDate=DateTime(tdyDate.year, tdyDate.month, tdyDate.day);
    toDate=DateTime(tdyDate.year, tdyDate.month, tdyDate.day);
    getEventDashboard(context);
  }

  Future<void> pickFromDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.parse("2025-01-01"),
      lastDate: DateTime(DateTime.now().year, 12, 31),
    );
    if (picked != null) {
      setState(() {
        fromDate = picked;
      });
    }
  }

  Future<void> pickToDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.parse("2025-01-01"),
      lastDate: DateTime(DateTime.now().year, 12, 31),
    );
    if (picked != null) {
      setState(() {
        toDate = picked;
      });

      await getEventDashboard(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KovilAppBar(withIcon: true,),
      body:
          isLoading
              ? Center(
                child: Column(
                  
                  children: [
                    LottieBuilder.asset(getRandomLoadings(),height: MediaQuery.of(context).size.height*0.5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Please wait while fetching event info...",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w600,color: Colors.orange),),
                        VerticalDivider(),
                        SizedBox(width: 30,height: 30, child: CircularProgressIndicator(color: Colors.orange,padding: EdgeInsets.all(5),))
                      ],
                    )
                  ],
                )
              )
              : Column(
                children: [
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => pickFromDate(context),
                        child: Text(
                          fromDate == null
                              ? "Pick Start Date"
                              : "${fromDate!.toLocal()}".split(' ')[0],
                        ),
                      ),
                      Text(
                        "To",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.orange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => pickToDate(context),
                        child: Text(
                          toDate == null
                              ? "Pick End Date"
                              : "${toDate!.toLocal()}".split(' ')[0],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  ...rowBuilder(eventsDashboard,eventTotCount),
                ],
              ),
    );
  }
}
