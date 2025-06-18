import 'dart:io';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sampleflutter/custom_controls/cust_bottom_appbar.dart';
import 'package:sampleflutter/custom_controls/cust_snacbar.dart';
import 'package:sampleflutter/custom_controls/cust_textfield.dart';
import 'package:sampleflutter/custom_controls/custom_appbar.dart';
import 'package:sampleflutter/custom_controls/custom_dropdown.dart';
import 'package:sampleflutter/utils/compress_image.dart';
import 'package:sampleflutter/utils/network_request.dart';

class StatusUpdatePage extends StatefulWidget {
  final String eventStatus;
  final String eventId;
  final Map? existingEventDetails;
  const StatusUpdatePage({required this.eventStatus,required this.eventId, this.existingEventDetails, super.key});

  @override
  State<StatusUpdatePage> createState() => _StatusUpdatePageState();
}

class _StatusUpdatePageState extends State<StatusUpdatePage> {

  bool _isSubmitting = false;

  bool _isCompressing=false;

  bool isLoading=false;

  double? uploadingCurrentStatus;

  File? _selectedImage;
  String? _selectedImagePath;
  late TextEditingController feedback;
  late TextEditingController archagar;
  late TextEditingController abisegam ;
  late TextEditingController helper;
  late TextEditingController poo;
  late TextEditingController read;
  late TextEditingController prepare;
  late TextEditingController statusDesc;


  List<Map> workersName=[];

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
      if (await pickedFile.length()>5*1024*1024){
        compressedFile=await compressImageToTargetSize(File(pickedFile.path), 15*1024*1024,returnAsFile: true);
      }
      
