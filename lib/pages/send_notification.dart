import 'dart:io';
import 'package:sampleflutter/utils/custom_print.dart';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sampleflutter/custom_controls/cust_bottom_appbar.dart';
import 'package:sampleflutter/custom_controls/cust_snacbar.dart';
import 'package:sampleflutter/custom_controls/cust_textfield.dart';
import 'package:sampleflutter/custom_controls/custom_appbar.dart';
import 'package:sampleflutter/notification_components/local_notfiy_init.dart';
import 'package:sampleflutter/utils/compress_image.dart';
import 'package:sampleflutter/utils/global_variables.dart';
import 'package:sampleflutter/utils/network_request.dart';


class SendNotificationPage extends StatefulWidget{
  const SendNotificationPage({super.key});

  @override
  State<SendNotificationPage> createState() => _SendNotificationPageState();

} 


class _SendNotificationPageState extends State<SendNotificationPage>{
  TextEditingController notifyTitle=TextEditingController();
  TextEditingController notifyBody=TextEditingController();
  List<FocusNode> focusNodes = List.generate(2, (_) => FocusNode());
  
  double? uploadingCurrentStatus;
  bool _isSending=false;
  bool _isCompressing=false;

  File? _selectedImage;
  String? _selectedImagePath;


  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery); // or camera

    if (pickedFile != null) {
      if(_selectedImage!=null){
          final imageProvider = FileImage(_selectedImage!);
          imageCache.evict(imageProvider);
        }
      setState((){
        _isCompressing=true;
      });

      File compressedFile=File(pickedFile.path);
      if (await pickedFile.length()>=300*1024){
        compressedFile=await compressImageToTargetSize(File(pickedFile.path), 250*1024,returnAsFile: true);
      }
      setState(() {
        _isCompressing=false;
        _selectedImage = compressedFile;
        _selectedImagePath = compressedFile.path; // saving path
      });
      printToConsole('Selected image path: $_selectedImagePath');
    }
  }

  Future<void> handleSending() async {
    setState(() {
      _isSending=true;
    });
    final res=await NetworkService.sendRequest(
      path: "/app/notify/all", 
      context: context,
      method: "POST",
      isJson: false,
      isMultipart: true,
      body: {
        "notification_title":notifyTitle.text,
        "notification_body":notifyBody.text
      },
      imageFile: _selectedImage,
      nameOfImageField: "notification_image",
      onUploadProgress: (value){
        printToConsole("value : $value");
        setState(() {
          double? custValue=value;
          if (uploadingCurrentStatus!=null && custValue==1){
            custValue=null;
            printToConsole("hrllo");
          }
          uploadingCurrentStatus=custValue;
        });
      }
    );
    
    setState(() {
      _isSending=false;
    });

    if (res!=null) {
      if(_selectedImage!=null){
        await  _selectedImage!.delete();
      }

      if (Platform.isWindows || Platform.isMacOS){
        await showForegroundImageNotification(notifyTitle.text, notifyBody.text, null);
      }
      
      setState(() {
          _selectedImage=null;
      });
      // Navigator.pushAndRemoveUntil(
      //   context,
      //   CupertinoPageRoute(builder: (_) => HomePage()),
      //   (_) => false,
      // );
      // if (MediaQuery.of(context).size.width<=400){
      //   Navigator.pop(context);
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: (_isCompressing || _isSending)? false : true,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop){
          customSnackBar(content: "Wait until request complete...", contentType: AnimatedSnackBarType.info).show(context);
        }
      },
      child: Scaffold(
        appBar: MediaQuery.of(context).size.width>phoneSize? null : KovilAppBar(withIcon: true,),
        bottomNavigationBar: CustomBottomAppbar(
          bottomAppbarChild: Center(
            child: SizedBox(
              width: 500,
              child: ElevatedButton(
                  onPressed: _isSending ? null : handleSending,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    
                  ),
                  child: (_isSending==true && _selectedImage!=null) ? LinearProgressIndicator(
                      value: uploadingCurrentStatus,
                      minHeight: 8,
                      
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    )
                  : Text(
                    _isSending ? "Sending..." : "Send",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
            ),
          ),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500),
            child: Container(
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
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Text(
                      "Send Notification To All",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 20
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30,),
                  
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: DottedBorder(
                            color: Colors.white,
                            child: Container(
                              width: 200,
                              height: 200,
                              alignment: Alignment.center,
                              child: _selectedImage == null
                                  ? const Text("Select Photo\n(Optional)",textAlign: TextAlign.center,style: TextStyle(color: Colors.white),)
                                  : _isCompressing? CircularProgressIndicator(color: Colors.white,) 
                                  : Image.file(
                                      _selectedImage!,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: CustomTextField(
                        label: "Notification title",
                        controller: notifyTitle,
                        themeColor: Colors.white,
                        fontColor: Colors.white,
                        focusNode: focusNodes[0],
                        onSubmitted: (_){
                          FocusScope.of(context).requestFocus(focusNodes[1]);
                        },
                      ),
                    ),
                    SizedBox(height: 10,),
                    
                    SizedBox(height: 10,),
                    TextField(
                        controller: notifyBody,
                        style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                        cursorColor: Colors.white,
                        focusNode: focusNodes[1],
                        minLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Notification body...',
                          hintStyle: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w500),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          alignLabelWithHint: true,
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: 4,
                        onSubmitted:  _isSending ? null : (_)=> handleSending,
                    ),
                    
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}