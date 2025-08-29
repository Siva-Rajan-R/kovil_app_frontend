
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';



class EventDashboardContainer extends StatelessWidget {
  final int eventCount;
  final int totCount;
  final String eventStatus;
  final double eventAmnt;
  final Color themeColor;

  const EventDashboardContainer({
    super.key,
    required this.eventCount,
    required this.totCount,
    required this.eventStatus,
    required this.eventAmnt,
    required this.themeColor,
  });



  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        boxShadow: [
          BoxShadow(
            color: themeColor,
            blurRadius: 2,
            spreadRadius: 2,
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      child: Column(
        children: [
          CircularPercentIndicator(
            radius: 60.0,
            lineWidth: 10.0,
            percent: eventCount / totCount,
            center: Text(
              '$eventCount / $totCount',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            backgroundColor: Colors.grey.shade200,
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: themeColor,
          ),
          SizedBox(width: 30),
          Text(
            eventStatus.toUpperCase(),
            style: TextStyle(color: themeColor, fontWeight: FontWeight.w600),
          ),
          SizedBox(width: 30),
          Text("₹ $eventAmnt", style: TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