      setState(() {
        _isCompressing=false;
        _selectedImage = compressedFile;
        
        _selectedImagePath = compressedFile.path; // saving path
      });
      print('Selected image path: $_selectedImagePath');
    }
  }

  void handleSubmit() async {
    setState(() => _isSubmitting = true);

    Map body = {
      "event_id": widget.eventId,
      "event_status": widget.eventStatus,
      "feedback": feedback.text,
      "archagar": archagar.text,
      "abisegam": abisegam.text,
      "helper": helper.text,
      "poo": poo.text,
      "read": read.text,
      "prepare": prepare.text,
    };

    bool isJson=false;
    String path="/event/status/completed";
    File? imageFile=_selectedImage;
    bool isMultipart= true;
    String nameOfImageField="image";

    if (widget.eventStatus.toLowerCase() == "pending" || widget.eventStatus.toLowerCase() == "canceled"){
      body={
        "event_id":widget.eventId,
        "event_status": widget.eventStatus,
        "status_description": statusDesc.text.trim()
      };
      isJson=true;
      path="/event/status/pending-canceled";
      imageFile=null;
      isMultipart= false;
      nameOfImageField="";
    }

    print(body);
    final res = await NetworkService.sendRequest(
      path: path,
      context: context,
      method: "PUT",
      isJson: isJson,
      isMultipart: isMultipart,
      imageFile: imageFile,
      body: body,
      nameOfImageField: nameOfImageField,
      onUploadProgress: (progress){
        setState(() {
          double? custValue=progress;
          if (uploadingCurrentStatus!=null && progress==1){
            custValue=null;
          }
          uploadingCurrentStatus=custValue;
        });
      }
    );
    setState(() => _isSubmitting = false);
    print(res);
    
    if (res!=null) {
      if(_selectedImage!=null){
        await  _selectedImage!.delete();
      }
      Navigator.popUntil(context, (route) => route.isFirst);
    } 

    
  }

  void getWorkersName()async {
    setState(() {
      isLoading=true;
    });
    final res=await NetworkService.sendRequest(path: "/workers", context: context);

    setState(() {
      isLoading=false;
    });
    print("qwertyuiopasdfghjk $res");
    if (res!=null){
      workersName=List.from(res['workers']);
    }

  }

  @override
  void dispose() {
    abisegam.dispose();
    helper.dispose();
    poo.dispose();
    read.dispose();
    prepare.dispose();
    feedback.dispose();
    archagar.dispose();
    statusDesc.dispose();
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
    if (widget.eventStatus.toLowerCase()=="completed"){
      getWorkersName();
    }

    final existsDetails=widget.existingEventDetails;
    String efeedback="";
    String earchagar="";
    String eabisegam="";
    String ehelper="";
    String epoo="";
    String eread="";
    String eprepare="";
    String stsdesc="";

    if (existsDetails!=null){

      print("existsss $existsDetails");
      efeedback=existsDetails['feedback'] ?? "";
      earchagar=existsDetails['archagar'] ?? "";
      eabisegam=existsDetails['abisegam'] ?? "";
      ehelper=existsDetails['helper'] ?? "";
      epoo=existsDetails['poo'] ?? "";
      eread=existsDetails['read'] ?? "";
      eprepare=existsDetails['prepare'] ?? "";
      stsdesc=existsDetails['event_pending_canceled_description'] ?? "";
    }
    feedback=TextEditingController(text: efeedback);
    archagar=TextEditingController(text: earchagar);
    abisegam = TextEditingController(text: eabisegam);
    helper = TextEditingController(text: ehelper);
    poo = TextEditingController(text: epoo);
    read = TextEditingController(text: eread);
    prepare = TextEditingController(text: eprepare);
    statusDesc=TextEditingController(text: stsdesc);
  }

  @override
  Widget build(BuildContext context) {
    print('Event status: ${widget.eventStatus}');
    bool canPickImage = !(widget.eventStatus.toLowerCase() == "pending" || widget.eventStatus.toLowerCase() == "canceled");
    print("workers name is the worls------------$workersName");

    final List<Map> ddLabels=[
      {"label":"ஸ்தல அர்ச்சகர்","controller":archagar},
      {"label":"அபிஷேகம்","controller":abisegam},
      {"label":"அபிஷேகம் உதவி","controller":helper},
      {"label":"பூ அர்ச்சனை","controller":poo},
      {"label":"நாமா வழி சொல்பவர்","controller":read},
      {"label":"பொருட்கள் சேகரித்தவர்","controller":prepare}
    ];
    return isLoading? Scaffold(
      appBar: const KovilAppBar(withIcon: true),
      body: Center(child: CircularProgressIndicator(color: Colors.orange,),) ,
    )
    : PopScope(
      canPop: (_isCompressing || _isSubmitting)? false : true,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop){
          customSnackBar(content: "Wait until request complete...", contentType: AnimatedSnackBarType.info).show(context);
        }
      },
      child: Scaffold(
        bottomNavigationBar: CustomBottomAppbar(
          bottomAppbarChild: Center(
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                
              ),
              child:(_isSubmitting==true && widget.eventStatus.toLowerCase() == "completed")? LinearProgressIndicator(
                  value: uploadingCurrentStatus,
                  minHeight: 6,
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                  color: Colors.white,
                )
              : Text(
                 _isSubmitting? " Submitting..." :" Submit",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      
        appBar: const KovilAppBar(withIcon: true),
        body: (widget.eventStatus.toLowerCase() == "pending" || widget.eventStatus.toLowerCase() == "canceled")? 
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: statusDesc,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w600),
            cursorColor: Colors.orange,
            minLines: 5,
            decoration: InputDecoration(
              hintText: 'Write a reason for ${widget.eventStatus}...',
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
            maxLines: 6,
          ),
        )
        : SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (canPickImage)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: DottedBorder(
                          color: Colors.orange,
                          child: Container(
                            width: 200,
                            height: 200,
                            alignment: Alignment.center,
                            child: _selectedImage == null
                                ? const Text("Select Photo\n(Optional)",textAlign: TextAlign.center,style: TextStyle(color: Colors.black),)
                                : _isCompressing? CircularProgressIndicator(color: Colors.orange,) 
                                : Image.file(
                                    _selectedImage!,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(10),
                child: CustomTextField(label:"நிகழ்வு கருத்து",controller:feedback,),
              ),
      
              for (int i = 0; i < ddLabels.length; i++) 
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: CustomDropdown(
                      Width: 400,
                      label: ddLabels[i]['label'],
                      ddController: ddLabels[i]['controller'],
                      ddEntries: [
                        for (int j = 0; j < workersName.length; j++)
                          DropdownMenuEntry(
                            value: workersName[j]['name'],
                            label: workersName[j]['name'],
                          )
                      ],
                      onSelected: (value) {
                        print("Selected worker ID: $value");
                      },
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
