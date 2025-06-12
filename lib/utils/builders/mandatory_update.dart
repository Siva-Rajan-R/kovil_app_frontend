import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sampleflutter/custom_controls/custom_appbar.dart';
import 'package:sampleflutter/utils/delete_local_storage.dart';
import 'package:sampleflutter/utils/open_phone.dart';

class ShowMandatoryUpdate extends StatefulWidget {
  final Map? triggerVersionDialogInfo;

  const ShowMandatoryUpdate(
    {
      super.key,
      this.triggerVersionDialogInfo
    }
  );

  @override
  State<ShowMandatoryUpdate> createState() => _ShowMandatoryUpdateState();
}

class _ShowMandatoryUpdateState extends State<ShowMandatoryUpdate> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KovilAppBar(withIcon: true,),
      backgroundColor: Colors.orange.shade50,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 36),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(
                    "assets/lotties/update.json", // Replace with your own animation
                    height: 180,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "New Version Available (${widget.triggerVersionDialogInfo!['currentVersion']})",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                      
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  
                  Text(
                    "You're using version-${widget.triggerVersionDialogInfo!['oldVersion']}.\nPlease update to current version which is mandatory*.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      print("pressed install");
                      if (widget.triggerVersionDialogInfo!['isTriggerLogin']){
                        await deleteStoredLocalStorageValues();
                      }
                      openUrl(widget.triggerVersionDialogInfo!["updateUrl"], context);
                    },
                    icon: Icon(Icons.system_update,color: Colors.white,),
                    label: Text("Update Now",style: TextStyle(color: Colors.white),),
                  ),
                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}