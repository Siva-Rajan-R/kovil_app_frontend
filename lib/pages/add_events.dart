import 'package:sampleflutter/utils/custom_print.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sampleflutter/custom_controls/cust_bottom_appbar.dart';
import 'package:sampleflutter/custom_controls/cust_textfield.dart';
import 'package:sampleflutter/custom_controls/custom_appbar.dart';
import 'package:sampleflutter/custom_controls/custom_dropdown.dart';
import 'package:sampleflutter/pages/add_events_next.dart';
import 'package:intl/intl.dart';
import 'package:sampleflutter/utils/global_variables.dart';
import 'package:sampleflutter/utils/network_request.dart';
import 'package:sampleflutter/utils/random_loading.dart';

String formatTimeOfDay(TimeOfDay tod) {
  final now = DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
  return DateFormat('hh:mm a').format(dt); // 12hr format with AM/PM
}

Map<String, dynamic>? extractNameAndNumberFromNeivethiyam(String input) {
  // Match pattern like "somename-1"
  RegExp regExp = RegExp(r'([a-zA-Z]+)-(\d+)');
  Match? match = regExp.firstMatch(input);

  if (match != null) {
    String name = match.group(1)!;
    double number = double.parse(match.group(2)!);
    printToConsole(" esrwaerauiokmnzbd $name $number");
    return {'name': name, 'number': number};
  }

  return {'name': null, 'number': null}; // If no match found
}

class AddEventsPage extends StatefulWidget {
  final Map? existingEventDetails;
  const AddEventsPage({super.key, this.existingEventDetails});

  @override
  State<AddEventsPage> createState() => _AddEventsPageState();
}

class _AddEventsPageState extends State<AddEventsPage> {
  bool isloading = true;
  bool? isSpecial = false;
  late TextEditingController eventName;
  late TextEditingController neivethiyam;
  late TextEditingController eventDes;
  late TextEditingController padiKg;

  List<Map> eventNamesAmount = [];
  List<Map> neivethiyamNamesAmount = [];
  List paymentModes = [];
  List paymentStatus = [];
  String eventNameValue = "";
  double eventAmount = 0;
  String? neivethiyamName;
  double neivethiyamAmount = 0;
  int? neivethiyamId;
  DateTime? selectedDate;
  String? startTime;
  String? endTime;

