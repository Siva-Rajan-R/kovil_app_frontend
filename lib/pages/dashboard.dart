
import 'dart:convert';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:sampleflutter/custom_controls/cust_bottom_appbar.dart';
import 'package:sampleflutter/custom_controls/cust_snacbar.dart';
import 'package:sampleflutter/custom_controls/cust_textfield.dart';
import 'package:sampleflutter/custom_controls/custom_appbar.dart';
import 'package:sampleflutter/utils/network_request.dart';



class DashboardPage extends StatefulWidget {
  const DashboardPage(
    {
      super.key
    }
  );

  @override
  State<DashboardPage> createState()=>_DashboardState();
}

class _DashboardState extends State<DashboardPage>{
  TextEditingController amountToCalculate = TextEditingController(text: "50");
  DateTime? fromDate;
  DateTime? toDate;
  bool _isDeleting=false;
  bool _isSubmitting=false;
  bool _isCalculating=false;
  bool _isFullLoading=true;

  List<Map<String, dynamic>> workersData = [];

  @override
  void initState(){
    super.initState();
    getWorkersInfo();
  }

  Future getWorkersInfo()async{
    
    final res=await NetworkService.sendRequest(path: "/workers", context: context);
    setState(() {
      _isFullLoading=false;
    });
    print(res.body);
    final decodedRes=json.decode(utf8.decode(res.bodyBytes));
    
    if (res.statusCode==200){
      setState(() {
        workersData=List.from(decodedRes['workers']);
      });
      
    }
    else{
      customSnackBar(content: decodedRes['detail'], contentType: AnimatedSnackBarType.error).show(context);
    }
  }

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

  
    final res=await NetworkService.sendRequest(path: '/event/report/email',method: "POST", context: context);
    final decodedRes=jsonDecode(utf8.decode(res.bodyBytes));
    setState(() {
      _isSubmitting=false;
    });
    print(decodedRes);
    if(res.statusCode==200){
      customSnackBar(content: decodedRes, contentType: AnimatedSnackBarType.success).show(context);
    }
    else if(res.statusCode==422){
      customSnackBar(content: "invalid Inputs", contentType: AnimatedSnackBarType.info).show(context);
    }
    else{
      customSnackBar(content: decodedRes['detail'], contentType: AnimatedSnackBarType.error).show(context);
    }
  }

  void handleDelete()async {
    AwesomeDialog(
        context: context,
        btnOkText: "Yes",
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
        dialogType: DialogType.info,
        animType: AnimType.topSlide,
        title: 'Reset Participated Events',
        desc: 'Are you sure , Do you Want to Reset Participated Events ?',
        btnCancelOnPress: () {},
        btnOkOnPress: () async {
          setState(() {
            _isDeleting=true;
          });
          final res=await NetworkService.sendRequest(path: '/worker/reset/all',method: "PUT", context: context,body: {"from_date":fromDate.toString(),"to_date":toDate.toString(),"amount":int.parse(amountToCalculate.text)});
          final decodedRes=jsonDecode(utf8.decode(res.bodyBytes));
          print(decodedRes);
          setState(() {
            _isDeleting=false;
          });
          if(res.statusCode==200){
            customSnackBar(content: decodedRes, contentType: AnimatedSnackBarType.success).show(context);
          }
          else if(res.statusCode==422){
            customSnackBar(content: "invalid Inputs", contentType: AnimatedSnackBarType.info).show(context);
          }
          else{
            customSnackBar(content: decodedRes['detail'], contentType: AnimatedSnackBarType.error).show(context);
          }
       }
      ).show();
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: KovilAppBar(height: 100,),
      bottomNavigationBar: _isFullLoading? null 
      : CustomBottomAppbar(
        bottomAppbarChild: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: _isDeleting ? null : handleDelete,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                
              ),
              child: Text(
                _isDeleting ? "Reseting..." : "Reset",
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
      body: _isFullLoading? Center(child: CircularProgressIndicator(color: Colors.orange,),)
      : SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
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
                  color: Colors.orange,
                  fontWeight: FontWeight.w600
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
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
            
            SizedBox(height: 10,),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.99,
                height: 440,
                child: Card(
                  color: Colors.grey.shade100,
                  elevation: 4,
                  margin: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Participants Data',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Divider(),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              headingRowColor: MaterialStateColor.resolveWith((states) => Colors.blueGrey.shade300),
                              dataRowColor: MaterialStateColor.resolveWith((states) => Colors.grey.shade100),
                              columnSpacing: 24,
                              columns: const [
                                DataColumn(
                                  label: Center(
                                    child: Text(
                                      'Name',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Center(
                                    child: Text(
                                      'Events Participated',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Center(
                                    child: Text(
                                      'Total Amount (₹)',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                  ),
                                ),
                              ],
                              rows: workersData.map((item) {
                                print(item);
                                int amount = item['no_of_participated_events'] * int.parse(amountToCalculate.text);
                                return DataRow(
                                  cells: [
                                    DataCell(Center(child: Text(item['name'], style: const TextStyle(fontSize: 14)))),
                                    DataCell(Center(child: Text(item['no_of_participated_events'].toString(), style: const TextStyle(fontSize: 14)))),
                                    DataCell(Center(child: Text(amount.toString(), style: const TextStyle(fontSize: 14)))),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: CustomTextField(label: "Enter a amount",controller: amountToCalculate,)),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: (){
                      if (amountToCalculate.text.isNotEmpty && int.tryParse(amountToCalculate.text)!=null){
                        setState(() {
                          _isCalculating=true;
                        });
                        int amount=int.parse(amountToCalculate.text);
                        setState(() {
                          amountToCalculate.text=amount.toString();
                          _isCalculating=false;
                        });       
                      }
                      else{
              
                        customSnackBar(content: "Enter a valid number", contentType: AnimatedSnackBarType.info).show(context);
                      }
                    },
                    child: Text(
                      _isCalculating
                          ? "Calculating..."
                          : "Calculate",
                    ),
                  ),
                ],
              ),
            ),
            
          ],
        ),
      )
    );
  }
}