import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sampleflutter/custom_controls/custom_appbar.dart';
import 'package:sampleflutter/utils/builders/event_name.dart';
import 'package:sampleflutter/custom_controls/event_name_card.dart';
import 'package:sampleflutter/utils/network_request.dart';
import 'package:sampleflutter/utils/random_loading.dart';



class AddEventNamePage extends StatefulWidget {
  const AddEventNamePage({super.key});

  @override
  State<AddEventNamePage> createState() => _AddEventNamePageState();
}

class _AddEventNamePageState extends State<AddEventNamePage> {

  List normalEventsAmnt=[];
  List specialEventsAmnt=[];
  List neivethiyamNamesAmount=[];
  bool isLoading=true;

  void onDeleteEventName(bool isForNeivethiyam,bool isForSpecial,int indexToDelete){
    List eventNameToDeleteList=isForNeivethiyam? neivethiyamNamesAmount : isForSpecial? specialEventsAmnt : normalEventsAmnt;

    setState(() {
      eventNameToDeleteList.removeAt(indexToDelete);
    });
    
  }

  void onEventNameAdd(Map addedEventName,String addTo){
    List eventNameToAdd=(addTo=='neivethiyam')? neivethiyamNamesAmount : (addTo=="special")? specialEventsAmnt : normalEventsAmnt;

    setState(() {
       eventNameToAdd.insert(0, addedEventName);
    });
  }

  Widget makeEventNamesAmountCard(List eventNamesAmount, bool isForNeivethiyam,bool isForSpecial) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: eventNamesAmount.length,
      itemBuilder: (context, index) {
        return RepaintBoundary(
          child: EventNameAmountCard(
            eventNameId: eventNamesAmount[index]['id'],
            eventName: eventNamesAmount[index]['name'],
            eventAmount: eventNamesAmount[index]['amount'].toString(),
            isForNeivethiyam: isForNeivethiyam,
            isForSpecial: isForSpecial,
            curIndex:index,
            onDelete: onDeleteEventName,
          ),
        );
      },
    );
  }
  Future getEventNames({required BuildContext context}) async {
    final res = await NetworkService.sendRequest(path: '/event/name', context: context);
    if (res != null) {
      final eventNamesAmountList = List.from(res['event_names']);
      
      return {
        'normalEventsAmnt': eventNamesAmountList.where((e) => e['is_special'] == false).toList(),
        'specialEventsAmnt': eventNamesAmountList.where((e) => e['is_special'] == true).toList(),
      };
    }

    return {
        'normalEventsAmnt': [],
        'specialEventsAmnt': [],
        'eventNameAmountList':[],
      };
  }

  Future getNeivethiyamNames({required BuildContext context}) async {
    final res = await NetworkService.sendRequest(path: '/neivethiyam/name', context: context);
    if (res != null) {
      return List.from(res['neivethiyam_names']);
    }
    return [];
  }

  Future fetchAllEventsNames()async {
    final results=await Future.wait([getEventNames(context: context),getNeivethiyamNames(context: context)]);
    setState(() {
      normalEventsAmnt=results[0]['normalEventsAmnt'];
      specialEventsAmnt=results[0]['specialEventsAmnt'];
      neivethiyamNamesAmount=results[1];
      isLoading=false;
    });
  }

  @override
  void initState(){
    super.initState();
    fetchAllEventsNames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MediaQuery.of(context).size.width>400? null : KovilAppBar(withIcon: true),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(
              labelColor: Colors.black,
              indicatorColor: Colors.orange,
              
              tabs: [
                Tab(text: 'New'),
                Tab(text: 'Event Names'),
                Tab(text: 'Neivethiyam'),
              ],
            ),
            Expanded(
              child: isLoading ? Center(
                child: Column(
                  
                  children: [
                    LottieBuilder.asset(getRandomLoadings(),height: MediaQuery.of(context).size.height*0.5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Please wait while fetching event names...",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w600,color: Colors.orange),),
                        VerticalDivider(),
                        SizedBox(width: 30,height: 30, child: CircularProgressIndicator(color: Colors.orange,padding: EdgeInsets.all(5),))
                      ],
                    )
                  ],
                )
              )
        
              : TabBarView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: AddEventNewName(onEventNameAdded: (addedEventName, addTo) => onEventNameAdd(addedEventName, addTo),),
                    ),
                    DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          TabBar(
                            labelColor: Colors.black,
                            indicatorColor: Colors.orange,
                            tabs: [
                              Tab(text: 'Normal'),
                              Tab(text: 'Special'),
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                normalEventsAmnt.isNotEmpty
                                    ? makeEventNamesAmountCard(normalEventsAmnt, false,false)
                                    : Center(child: Text('No data found')),
                                specialEventsAmnt.isNotEmpty
                                    ? makeEventNamesAmountCard(specialEventsAmnt, false,true)
                                    : Center(child: Text('No data found')),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    neivethiyamNamesAmount.isNotEmpty
                        ? makeEventNamesAmountCard(neivethiyamNamesAmount, true,false)
                        : Center(child: Text('No data found')),
                  ],
                )
              
            ),
          ],
        ),
      ),
    );
  }
}
