import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sampleflutter/custom_controls/cust_bottom_appbar.dart';
import 'package:sampleflutter/custom_controls/cust_textfield.dart';
import 'package:sampleflutter/custom_controls/custom_appbar.dart';
import 'package:sampleflutter/pages/home.dart';
import 'package:sampleflutter/utils/compress_image.dart';
import 'package:sampleflutter/utils/network_request.dart';


class SendNotificationPage extends StatefulWidget{
  const SendNotificationPage({super.key});

  @override
  State<SendNotificationPage> createState() => _SendNotificationPageState();

} 


class _SendNotificationPageState extends State<SendNotificationPage>{
  TextEditingController notifyTitle=TextEditingController();
  TextEditingController notifyBody=TextEditingController();
  
  double uploadingCurrentStatus=0.0;
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
      File compressedFile=await compressImageToTargetSize(File(pickedFile.path), 5*1024,returnAsFile: true);
      setState(() {
        _isCompressing=false;
        _selectedImage = compressedFile;
        _selectedImagePath = compressedFile.path; // saving path
      });
      print('Selected image path: $_selectedImagePath');
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
        setState(() {
          uploadingCurrentStatus=value;
        });
      }
    );
    if(_selectedImage!=null){
     await  _selectedImage!.delete();
    }
    setState(() {
      _isSending=false;
    });

    if (res!=null) {
      Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(builder: (_) => HomePage()),
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: (_isCompressing || _isSending)? false : true,
      child: Scaffold(
        appBar: KovilAppBar(withIcon: true,),
        bottomNavigationBar: CustomBottomAppbar(
          bottomAppbarChild: Center(
            child: ElevatedButton(
              onPressed: _isSending ? null : handleSending,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                
              ),
              child: (_isSending==true && _selectedImage!=null) ? LinearProgressIndicator(
                  value: uploadingCurrentStatus,
                  minHeight: 10,
                  
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
                Text(
                  "Send Notificication To All",
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
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: CustomTextField(label: "Notification title",controller: notifyTitle,themeColor: Colors.white,fontColor: Colors.white,),
                ),
                SizedBox(height: 10,),
                
                SizedBox(height: 10,),
                TextField(
                    controller: notifyBody,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                    cursorColor: Colors.white,
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
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}