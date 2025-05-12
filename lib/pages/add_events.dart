import 'dart:convert';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sampleflutter/custom_controls/cust_bottom_appbar.dart';
import 'package:sampleflutter/custom_controls/cust_snacbar.dart';
import 'package:sampleflutter/custom_controls/custom_appbar.dart';
import 'package:sampleflutter/custom_controls/custom_dropdown.dart';
import 'package:sampleflutter/pages/add_events_next.dart';
import 'package:intl/intl.dart';
import 'package:sampleflutter/utils/network_request.dart';

String formatTimeOfDay(TimeOfDay tod) {
  final now = DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
  return DateFormat('hh:mm a').format(dt); // 12hr format with AM/PM
}




class AddEventsPage extends StatefulWidget {
  final Map? existingEventDetails;
  const AddEventsPage({super.key,this.existingEventDetails});

  

  @override
  State<AddEventsPage> createState() => _AddEventsPageState();
}

class _AddEventsPageState extends State<AddEventsPage> {
  bool isloading=true;
  late TextEditingController eventName;
  late TextEditingController neivethiyam;
  late TextEditingController eventDes;
  List<Map> eventNamesAmount=[];
  List<Map> neivethiyamNamesAmount=[];
  List paymentModes=[];
  List paymentStatus=[];
  String eventNameValue="";
  int eventAmount=0;
  int neivethiyamAmount=0;
  int? neivethiyamId;
  DateTime? selectedDate;
  String? startTime;
  String? endTime;

  @override
  void initState(){
    super.initState();
    NetworkService.sendRequest(path: '/event/dropdown-values', context: context).then((res){
      final decodedRes=jsonDecode(utf8.decode(res.bodyBytes));

      print("from res $decodedRes");
      
        if(res.statusCode==200){
          setState(() {
            eventNamesAmount=List.from(decodedRes['event_names']);
            neivethiyamNamesAmount=List.from(decodedRes['neivethiyam_names']);
            paymentModes=decodedRes['payment_modes'];
            paymentStatus=decodedRes['payment_status'];
            neivethiyamNamesAmount.add({"name":null,"amount":0});
            isloading=false;
          });
          
        }
        else{
          customSnackBar(content: decodedRes['detail'], contentType: AnimatedSnackBarType.error).show(context);
        }
        
    });
    String en="";
    String ed="";
    String nv="";
    if(widget.existingEventDetails!=null){
      print("exists 1 ------------------------ ${widget.existingEventDetails!["neivethiyam_name"]}");
      en=widget.existingEventDetails!['event_name'] ?? "";
      ed=widget.existingEventDetails!["event_description"] ?? "";
      nv=widget.existingEventDetails!["neivethiyam_name"] ?? "";
      selectedDate=DateTime.parse(widget.existingEventDetails!['event_date']);
      startTime=widget.existingEventDetails!['event_start_at'] ?? "start time";
      endTime=widget.existingEventDetails!['event_end_at'] ?? "end time";
      eventNameValue=widget.existingEventDetails!['event_name'];
      neivethiyamAmount=widget.existingEventDetails!['neivethiyam_amount'] ?? 0;
      eventAmount=widget.existingEventDetails!['total_amount']-neivethiyamAmount;

    }

    eventName = TextEditingController(text: en);
    eventDes = TextEditingController(text: ed);
    neivethiyam=TextEditingController(text: nv);
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
        startTime = formatTimeOfDay(picked);
      });
    }
  }

  Future<void> pickEndTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        endTime = formatTimeOfDay(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("hii bye $eventNamesAmount");
      return Scaffold(
        bottomNavigationBar: isloading? null 
        : CustomBottomAppbar(
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
                    "eventName": eventNameValue.trim(),
                    "eventDes": eventDes.text.trim(),
                    "eventDate": selectedDate != null
                        ? DateFormat("yyyy-MM-dd").format(selectedDate!)
                        : DateFormat("yyyy-MM-dd").format(DateTime.now()),
                    "startTime": startTime != null
                        ? startTime!
                        : DateFormat('hh:mm a').format(DateTime.now()),
                    "endTime":endTime != null
                        ? endTime!
                        : DateFormat('hh:mm a').format(DateTime.now()),
                    "eventAmount":eventAmount,
                    "paymentModes":paymentModes,
                    "paymentStatus":paymentStatus,
                    "neivethiyamName":neivethiyam.text,
                    "neivethiyamId":neivethiyamId,
                    "neivethiyamAmount":neivethiyamAmount
                  };
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => AddEventsNextPage(
                        previousPageData: data,
                        existingEventDetails: widget.existingEventDetails,
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
        body: isloading? Center(child: CircularProgressIndicator(color: Colors.orange, strokeWidth: 3),) 
        : SingleChildScrollView(
          child: Column(
            children: [
              Container(
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
                    CustomDropdown(
                      textColor: Colors.white,
                      themeColor: Colors.white,
                      label: "Event Name", 
                      ddController: eventName, 
                      ddEntries: [
                        for(int i=0;i<eventNamesAmount.length;i++)
                          DropdownMenuEntry(
                            value: i, 
                            label: "${eventNamesAmount[i]['name']} - ₹ ${eventNamesAmount[i]['amount']}",
                          )
                      ], 
                      onSelected: (value) => {
                        print("selected value $value"),
                        setState(() {
                          eventNameValue=eventNamesAmount[value!]['name'];
                          eventAmount=eventNamesAmount[value]['amount'];
                        })
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomDropdown(
                      textColor: Colors.white,
                      themeColor: Colors.white,
                      label: "Neivethiyam Name", 
                      ddController: neivethiyam, 
                      ddEntries:[
                        for(int i=0;i<neivethiyamNamesAmount.length;i++)
                          DropdownMenuEntry(
                            value: i, 
                            label: "${neivethiyamNamesAmount[i]["name"]} - ₹ ${neivethiyamNamesAmount[i]['amount']}",
                          )
                      ],
                      onSelected: (value) => {
                        print("selected value $value"),
                        setState(() {
                          neivethiyamAmount=neivethiyamNamesAmount[value!]["amount"];
                          neivethiyamId=neivethiyamNamesAmount[value]["id"];
                          print(neivethiyamId);
                        })
                      },
                    ),
                    
                    const SizedBox(height: 20),

                    TextField(
                      controller: eventDes,
                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),
                      cursorColor: Colors.white,
                      minLines: 2, // text color
                      decoration: InputDecoration(
                        labelText: 'Event Description',
                        labelStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 13), // label color
                        
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        alignLabelWithHint: true,
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
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
                                  : startTime!,
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
                                  : endTime!,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }
}
