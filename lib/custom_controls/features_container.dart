import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';



class FeaturesContainer extends StatelessWidget{
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
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: (){
          // Navigator.of(context).pushNamed(route);
          Navigator.push(context,CupertinoPageRoute(builder: (context)=>route));
          print("clicked container ${label}");
        },
        child: Container(
            width: 80,
            height: 100,
            
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.all(8.0),
        
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: containerColor,
              boxShadow: [
                BoxShadow(
                  blurRadius: 3,
                  spreadRadius: 2,
                  blurStyle: BlurStyle.outer,
                  color: shadowColor
                )
              ]
            ),
        
            child: Column(
              children: [
        
                SvgPicture.asset(
                  svgLink,
                  width: 50,
                  height: 50,
                ),
        
                Expanded(
                  child: Text(
                    label,
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
    );
  }
}