import 'package:flutter/material.dart';
import 'package:sampleflutter/custom_controls/custom_appbar.dart';
import 'package:sampleflutter/custom_controls/features_container.dart';
import 'package:sampleflutter/pages/worker_dashboard.dart';

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
  
  


class DashboardPage extends StatelessWidget{
  
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {

  List<Map<String,dynamic>> featuresSvg=[
            {"label":"Worker DashBoard","svg":"assets/svg/service-workers-svgrepo-com.svg","cc":Colors.yellow.shade50,"sc":Colors.yellow.shade300,"route":WorkerDashboardPage()},
            // {"label":"Event DashBoard","svg":"assets/svg/checklist-svgrepo-com.svg","cc":Colors.red.shade50,"sc":Colors.red.shade100,"route":WorkerDashboardPage()}
            
          ];
          
          
        return Scaffold(
          appBar: KovilAppBar(withIcon: true,),
            body: Column(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            "Dashboards",
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
                  ...rowBuilder(featuresSvg)
                    
                  ],
                )
              ],
            )
          );
    }
  


} 