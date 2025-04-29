import 'dart:convert';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sampleflutter/custom_controls/cust_bottom_appbar.dart';
import 'package:sampleflutter/custom_controls/cust_snacbar.dart';
import 'package:sampleflutter/custom_controls/cust_textfield.dart';
import 'package:sampleflutter/custom_controls/custom_appbar.dart';
import 'package:sampleflutter/pages/add_events_next.dart';
import 'package:intl/intl.dart';
import 'package:sampleflutter/utils/network_request.dart';

String formatTimeOfDay(TimeOfDay tod) {
  final now = DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
  return DateFormat('hh:mm a').format(dt); // 12hr format with AM/PM
}

class AddEventsPage extends StatefulWidget {
  const AddEventsPage({super.key});

  

  @override
  State<AddEventsPage> createState() => _AddEventsPageState();
}

class _AddEventsPageState extends State<AddEventsPage> {
  final TextEditingController eventName = TextEditingController();
  final TextEditingController eventDes = TextEditingController();
  List eventNamesAmount=[];
  int eventAmount=0;
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  @override
  void initState(){
    super.initState();
    NetworkService.sendRequest(path: '/event/name', context: context).then((res){
      final decodedRes=jsonDecode(res.body);
      print("from res $decodedRes");
      if(res.statusCode==200){
        setState(() {
          eventNamesAmount=List.from(decodedRes['event_names']);
        });
        
      }
      else{
        customSnackBar(content: decodedRes['detail'], contentType: AnimatedSnackBarType.error).show(context);
      }

      
    });
    
  }
  Future<void> pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.parse("2025-01-01"),
      lastDate: DateTime(DateTime.now().year, 12, 31),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> pickStartTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        startTime = picked;
      });
    }
  }

  Future<void> pickEndTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: startTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        endTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      bottomNavigationBar: CustomBottomAppbar(
        bottomAppbarChild: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade700,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Map data = {
                  "eventName": eventName.text.trim(),
                  "eventDes": eventDes.text.trim(),
                  "eventDate": selectedDate != null
                      ? DateFormat("yyyy-MM-dd").format(selectedDate!)
                      : DateFormat("yyyy-MM-dd").format(DateTime.now()),
                  "startTime": startTime != null
                      ? formatTimeOfDay(startTime!)
                      : DateFormat('hh:mm a').format(DateTime.now()),
                  "endTime":endTime != null
                      ? formatTimeOfDay(endTime!)
                      : DateFormat('hh:mm a').format(DateTime.now()),
                  "eventAmount":eventAmount.toString()
                };
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => AddEventsNextPage(
                      previousPageData: data,
                    ),
                  ),
                );
              },
              child: Row(
                children: [
                  const Text("Next"),
                  const SizedBox(width: 10),
                  const Icon(Icons.arrow_forward,color: Colors.white,),
                ],
              ),
            ),
          ],
        )
      ),
      appBar: KovilAppBar(withIcon: true),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.orange.shade400,
                  Colors.orange.shade600,
                  Colors.orange.shade800,
                ]),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.shade800,
                    blurRadius: 5,
                    spreadRadius: 2,
                    blurStyle: BlurStyle.outer,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Event Info",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    DropdownMenu(
                      width: 280,
                      label: Text("Event Name"),
                      controller: eventName,
                      menuStyle: MenuStyle(
                        backgroundColor: WidgetStatePropertyAll<Color>(Colors.orange.shade100)
                      ),
                      dropdownMenuEntries: [
                        for(int i=0;i<eventNamesAmount.length;i++)
                          
                          DropdownMenuEntry(value: i, label: eventNamesAmount[i]["name"])
                        
                      ],
                      onSelected: (value) => {
                        print("selected value $value"),
                        setState(() {
                          eventAmount=eventNamesAmount[value!]['amount'];
                        })
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: "Event description",
                      themeColor: Colors.white,
                      fontColor: Colors.white,
                      controller: eventDes,
                    ),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                            ),
                            onPressed: () => pickDate(context),
                            child: Text(
                              selectedDate == null
                                  ? "Pick Date"
                                  : "${selectedDate!.toLocal()}".split(' ')[0],
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                            ),
                            onPressed: () => pickStartTime(context),
                            child: Text(
                              startTime == null
                                  ? "Start Time"
                                  : formatTimeOfDay(startTime!),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                            ),
                            onPressed: () => pickEndTime(context),
                            child: Text(
                              endTime == null
                                  ? "End Time"
                                  : formatTimeOfDay(endTime!),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
