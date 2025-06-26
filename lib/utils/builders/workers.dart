import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:sampleflutter/custom_controls/cust_snacbar.dart';
import 'package:sampleflutter/custom_controls/cust_textfield.dart';
import 'package:sampleflutter/custom_controls/custom_dropdown.dart';
import 'package:sampleflutter/utils/network_request.dart';

class AddWorkers extends StatefulWidget {
  final void Function(Map addedWorker) onAdd;
  final List availableusersList;
  const AddWorkers({required this.onAdd,required this.availableusersList,super.key});

  @override
  _AddWorkersState createState() => _AddWorkersState();
}

class _AddWorkersState extends State<AddWorkers> {
  final TextEditingController workerName = TextEditingController();
  final TextEditingController workerNumber = TextEditingController();
  final TextEditingController workerHaveAnApp=TextEditingController();

  
  List<FocusNode> focusNodes = List.generate(2, (_) => FocusNode());

  bool canUserListVisible=false;
  String? selectedUserId;
  bool canWorkerNameAddColumnVisible=false;

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
          "worker_mobile_number": workerNumber.text,
          "worker_user_id":selectedUserId
        },
      );

      setState(() {
        isLoading = false; // Reset loading state after request is completed
      });


      if (res!=null) {
        setState(() {
          widget.availableusersList.removeWhere((user)=>user['id']==selectedUserId);
          canUserListVisible=false;
          selectedUserId=null;
          canWorkerNameAddColumnVisible=false;
          workerHaveAnApp.text='';
        });
        
        widget.onAdd({'name':workerName.text,'mobile_number':workerNumber.text});
        // Navigator.pop(context);
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

                margin: EdgeInsets.all(10),
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
                      CustomDropdown(label: "Worker have an app ?", 
                      ddEntries:[
                        DropdownMenuEntry(value: true, label: "Yes"),
                        DropdownMenuEntry(value: false, label: "No")
                      ],
                      ddController: workerHaveAnApp,
                      onSelected: (value){
                        setState(() {
                          if (value==false){
                            workerName.text='';
                            workerNumber.text='';
                          }
                          canUserListVisible=value;
                          canWorkerNameAddColumnVisible=true;
                        });
                      }
                    ),
                    SizedBox(height: 20,),
                    Visibility(
                      visible: canUserListVisible,
                      child: CustomDropdown(
                        label: "Select the user", 
                        ddEntries:widget.availableusersList.isNotEmpty? widget.availableusersList.map((user){
                          return DropdownMenuEntry(value: user, label: "${user['name']}-${user['role']}");
                        }).toList() : [DropdownMenuEntry(value: null, label: "All the users are added")], 
                        onSelected: (value){
                          if (widget.availableusersList.isNotEmpty){
                            setState(() {
                              selectedUserId=value['id'];
                              workerName.text=value['name'];
                              workerNumber.text=value['mobile_number'];
                            });
                          }
                        }
                      )
                    ),
                    SizedBox(height: 20,),
                    Visibility(
                      visible: canWorkerNameAddColumnVisible,
                      child: Column(
                        children: [
                          CustomTextField(
                            label: "Worker name", 
                            controller: workerName,
                            focusNode: focusNodes[0],
                            onSubmitted: (_){
                              FocusScope.of(context).requestFocus(focusNodes[1]);
                            },
                          ),
                          const SizedBox(height: 30),
                          CustomTextField(
                            label: "Worker number",
                            controller: workerNumber,
                            keyboardtype: TextInputType.number,
                            focusNode: focusNodes[1],
                            onSubmitted: isLoading
                                ? null // Disable the button when loading
                                : (_) => addWorkerName(context),

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
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
