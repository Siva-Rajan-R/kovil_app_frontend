import 'package:flutter/material.dart';
import 'package:sampleflutter/custom_controls/custom_appbar.dart';
import 'package:sampleflutter/custom_controls/features_container.dart';
import 'package:sampleflutter/pages/events.dart';
import 'package:sampleflutter/pages/tamil_calendar.dart';
// void main(){
//   runApp(HomePage());
// }

// Container(
//                 alignment: Alignment.center,
//                 width: double.infinity,
//                 height: 150,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       Colors.orange.shade400,
//                       Colors.orange.shade700,
//                       Colors.orange.shade800
//                     ],
//                     begin: Alignment.topLeft,
//                     end: Alignment.topRight
//                   ),
//                   borderRadius: BorderRadius.only(bottomLeft: Radius.elliptical(20, 20),bottomRight: Radius.elliptical(20, 20))
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SvgPicture.asset(
//                       "assets/svg/temple-india-svgrepo-com.svg",
//                       width: 40,
//                       height: 40,
//                     ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Text(
//                       "Nanmai Tharuvar Kovil",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20,
//                         color: Colors.white
                        
//                       ),
//                     )
//                   ],
//                 ),
//               ),

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
  
  


class HomePage extends StatelessWidget{
  HomePage({super.key});

  final List<Map<String,dynamic>> featuresSvg=[
    {"label":"Tamil Calendar","svg":"assets/svg/calendar-svgrepo-com.svg","cc":Colors.yellow.shade50,"sc":Colors.yellow.shade300,"route":TamilCalendarPage()},
    {"label":"All Events","svg":"assets/svg/event svy.svg","cc":Colors.purple.shade50,"sc":Colors.purple.shade100,"route":EventsPage()},
    {"label":"Today Events","svg":"assets/svg/news-svgrepo-com.svg","cc":Colors.pink.shade50,"sc":Colors.pink.shade100,"route":TamilCalendarPage()},
    {"label":"Add Events","svg":"assets/svg/calendar-add-event-svgrepo-com.svg","cc":Colors.green.shade50,"sc":Colors.green.shade100,"route":TamilCalendarPage()},
    {"label":"Users","svg":"assets/svg/users-young-svgrepo-com.svg","cc":Colors.cyan.shade50,"sc":Colors.cyan.shade100,"route":TamilCalendarPage()},
    {"label":"Dashboard","svg":"assets/svg/analytics-clipboard-svgrepo-com.svg","cc":Colors.grey.shade300,"sc":Colors.grey.shade300,"route":TamilCalendarPage()},
    {"label":"Logout","svg":"assets/svg/logout-svgrepo-com.svg","cc":Colors.red.shade50,"sc":Colors.red.shade100,"route":TamilCalendarPage()},
    
  ];
    final String user="admin";
  
  @override
  Widget build(BuildContext context) {
  List<Map<String,dynamic>> visibleFeatures=[];
    if (user=="admin"){
      visibleFeatures=featuresSvg;
    }
    else{
      visibleFeatures=[
        ...featuresSvg.sublist(0,3),
        featuresSvg.last
        
      ];
      print(visibleFeatures);
    }
    
    return Scaffold(
      appBar: KovilAppBar(),
        body: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "Features",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade800
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
               ...rowBuilder(visibleFeatures)
                
              ],
            )
          ],
        )
      );
  }
} 