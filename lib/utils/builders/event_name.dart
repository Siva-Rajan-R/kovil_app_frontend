
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sampleflutter/custom_controls/cust_snacbar.dart';
import 'package:sampleflutter/custom_controls/cust_textfield.dart';
import 'package:sampleflutter/custom_controls/custom_dropdown.dart';
import 'package:sampleflutter/pages/home.dart';
import 'package:sampleflutter/utils/network_request.dart';

class AddEventNewName extends StatefulWidget {
  const AddEventNewName({super.key});

  @override
  _AddEventNewNameState createState() => _AddEventNewNameState();
}

class _AddEventNewNameState extends State<AddEventNewName> {
  final TextEditingController name = TextEditingController();
  final TextEditingController price = TextEditingController(text: "0");

  final TextEditingController isForDD = TextEditingController();

  bool isEventLoading = false;
  
  int? selectedDdValues; // Flag for loading state

  // Function to handle API request
  Future<void> addEventName(BuildContext context) async {
    print("///////////////////////////////////hii $selectedDdValues");
    setState(() {
      isEventLoading = true; // Set loading to true to show loader and disable button
    });
    String path="/event/name";
    Map body={
          "event_name": name.text,
          "event_amount": price.text.isNotEmpty ? int.parse(price.text) : 0,
          "is_special":false
    };
    
    if (selectedDdValues==1){
      body["is_special"]=true;
    }
    else if (selectedDdValues==2){
      path="/neivethiyam/name";
      body={
        "neivethiyam_name": name.text,
        "neivethiyam_amount": price.text.isNotEmpty ? int.parse(price.text) : 0
      };
    }

    
    try {
      final res = await NetworkService.sendRequest(
        path: path,
        context: context,
        method: "POST",
        body: body
      );

      if (res!=null) {
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (context) => HomePage()),
          (route) => false,
        );
      } 
    } catch (e) {
      print("rfuyghliuhihiu  uguyguyguk $e");
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
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
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
                  CustomTextField(label: "Name", controller: name),
                  const SizedBox(height: 30),
                  CustomTextField(
                    label: "Price",
                    controller: price,
                    keyboardtype: TextInputType.number,
                  ),
                  const SizedBox(height: 30),
                  CustomDropdown(
                    label: "Is for", 
                    ddController: isForDD, 
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
                  ElevatedButton(
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
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
