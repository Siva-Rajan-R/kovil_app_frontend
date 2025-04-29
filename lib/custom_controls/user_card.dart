import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class UserCard extends StatelessWidget{
  final Map user;
  
  const UserCard({
    required this.user,
    super.key
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
        
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(5),
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
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              SizedBox(height: 10,),
              Row(
                children: [
                  SvgPicture.asset(
                    "assets/svg/user-svgrepo-com.svg",
                    width: 20,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      user["name"],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 18
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  SvgPicture.asset(
                    "assets/svg/mobile-phone-svgrepo-com.svg",
                    width: 20,
                  ),
                  SizedBox(width: 10),
                  Text(
                    user["mobile_number"],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 18
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  SvgPicture.asset(
                    "assets/svg/mailbox-svgrepo-com.svg",
                    width: 20,
                  ),
                  SizedBox(width: 10),
                  Text(
                    user["email"],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 18
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }
}