
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sampleflutter/custom_controls/cust_snacbar.dart';
import 'package:sampleflutter/utils/delete_local_storage.dart';
import 'package:sampleflutter/utils/global_variables.dart';
import 'package:sampleflutter/utils/network_request.dart';



class FeaturesContainer extends StatefulWidget{
  final String svgLink;
  final String label;
  final Color shadowColor;
  final Color containerColor;
  final Widget route;

  

  const FeaturesContainer(
    {
      super.key,
      required this.svgLink,
      required this.label,
      required this.shadowColor,
      required this.containerColor,
      required this.route
    }
  );

  @override
  State<FeaturesContainer> createState() => _FeaturesContainerState();
}

class _FeaturesContainerState extends State<FeaturesContainer> {

  bool isLoading=false;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: isLoading? false : true,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop){
          customSnackBar(content: "Wait until request complete...", contentType: AnimatedSnackBarType.info).show(context);
        }
      },
      child: Stack(
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () async{
                if (widget.label=='Logout'){
                  print("logout ulla");
                  AwesomeDialog(
                    context: context,
                    btnOkText: "Yes",
                    dismissOnTouchOutside: false,
                    dismissOnBackKeyPress: false,
                    dialogType: DialogType.question,
                    animType: AnimType.topSlide,
                    title: 'Log out',
                    desc: 'Are you sure , Do you Want to Logout ?',
                    btnCancelOnPress: () {},
                    btnOkOnPress: () async{
                      setState(() {
                        isLoading=true;
                      });
                      await NetworkService.sendRequest(
                        path: "/app/notify/token",
                        context: context,
                        method: "DELETE",
                        body: {
                          "device_id":deviceId
                        }
                      );
                      
                      await deleteStoredLocalStorageValues();
                    
                      setState(() {
                        isLoading=false;
                      });
                      
                      await Navigator.pushReplacementNamed(context, '/login');
          
                      
          
                    },
                
                  ).show();
          
                }
                else{
                  Navigator.push(context,CupertinoPageRoute(builder: (context)=>widget.route));
                }
                print("clicked container ${widget.label}");
              },
              child: Container(
                  width: 85,
                  height: 100,
                  
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.all(8.0),
              
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: widget.containerColor,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 3,
                        spreadRadius: 2,
                        blurStyle: BlurStyle.outer,
                        color: widget.shadowColor
                      )
                    ]
                  ),
              
                  child: Column(
                    children: [
              
                      SvgPicture.asset(
                        widget.svgLink,
                        width: 50,
                        height: 50,
                      ),
              
                      Expanded(
                        child: Text(
                          widget.label,
                          softWrap: true,
                          overflow: TextOverflow.visible,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 12
                          ),
                        )
                      )
              
                    ],
                  ),
                ),
            ),
          ),
      
          if(isLoading)
            Positioned.fill(child: Center(child: CircularProgressIndicator(color: Colors.black,),))
        ],
      ),
    );
  }
}