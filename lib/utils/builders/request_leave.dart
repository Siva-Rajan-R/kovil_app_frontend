
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:sampleflutter/custom_controls/cust_snacbar.dart';
import 'package:sampleflutter/utils/network_request.dart';

class RequestLeaveAdd extends StatefulWidget {
  final void Function(Map addedLeave) onLeaveAdded;
  const RequestLeaveAdd(
    {
      required this.onLeaveAdded,
      super.key
    }
  );

  @override
  _RequestLeaveAddState createState() => _RequestLeaveAddState();
}

class _RequestLeaveAddState extends State<RequestLeaveAdd> {
  final TextEditingController leaveReason = TextEditingController();
  DateTime? fromDate;
  DateTime? toDate;
  bool isLoading=false;

  Future addLeave()async {
    setState(() {
      isLoading=true;
    });
    final res=await NetworkService.sendRequest(
      path: '/user/leave',
      method: 'POST', 
      body: {
        'reason':leaveReason.text.trim(),
        'from_date':fromDate.toString(),
        'to_date':toDate.toString()
      },
      context: context
    );

    if (res!=null){
      // Navigator.pop(context);
      final Map addedLeave={
        'datetime':DateTime.now().toUtc().toString(),
        'status':'waiting',
        'from_date':fromDate,
        'to_date':toDate,
        'reason':leaveReason.text.trim(),
        'name':''
      };
      widget.onLeaveAdded(addedLeave);
    }

    setState(() {
      isLoading=false;
    });
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
  

  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop: isLoading? false : true,
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
                margin: EdgeInsets.all(15),
                  padding: EdgeInsets.all(10),
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
                                ? "Pick From Date"
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
                                ? "Pick To Date"
                                : "${toDate!.toLocal()}".split(' ')[0],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    TextField(
                      controller: leaveReason,
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w600),
                      cursorColor: Colors.orange,
                      minLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Write a reason for leave...',
                        hintStyle: const TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w500),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black38),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange),
                        ),
                        alignLabelWithHint: true,
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: isLoading
                          ? null // Disable the button when loading
                          : () => addLeave(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      child: isLoading
                          ? SizedBox(width: 18,height: 18,child: CircularProgressIndicator(color: Colors.orange)) // Show loader inside the button
                          : Text("Request Leave", style: TextStyle(color: Colors.white)),
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
