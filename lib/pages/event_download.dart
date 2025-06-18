
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:sampleflutter/custom_controls/cust_bottom_appbar.dart';
import 'package:sampleflutter/custom_controls/cust_snacbar.dart';
import 'package:sampleflutter/custom_controls/cust_textfield.dart';
import 'package:sampleflutter/custom_controls/custom_appbar.dart';
import 'package:sampleflutter/custom_controls/custom_dropdown.dart';
import 'package:sampleflutter/utils/network_request.dart';

class EventDownloadPage extends StatefulWidget{

  const EventDownloadPage(
    {
      super.key
    }
  );

  @override
  State<EventDownloadPage> createState()=>_EventDownloadPage();
}

class _EventDownloadPage extends State<EventDownloadPage>{
  bool _isSubmitting = false;
  bool _isDeleting=false;
  DateTime? fromDate;
  DateTime? toDate;
  TextEditingController eventReportFormat=TextEditingController();
  TextEditingController forwardTo=TextEditingController();

  Future<void> pickFromDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.parse("2025-01-01"),
      lastDate: DateTime(DateTime.now().year, 12, 31),
    );
    if (picked != null) {
      setState(() {
        fromDate = picked;
      });
    }
  }

  Future<void> pickToDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.parse("2025-01-01"),
      lastDate: DateTime(DateTime.now().year, 12, 31),
    );
    if (picked != null) {
      setState(() {
        toDate = picked;
      });
    }
  }

  handleDownload() async {
    setState(() {
      _isSubmitting=true;
    });

    print("$fromDate $toDate $eventReportFormat");
    Map body={"from_date":fromDate.toString(),"to_date":toDate.toString(),"file_type":eventReportFormat.text};
    if(forwardTo.text.isNotEmpty){
      body['send_to']=forwardTo.text;
    }

    print(body);
    final res=await NetworkService.sendRequest(path: '/event/report/email',method: "POST", context: context,body:body);
    setState(() {
      _isSubmitting=false;
    });
    print(res);
    
  }

  void handleDelete()async {
    AwesomeDialog(
        context: context,
        btnOkText: "Yes",
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
        dialogType: DialogType.info,
        animType: AnimType.topSlide,
        title: 'Delete All Events',
        desc: 'Are you sure , Do you Want to Delete $fromDate to $toDate Events ?',
        btnCancelOnPress: () {},
        btnOkOnPress: () async {
          setState(() {
            _isDeleting=true;
          });
          final res=await NetworkService.sendRequest(path: '/event/all',method: "DELETE", context: context,body: {"from_date":fromDate.toString(),"to_date":toDate.toString()});
          print(res);
          setState(() {
            _isDeleting=false;
          });
  
       }
      ).show();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: (_isDeleting || _isSubmitting)? false : true,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop){
          customSnackBar(content: "Wait until request complete...", contentType: AnimatedSnackBarType.info).show(context);
        }
      },
      child: Scaffold(
        appBar: KovilAppBar(
          withIcon: true,
        ),
        bottomNavigationBar: CustomBottomAppbar(
          bottomAppbarChild: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _isDeleting ? null : handleDelete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  
                ),
                child: Text(
                  _isDeleting ? "Deleting..." : "Delete All",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: _isSubmitting ? null :handleDownload,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  
                ),
                child: Text(
                  _isSubmitting ? "Downloading..." : "Download",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        body: Container(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () => pickFromDate(context),
                      child: Text(
                        fromDate == null
                            ? "Pick Start Date"
                            : "${fromDate!.toLocal()}".split(' ')[0],
                      ),
                    ),
                    Text(
                      "To",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () => pickToDate(context),
                      child: Text(
                        toDate == null
                            ? "Pick End Date"
                            : "${toDate!.toLocal()}".split(' ')[0],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30,),
      
                CustomDropdown(
                  textColor: Colors.white,
                  themeColor: Colors.white,
                  label: "Event Report Format", 
                  ddController: eventReportFormat, 
                  ddEntries: [
                    for(String i in ["pdf","excel"])
                      DropdownMenuEntry(
                        value: i, 
                        label: i,
                      )
                  ], 
                  onSelected: (value)=>print(value)
                ),
                
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: CustomTextField(label: "Forward To (Optional)",controller: forwardTo,themeColor: Colors.white,fontColor: Colors.white,),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}