import "package:flutter/material.dart";


class CustomTextField extends StatelessWidget{
  final String label;
  final String? value;
  final TextEditingController? controller;
  final TextInputType? keyboardtype;
  final Color themeColor;
  final Color fontColor;
  final Function(String)? onChanged;


  const CustomTextField({
    super.key,
    required this.label,
    this.value,
    this.controller,
    this.keyboardtype,
    this.themeColor=Colors.orange,
    this.fontColor=Colors.black,
    this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
          controller: controller,
          cursorColor: themeColor,
          keyboardType: keyboardtype,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: fontColor,
            fontSize: 14
          ),
          
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            labelText: label,
            labelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              color: fontColor,
              fontSize: 13
            ),
            focusColor: themeColor,
            fillColor: themeColor,
            hoverColor: themeColor,
            floatingLabelStyle: TextStyle(color: fontColor,fontWeight: FontWeight.w600),
            
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: themeColor)
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: themeColor)
            )
          ),
        );
  }
}