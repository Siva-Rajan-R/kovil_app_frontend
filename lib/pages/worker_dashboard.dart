
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:sampleflutter/custom_controls/cust_bottom_appbar.dart';
import 'package:sampleflutter/custom_controls/cust_snacbar.dart';
import 'package:sampleflutter/custom_controls/cust_textfield.dart';
import 'package:sampleflutter/custom_controls/custom_appbar.dart';
import 'package:sampleflutter/utils/network_request.dart';



class WorkerDashboardPage extends StatefulWidget {
  const WorkerDashboardPage(
    {
      super.key
    }
  );

  @override
  State<WorkerDashboardPage> createState()=>_DashboardState();
}

class _DashboardState extends State<WorkerDashboardPage>{
  TextEditingController amountToCalculate = TextEditingController(text: "50");
  TextEditingController sendTo = TextEditingController();
  DateTime? fromDate;
  DateTime? toDate;
  bool _isDeleting=false;
  bool _isSubmitting=false;
  bool _isCalculating=false;
  bool _isFullLoading=true;
  int totNofEvents=0;
  int amount=50;


  List<Map<String, dynamic>> workersData = [];

  @override
  void initState(){
    super.initState();
    getWorkersInfo();
  }

  @override
  void dispose(){
    super.dispose();
    sendTo.dispose();
    amountToCalculate.dispose();
  }

  Future getWorkersInfo()async{
    
    final res=await NetworkService.sendRequest(path: "/workers", context: context);
    setState(() {
      _isFullLoading=false;
    });
    print("//////////////// res $res");
    
    if (res!=null){
      setState(() {
        workersData=List.from(res['workers']);
        totNofEvents=res['total_events'];
      });
      
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

      await fetchWorkersByDate();
    }


  }

  handleDownload() async {

    AwesomeDialog(
        context: context,
        btnOkText: "Download",
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
        dialogType: DialogType.noHeader,
        animType: AnimType.topSlide,
        body: Column(
          children: [
            Text(
              "Download Participated Events",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 30,),
            CustomTextField(label: "Forward to (Optional)",controller: sendTo,)
          ],
        ),
        btnCancelOnPress: () {},
        btnOkOnPress: () async {
          setState(() {
            _isSubmitting=true;
          });

          Map body={"from_date":fromDate.toString(),"to_date":toDate.toString(),"amount":amount};
          if(sendTo.text.trim()!=""){
            body['send_to']=sendTo.text.trim();
          }
          print(body);
          final res=await NetworkService.sendRequest(path: '/worker/report/email',method: "POST", context: context,body: body);

          setState(() {
            _isSubmitting=false;
          });
          print(res);
       }
      ).show();
    

    
  }

  fetchWorkersByDate() async {
    setState(() {
      _isFullLoading=true;
    });

    final res=await NetworkService.sendRequest(path: "/workers/date?from_date=$fromDate&to_date=$toDate", context: context);

    setState(() {
      _isFullLoading=false;
      if (res!=null){
        workersData=List.from(res['workers'] ?? []) ;
        totNofEvents=res['total_events'];
    }
    });

  }

  void handleDelete() async {
    AwesomeDialog(
        context: context,
        btnOkText: "Yes",
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
        dialogType: DialogType.question,
        animType: AnimType.topSlide,
        body: Column(
          children: [
            Text(
              "Reset Participated Events",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 30,),
            CustomTextField(label: "Forward to (Optional)",controller: sendTo,)
          ],
        ),
        btnCancelOnPress: () {},
        btnOkOnPress: () async {
          setState(() {
            _isDeleting=true;
          });
          Map body={"from_date":fromDate.toString(),"to_date":toDate.toString(),"amount":amount};
          
          if (sendTo.text.trim()!=""){
            body["send_to"]=sendTo.text.trim();
          }

          final res=await NetworkService.sendRequest(path: '/worker/reset/all',method: "PUT", context: context,body: body);
          print(res);
          setState(() {
            _isDeleting=false;
          });
          
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
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Total No Of Events : $totNofEvents',
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
                              headingRowColor: WidgetStateColor.resolveWith((states) => Colors.blueGrey.shade300),
                              dataRowColor: WidgetStateColor.resolveWith((states) => Colors.grey.shade100),
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
                                int totAmount = item['no_of_participated_events'] * amount;
                                return DataRow(
                                  cells: [
                                    DataCell(Text(item['name'], style: const TextStyle(fontSize: 14))),
                                    DataCell(Center(child: Text(item['no_of_participated_events'].toString(), style: const TextStyle(fontSize: 14)))),
                                    DataCell(Center(child: Text(totAmount.toString(), style: const TextStyle(fontSize: 14)))),
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
                      print(amount);
                      if (amountToCalculate.text.isNotEmpty && int.tryParse(amountToCalculate.text)!=null){
                        setState(() {
                          _isCalculating=true;
                        });
                        
                        setState(() {
                          // amountToCalculate.text=amount.toString();
                          amount =int.parse(amountToCalculate.text);
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