import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget eventNamesAmountCard({required String eventName,required String eventAmount}){
  return Container(
    margin: EdgeInsets.all(10),
    padding: EdgeInsets.all(10),
    width: double.infinity,
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [
        Colors.orange.shade400,
        Colors.orange.shade600,
        Colors.orange.shade800
      ]),
      borderRadius: BorderRadius.all(Radius.circular(20)),
      boxShadow: [
        BoxShadow(
          color: Colors.orange.shade800,
          blurRadius: 5,
          spreadRadius: 2,
          blurStyle: BlurStyle.outer
        )
      ]
    ),
    child: Column(
      children: [
        Row(
            children: [
              SvgPicture.asset(
                "assets/svg/event svy.svg",
                width: 20,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  eventName,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 18
                  ),
                  softWrap: true,
                ),
              ),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              SvgPicture.asset(
                "assets/svg/information-svgrepo-com.svg",
                width: 20,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  eventAmount,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 18,
                    
                  ),
                  softWrap: true,
                  
                ),
              ),
            ],
          ),
      ],
    ),
  );
}