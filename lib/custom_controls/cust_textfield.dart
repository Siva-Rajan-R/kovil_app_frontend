import "package:flutter/material.dart";


class CustomTextField extends StatelessWidget{
  final String label;
  final TextEditingController? controller;
  final TextInputType? keyboardtype;


  const CustomTextField({
    super.key,
    required this.label,
    this.controller,
    this.keyboardtype
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
          controller: controller,
          cursorColor: Colors.orange,
          keyboardType: keyboardtype,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14
          ),
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            labelText: label,
            labelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13
            ),
            focusColor: Colors.orange,
            fillColor: Colors.orange,
            hoverColor: Colors.orange,
            floatingLabelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),
            
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.orange)
              
            )
          ),
        );
  }
}