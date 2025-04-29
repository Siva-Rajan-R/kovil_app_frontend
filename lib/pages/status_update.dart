import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sampleflutter/custom_controls/cust_bottom_appbar.dart';
import 'package:sampleflutter/custom_controls/cust_textfield.dart';
import 'package:sampleflutter/custom_controls/custom_appbar.dart';
import 'package:sampleflutter/pages/status_update_next.dart';

class StatusUpdatePage extends StatefulWidget {
  final String eventStatus;
  final String eventId;
  const StatusUpdatePage({required this.eventStatus,required this.eventId, super.key});

  @override
  State<StatusUpdatePage> createState() => _StatusUpdatePageState();
}

class _StatusUpdatePageState extends State<StatusUpdatePage> {
  File? _selectedImage;
  String? _selectedImagePath;
  final TextEditingController feedback=TextEditingController();
  final TextEditingController tips=TextEditingController();
  final TextEditingController poojai=TextEditingController();
  

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery); // or camera

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _selectedImagePath = pickedFile.path; // saving path
      });
      print('Selected image path: $_selectedImagePath');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Event status: ${widget.eventStatus}');
    bool canPickImage = !(widget.eventStatus.toLowerCase() == "pending" || widget.eventStatus.toLowerCase() == "canceled");
    
    return Scaffold(
      bottomNavigationBar: CustomBottomAppbar(
        bottomAppbarChild: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () { 
                Map data={
                  'imagePath':_selectedImagePath,
                  "imageFile":_selectedImage,
                  'feedback':feedback.text,
                  "tips":tips.text,
                  "poojai":poojai.text,
                  "eventId":widget.eventId,
                  "eventStatus":widget.eventStatus

                };
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => StatusUpdatePageNext(previousPageData: data,)));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: Row(
                children: [
                  const Text("Next", style: TextStyle(color: Colors.white)),
                  const SizedBox(width: 10),
                  const Icon(Icons.arrow_forward, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
      appBar: const KovilAppBar(withIcon: true),
      body: SingleChildScrollView(
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
                        child: Container(
                          width: 200,
                          height: 200,
                          alignment: Alignment.center,
                          child: _selectedImage == null
                              ? const Text("Select Photo")
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
              padding: EdgeInsets.all(10),
              child: CustomTextField(label: "Feedback",controller: feedback,),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(10),
              child: CustomTextField(label: "Tips",controller: tips,),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(10),
              child: CustomTextField(label: "Poojai",controller: poojai,),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
