
import 'package:sampleflutter/utils/custom_print.dart';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:sampleflutter/custom_controls/cust_snacbar.dart';
import 'package:sampleflutter/custom_controls/cust_textfield.dart';
import 'package:sampleflutter/custom_controls/custom_dropdown.dart';
import 'package:sampleflutter/utils/network_request.dart';

class AddEventNewName extends StatefulWidget {
  final void Function(Map addedEventName,String addTo) onEventNameAdded;
  const AddEventNewName(
    {
      required this.onEventNameAdded,
      super.key
    }
  );

  @override
  State<AddEventNewName> createState() => _AddEventNewNameState();
}

class _AddEventNewNameState extends State<AddEventNewName> {
  final TextEditingController name = TextEditingController();
  final TextEditingController price = TextEditingController(text: "0.0");

  
  List<FocusNode> focusNodes = List.generate(3, (_) => FocusNode());

  final TextEditingController isForDD = TextEditingController();

  bool isEventLoading = false;
  
  int? selectedDdValues; // Flag for loading state

  // Function to handle API request
  Future<void> addEventName(BuildContext context) async {
    printToConsole("///////////////////////////////////hii $selectedDdValues");
    setState(() {
      isEventLoading = true; // Set loading to true to show loader and disable button
    });
    String path="/event/name";
    Map body={};
    try{
      body={
            "event_name": name.text,
            "event_amount": price.text.isNotEmpty ? double.parse(price.text) : 0.0,
            "is_special":false
      };
      
      if (selectedDdValues==1){
        body["is_special"]=true;
      }
      else if (selectedDdValues==2){
        path="/neivethiyam/name";
        body={
          "neivethiyam_name": name.text,
          "neivethiyam_amount": price.text.isNotEmpty ? double.parse(price.text) : 0.0
        };
      }
    }
    catch(e){
      customSnackBar(content: "Enter a valid amount", contentType: AnimatedSnackBarType.error).show(context);
    }
    
    try {
      final res = await NetworkService.sendRequest(
        path: path,
        context: context,
        method: "POST",
        body: body
      );

      if (res!=null) {
        final String addTo=(selectedDdValues==2) ?"neivethiyam" : (selectedDdValues==1) ? "special" : "normal";
        widget.onEventNameAdded({'name':name.text,'amount': price.text.isNotEmpty ? double.parse(price.text) : 0,'id':1},addTo);
        // Navigator.pop(context);
      } 
    } catch (e) {
      printToConsole("rfuyghliuhihiu  uguyguyguk $e");
      customSnackBar(content: "something went wrong", contentType: AnimatedSnackBarType.error).show(context);
    } finally {
      setState(() {
        isEventLoading = false; // Reset loading state after request is completed
      });
    }
  }

  

  @override
  Widget build(BuildContext context) {
    final List<Map> ddValues=[
      {"label":"Normal Event","value":0},
      {"label":"Special Event","value":1},
      {"label":"Neivethiyam","value":2}
    ];

    return PopScope(
      canPop: isEventLoading? false : true,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop){
          customSnackBar(content: "Wait until request complete...", contentType: AnimatedSnackBarType.info).show(context);
        }
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 500),
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.white10,
                      Colors.white24,
                      Colors.white54
                    ]),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.shade500,
                        blurRadius: 5,
                        spreadRadius: 2,
                        blurStyle: BlurStyle.outer
                      )
                    ]
                  ),
                child: Column(
                  children: [
                    CustomTextField(
                      label: "Name", 
                      controller: name,
                      focusNode: focusNodes[0],
                      onSubmitted: (_){
                        FocusScope.of(context).requestFocus(focusNodes[1]);
                      },
                    ),
                    const SizedBox(height: 30),
                    CustomTextField(
                      label: "Price",
                      controller: price,
                      keyboardtype: TextInputType.number,
                      focusNode: focusNodes[1],
                      onSubmitted: (_){
                        FocusScope.of(context).requestFocus(focusNodes[2]);
                      },
                    ),
                    const SizedBox(height: 30),
                    CustomDropdown(
                      label: "Is for", 
                      ddController: isForDD,
                      focusNode: focusNodes[2],
                      ddEntries: ddValues.map((item){
                        return DropdownMenuEntry(value: item['value'], label: item['label']);
                      }).toList(), 
                      onSelected: (value){
                        setState(() {
                          selectedDdValues=value;
                        });
                      }
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isEventLoading
                                ? null // Disable the button when loading
                                : () => addEventName(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                            ),
                            child: isEventLoading
                                ? SizedBox(width: 18,height: 18,child: CircularProgressIndicator(color: Colors.orange)) // Show loader inside the button
                                : Text("Add", style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
