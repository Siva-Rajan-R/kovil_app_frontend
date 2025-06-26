import "package:flutter/material.dart";


class CustomTextField extends StatelessWidget{
  final String label;
  final String? hintText;
  final String? value;
  final TextEditingController? controller;
  final TextInputType? keyboardtype;
  final Color themeColor;
  final Color fontColor;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;


  const CustomTextField({
    super.key,
    required this.label,
    this.hintText,
    this.value,
    this.controller,
    this.keyboardtype,
    this.focusNode,
    this.themeColor=Colors.orange,
    this.fontColor=Colors.black,
    this.onChanged,
    this.onSubmitted

  });

  @override
  Widget build(BuildContext context) {
    return TextField(
          controller: controller,
          cursorColor: themeColor,
          focusNode: focusNode,
          keyboardType: keyboardtype,
          onSubmitted: onSubmitted,
          onChanged: onChanged,
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
            hintText: hintText,
            hintStyle: TextStyle(
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