import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sampleflutter/custom_controls/custom_appbar.dart';
import 'package:sampleflutter/custom_controls/features_container.dart';

List<Widget> rowBuilder(List<Map<String,dynamic>> items){
  print("items ${items.length}");
  List<Widget> rows=[];
  List<Widget> temp=[];

  int count=0;
  // FeaturesContainer(svgLink: items[i]["svg"], label: items[i]["label"], shadowColor: items[i]["sc"], containerColor: items[i]["cc"])
  for(int i=0 ; i<items.length ; i++){
      print(i);
      temp.add(FeaturesContainer(svgLink: items[i]["svg"], label: items[i]["label"], shadowColor: items[i]["sc"], containerColor: items[i]["cc"],route: items[i]["route"],));
      count++;
      if(count==3){
        rows.add(Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: List.from(temp),));
        rows.add(SizedBox(height: 10,));
        temp.clear();
        count=0;
      }
    }
  if(temp.isNotEmpty){
    rows.add(Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: List.from(temp),));
    temp.clear();
  }
  print("rows length $rows");
  return rows;
    
  }
class EventDashboardPage extends StatelessWidget {
  final List<Map<String, dynamic>> statusData = [
    {'count': 5, 'tot_amount': 5000, 'status': 'pending'},
    {'count': 3, 'tot_amount': 3000, 'status': 'completed'},
    {'count': 2, 'tot_amount': 2000, 'status': 'canceled'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KovilAppBar(),
      body: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          constraints: BoxConstraints(minHeight: 220), // ✅ Increased height
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularPercentIndicator(
                radius: 60.0,
                lineWidth: 10.0,
                percent: 0.5,
                center: Text(
                  '688',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                backgroundColor: Colors.grey.shade200,
                circularStrokeCap: CircularStrokeCap.round,
              ),
              SizedBox(height: 12),
              Text(
                "pending",
                style: TextStyle(
                  fontWeight: FontWeight.w600,

                ),
              ),
              SizedBox(height: 6),
              Text(
                '₹ 5777',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      )
  
    );
  }
}
