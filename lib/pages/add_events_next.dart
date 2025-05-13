
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sampleflutter/custom_controls/cust_bottom_appbar.dart';
import 'package:sampleflutter/custom_controls/custom_appbar.dart';
import 'package:sampleflutter/custom_controls/cust_textfield.dart';
import 'package:sampleflutter/custom_controls/custom_dropdown.dart';
import 'package:sampleflutter/pages/home.dart';
import 'package:sampleflutter/utils/network_request.dart';

class AddEventsNextPage extends StatefulWidget {
  final Map previousPageData;
  final Map? existingEventDetails;

  const AddEventsNextPage({
    required this.previousPageData,
    this.existingEventDetails,
    super.key,
  });

  @override
  State<AddEventsNextPage> createState() => _AddEventsNextPageState();
}

class _AddEventsNextPageState extends State<AddEventsNextPage> {
  bool isLoading = false;

  late TextEditingController clientName;
  late TextEditingController clientCity;
  late TextEditingController clientNumber;
  late TextEditingController totalAmount;
  late TextEditingController paidAmount;
  late TextEditingController paymentStatus;
  late TextEditingController paymentMode;
  late TextEditingController neivethiyamAmount;
  String buttonLabel = "Submit";
  String method = "POST";

  @override
  void initState() {
    super.initState();

    final data = widget.existingEventDetails;

    clientName = TextEditingController(text: data?['client_name'] ?? "");
    clientCity = TextEditingController(text: data?['client_city'] ?? "");
    clientNumber = TextEditingController(text: data?['client_mobile_number'] ?? "");
    totalAmount = TextEditingController(text: (widget.previousPageData['eventAmount']+widget.previousPageData["neivethiyamAmount"]).toString());
    paidAmount = TextEditingController(text: data?['paid_amount'].toString() ?? "0");
    paymentStatus = TextEditingController(text: data?['payment_status'] ?? "");
    paymentMode = TextEditingController(text: data?['payment_mode'] ?? "");

    if (data != null) {
      buttonLabel = "Update";
      method = "PUT";
    }
  }

  Future<void> _handleSubmit(BuildContext context) async {
    setState(() => isLoading = true);

    Map reqBody = {
      "event_name": widget.previousPageData['eventName'],
      "event_description": widget.previousPageData['eventDes'],
      "event_date": widget.previousPageData['eventDate'],
      "event_start_at": widget.previousPageData['startTime'],
      "event_end_at": widget.previousPageData['endTime'],
      "client_name": clientName.text,
      "client_mobile_number": clientNumber.text,
      "client_city": clientCity.text,
      "total_amount": totalAmount.text.isNotEmpty ? int.parse(totalAmount.text) : 0,
      "paid_amount": paidAmount.text.isNotEmpty ? int.parse(paidAmount.text) : 0,
      "payment_status": paymentStatus.text,
      "payment_mode": paymentMode.text,
      "neivethiyam_id":widget.previousPageData["neivethiyamId"]
    };

    if (method == "PUT") {
      reqBody["event_id"] = widget.existingEventDetails!["event_id"];
    }

    final res = await NetworkService.sendRequest(
      path: "/event",
      context: context,
      method: method,
      body: reqBody,
    );

    setState(() => isLoading = false);

    if (res!=null) {
      Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(builder: (context) => HomePage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KovilAppBar(height: 100),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.orange.shade400,
                  Colors.orange.shade600,
                  Colors.orange.shade800
                ]),
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.shade800,
                    blurRadius: 5,
                    spreadRadius: 2,
                    blurStyle: BlurStyle.outer
                  )
                ]
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Client Info",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 20
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    CustomTextField(label:"Client name" ,themeColor: Colors.white,fontColor: Colors.white,controller: clientName,),
                    SizedBox(height: 20,),
                    CustomTextField(label: "Client Number",themeColor: Colors.white,fontColor: Colors.white,keyboardtype: TextInputType.number,controller: clientNumber,),
                    SizedBox(height: 20,),
                    CustomTextField(label: "Client place",themeColor: Colors.white,fontColor: Colors.white,keyboardtype: TextInputType.streetAddress,controller: clientCity,),
                    SizedBox(height: 20,),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.orange.shade400,
                  Colors.orange.shade600,
                  Colors.orange.shade800
                ]),
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.shade800,
                    blurRadius: 5,
                    spreadRadius: 2,
                    blurStyle: BlurStyle.outer
                  )
                ]
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Payment Info",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 20
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    CustomTextField(label:"Total amount" ,themeColor: Colors.white,fontColor: Colors.white,keyboardtype: TextInputType.number,controller: totalAmount,),
                    SizedBox(height: 20,),
                    CustomTextField(label: "Paid amount",themeColor: Colors.white,fontColor: Colors.white,keyboardtype: TextInputType.number,controller: paidAmount,),
                    SizedBox(height: 20,),
                    SingleChildScrollView(
                      padding: EdgeInsets.only(top: 10),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [

                          CustomDropdown(
                            themeColor: Colors.white,
                            textColor: Colors.white,
                            Width: 250,
                            label: "Payment mode", 
                            ddController: paymentMode, 
                            ddEntries: [
                              for(String i in List.from(widget.previousPageData['paymentModes']).toList())
                                DropdownMenuEntry(value: i, label: i),
                            ], 
                            onSelected: (value)=>print(value)
                          ),
                          
                          SizedBox(width: 10,),
                          
                          CustomDropdown(
                            themeColor: Colors.white,
                            textColor: Colors.white,
                            Width: 250,
                            label: "Payment status", 
                            ddController: paymentStatus, 
                            ddEntries: [
                                for(String i in widget.previousPageData['paymentStatus'])
                                DropdownMenuEntry(value: i, label: i),
                              ], 
                            onSelected: (value)=>print(value)
                          ),
                            
                        ],
                      ),
                    ),
                    
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomAppbar(
        bottomAppbarChild: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: isLoading ? null : () => _handleSubmit(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Text(buttonLabel, style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
