import 'dart:convert';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sampleflutter/custom_controls/cust_snacbar.dart';
import 'package:sampleflutter/custom_controls/cust_textfield.dart';
import 'package:sampleflutter/pages/home.dart';
import 'package:sampleflutter/utils/network_request.dart';

class AddWorkers extends StatefulWidget {
  const AddWorkers({super.key});

  @override
  _AddWorkersState createState() => _AddWorkersState();
}

class _AddWorkersState extends State<AddWorkers> {
  final TextEditingController workerName = TextEditingController();
  final TextEditingController workerNumber = TextEditingController();


  bool isLoading = false;// Flag for loading state

  // Function to handle API request
  Future<void> addWorkerName(BuildContext context) async {
    setState(() {
      isLoading = true; // Set loading to true to show loader and disable button
    });

    
      final res = await NetworkService.sendRequest(
        path: "/worker",
        context: context,
        method: "POST",
        body: {
          "worker_name": workerName.text,
          "worker_mobile_number": workerNumber.text
        },
      );

      setState(() {
        isLoading = false; // Reset loading state after request is completed
      });
      final decodedRes = jsonDecode(utf8.decode(res.bodyBytes));
      print(decodedRes);

      if (res.statusCode == 201) {
        customSnackBar(content: decodedRes, contentType: AnimatedSnackBarType.success).show(context);
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (context) => HomePage()),
          (route) => false,
        );
      } else if (res.statusCode == 422) {
        customSnackBar(content: "Input Fields Couldn't be Empty", contentType: AnimatedSnackBarType.info).show(context);
      } else {
        customSnackBar(content: decodedRes["detail"], contentType: AnimatedSnackBarType.error).show(context);
      }
    
      

  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                CustomTextField(label: "Worker name", controller: workerName),
                const SizedBox(height: 30),
                CustomTextField(
                  label: "Worker number",
                  controller: workerNumber,
                  keyboardtype: TextInputType.number,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: isLoading
                      ? null // Disable the button when loading
                      : () => addWorkerName(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: isLoading
                      ? SizedBox(width: 18,height: 18,child: CircularProgressIndicator(color: Colors.orange)) // Show loader inside the button
                      : Text("Add", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
          
        ],
      ),
    );
  }
}
