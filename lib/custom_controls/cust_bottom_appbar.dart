import 'package:flutter/material.dart';

class CustomBottomAppbar extends StatelessWidget{
  final Color color;
  final Widget bottomAppbarChild;
  final double height;

  CustomBottomAppbar({
    required this.bottomAppbarChild,
    this.color=Colors.white,
    this.height=50,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        color: color,
        height:height,
        child: bottomAppbarChild
      );
  }
}