import 'dart:ui';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sampleflutter/custom_controls/cust_snacbar.dart';

void clipboardDialog(BuildContext context,Map generatedLink)async{

  showDialog(
    context: context,
    builder: (context){
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2,sigmaY: 2),
        child: Dialog(
          insetPadding: EdgeInsets.all(20),
          child: Container(
            width: MediaQuery.of(context).size.width>480? 500 : null,
            height: 320,
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Guruvudhasan",
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.w600,
                    fontSize: 18
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(top: 20,left: 10,right: 10,bottom: 20),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange,
                              blurRadius: 3,
                              spreadRadius: 0,
                              blurStyle: BlurStyle.outer
                            ),
                          
                          ],
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: Text(
                          generatedLink['link'],
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14
                          ),
                        ),
                      ),
                    ),
                    
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(Colors.orange)
                            ),
                            onPressed: ()async { 
                              await Clipboard.setData(ClipboardData(text: generatedLink['clipboard_format']));
                              Navigator.pop(context);
                              customSnackBar(content: "Copied Successfully", contentType: AnimatedSnackBarType.success).show(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Copy link",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Icon(Icons.copy,color: Colors.white,)
                              ],
                            ),
                          
                          ),
                          Divider(height: 20,),
                          SizedBox(width: 250,child: Text("Share this link to the Client,*Which is valid for only ${generatedLink['exp_time']}",style: TextStyle(color: Colors.orange,fontWeight: FontWeight.w600),softWrap: true,textAlign: TextAlign.center,))
                        ],
                      ),
                    ),
                    
                  ],
                )
              ],
            ),
          ),
        ),
      );  
    },
  );
}