  @override
  void initState() {
    super.initState();
    NetworkService.sendRequest(
      path: '/event/dropdown-values',
      context: context,
    ).then((res) {
      if (res != null) {
        setState(() {
          eventNamesAmount = List.from(res['event_names']);
          neivethiyamNamesAmount = List.from(res['neivethiyam_names']);
          paymentModes = res['payment_modes'];
          paymentStatus = res['payment_status'];
          neivethiyamNamesAmount.add({"name": null, "amount": 0});
          isloading = false;
        });
      }
    });
    String en = "";
    String ed = "";
    String nv = "";
    double nvKg = 1.0;

    if (widget.existingEventDetails != null) {
      printToConsole(
        "exists 1 ------------------------ ${widget.existingEventDetails!['neivethiyam_amount']} ${widget.existingEventDetails}",
      );
      en =
          widget.existingEventDetails!["is_special_event"] == null
              ? ""
              : widget.existingEventDetails!['event_name'] ?? "";
      ed = widget.existingEventDetails!["event_description"] ?? "";
      nv = widget.existingEventDetails!["neivethiyam_name"] ?? "";
      nvKg = (widget.existingEventDetails!['padi_kg'] ?? 0).toDouble();
      printToConsole("qwetyuiipdtftfyyc $nvKg");
      selectedDate = DateTime.parse(widget.existingEventDetails!['event_date']);
      startTime =
          widget.existingEventDetails!['event_start_at'] ?? "start time";
      endTime = widget.existingEventDetails!['event_end_at'] ?? "end time";
      eventNameValue =
          widget.existingEventDetails!["is_special_event"] != null
              ? widget.existingEventDetails!['event_name']
              : "";
      neivethiyamName = nv;
      neivethiyamAmount =
          (widget.existingEventDetails!['neivethiyam_amount'] ?? 0).toDouble();

      eventAmount =
          widget.existingEventDetails!["is_special_event"] != null
              ? (widget.existingEventDetails!['total_amount'] ?? 0).toDouble() -
                  (neivethiyamAmount*nvKg)
              : widget.existingEventDetails!['total_amount'].toDouble();

      neivethiyamId = widget.existingEventDetails!['neivethiyam_id'];
      isSpecial = widget.existingEventDetails!['is_special_event'];
      printToConsole("qwetyuiipdtftfyyc $isSpecial");
    }

    eventName = TextEditingController(text: en);
    eventDes = TextEditingController(text: ed);
    neivethiyam = TextEditingController(text: nv);
    padiKg = TextEditingController(text: nvKg.toString());
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
    printToConsole("hii bye $isSpecial hoooo $eventNamesAmount $neivethiyamAmount");
    return Scaffold(
      bottomNavigationBar:
          isloading
              ? null
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
                          "eventDate":
                              selectedDate != null
                                  ? DateFormat(
                                    "yyyy-MM-dd",
                                  ).format(selectedDate!)
                                  : DateFormat(
                                    "yyyy-MM-dd",
                                  ).format(DateTime.now()),
                          "startTime":
                              startTime != null
                                  ? startTime!
                                  : DateFormat(
                                    'hh:mm a',
                                  ).format(DateTime.now()),
                          "endTime":
                              endTime != null
                                  ? endTime!
                                  : DateFormat(
                                    'hh:mm a',
                                  ).format(DateTime.now()),
                          "eventAmount": eventAmount,
                          "paymentModes": paymentModes,
                          "paymentStatus": paymentStatus,
                          "neivethiyamName": neivethiyamName,
                          "neivethiyamId": neivethiyamId,
                          "neivethiyamAmount": neivethiyamAmount,
                          "isSpecialEvent": isSpecial,
                          "padiKg": padiKg.text,
                        };
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder:
                                (context) => AddEventsNextPage(
                                  previousPageData: data,
                                  existingEventDetails:
                                      widget.existingEventDetails,
                                ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          const Text("Next"),
                          const SizedBox(width: 10),
                          const Icon(Icons.arrow_forward, color: Colors.white),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      appBar: MediaQuery.of(context).size.width>phoneSize? null : KovilAppBar(withIcon: true),
      body:
          isloading
              ? Center(
                child: Column(
                  
                  children: [
                    LottieBuilder.asset(getRandomLoadings(),height: MediaQuery.of(context).size.height*0.5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Please wait while fetching event details...",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w600,color: Colors.orange),),
                        VerticalDivider(),
                        SizedBox(width: 30,height: 30, child: CircularProgressIndicator(color: Colors.orange,padding: EdgeInsets.all(5),))
                      ],
                    )
                  ],
                )
              )
              : SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 500),
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.orange.shade400,
                                Colors.orange.shade600,
                                Colors.orange.shade800,
                              ],
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
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
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomDropdown(
                                      width: 500,
                                      textColor: Colors.white,
                                      themeColor: Colors.white,
                                      label: "Event Name",
                                      ddController: eventName,
                                      ddEntries: [
                                        for (int i = 0; i < eventNamesAmount.length; i++)
                                          DropdownMenuEntry(
                                            value: i,
                                            label:
                                                "${eventNamesAmount[i]['name']} - ₹ ${eventNamesAmount[i]['amount']}",
                                          ),
                                      ],
                                      onSelected:
                                          (value) => {
                                            printToConsole("selected value $value"),
                                            setState(() {
                                              eventNameValue =
                                                  eventNamesAmount[value!]['name'];
                                              eventAmount =
                                                  eventNamesAmount[value]['amount']
                                                      .toDouble();
                                              isSpecial =
                                                  eventNamesAmount[value]['is_special'];
                                            }),
                                          },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                        
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomDropdown(
                                      width: null,
                                      textColor: Colors.white,
                                      themeColor: Colors.white,
                                      label: "Neivethiyam Name",
                                      ddController: neivethiyam,
                                      ddEntries: [
                                        for (
                                          int i = 0;
                                          i < neivethiyamNamesAmount.length;
                                          i++
                                        )
                                          DropdownMenuEntry(
                                            value: i,
                                            label:
                                                "${neivethiyamNamesAmount[i]["name"]} - ₹ ${neivethiyamNamesAmount[i]['amount']}",
                                          ),
                                      ],
                                      onSelected:
                                          (value) => {
                                            printToConsole(
                                              "selected value $value ${neivethiyamNamesAmount[value!]["amount"].runtimeType}",
                                            ),
                                            setState(() {
                                              neivethiyamName =
                                                  neivethiyamNamesAmount[value]["name"];
                                              neivethiyamAmount =
                                                  neivethiyamNamesAmount[value!]["amount"]
                                                      .toDouble();
                                              neivethiyamId =
                                                  neivethiyamNamesAmount[value]["id"];
                                              printToConsole("$neivethiyamId");
                                            }),
                                          },
                                    ),
                                  ),
                                  VerticalDivider(width: 3),
                                  Expanded(
                                    child: CustomTextField(
                                      label: "Padi/Kg",
                                      themeColor: Colors.white,
                                      fontColor: Colors.white,
                                      controller: padiKg,
                                      keyboardtype: TextInputType.number,
                                    ),
                                  ),
                                ],
                              ),
                        
                              const SizedBox(height: 20),
                        
                              TextField(
                                controller: eventDes,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                                cursorColor: Colors.white,
                                minLines: 2, // text color
                                decoration: InputDecoration(
                                  labelText: 'Event Description',
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ), // label color
                        
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
                                            : "${selectedDate!.toLocal()}".split(
                                              ' ',
                                            )[0],
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
                                        endTime == null ? "End Time" : endTime!,
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
              ),
    );
  }
}
