import 'package:flutter/material.dart';
import 'package:sampleflutter/utils/network_request.dart';
import 'package:sampleflutter/custom_controls/custom_appbar.dart';
import 'package:sampleflutter/custom_controls/event_dashboard_container.dart';

List<Widget> rowBuilder(List items) {
  print("items ${items.length}");
  List<Widget> rows = [];
  List<Widget> temp = [];
  if (items.isNotEmpty) {
    int count = 0;
    // FeaturesContainer(svgLink: items[i]["svg"], label: items[i]["label"], shadowColor: items[i]["sc"], containerColor: items[i]["cc"])
    for (int i = 0; i < items.length; i++) {
      print(i);
      temp.add(
        EventDashboardContainer(
          eventCount: items[i]['count'],
          totCount: 10,
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
    print("rows length $rows");
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
  DateTime? fromDate=DateTime.now();
  DateTime? toDate=DateTime.now();
  List eventsDashboard = [];
  bool isLoading = false;

  Future getEventDashboard(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    final res = await NetworkService.sendRequest(
      path: '/event/dashboard?from_date=$fromDate&to_date=$toDate',
      context: context,
    );
    print("res $res");
    setState(() {
      isLoading = false;
    });
    if (res != null) {
      eventsDashboard = List<Map>.from(res['events_dashboard']);
    }
  }

  @override
  void initState() {
    super.initState();
    // getEventDashboard(context);
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
      appBar: KovilAppBar(),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator(color: Colors.orange))
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
                  ...rowBuilder(eventsDashboard),
                ],
              ),
    );
  }
}
