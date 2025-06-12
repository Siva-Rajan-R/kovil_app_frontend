import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:sampleflutter/pages/home.dart';
import 'package:sampleflutter/utils/enums.dart';
import 'package:sampleflutter/utils/network_request.dart';

import 'package:sampleflutter/utils/open_phone.dart';


class UserCard extends StatefulWidget{
  final Map user;
  final String curUser;
  
  const UserCard({
    required this.user,
    required this.curUser,
    super.key
  });

  @override
  State<UserCard> createState() => _UserCardState();
}
class _UserCardState extends State<UserCard> {
  bool isloading=false;
  
  @override
  Widget build(BuildContext context) {
    print(widget.user);
    return PopScope(
      canPop: isloading? false : true,
      child: Stack(
        children: [
          Container(
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    widget.curUser==UserRoleEnum.ADMIN.name?
                      PopupMenuButton(
                        icon: Icon(Icons.more_horiz,color: Colors.white,),
                        onSelected: (value)async{
                          if(value=="delete"){
                            AwesomeDialog(
                              context: context,
                              btnOkText: "Yes",
                              dismissOnTouchOutside: false,
                              dismissOnBackKeyPress: false,
                              dialogType: DialogType.info,
                              animType: AnimType.topSlide,
                              title: 'Delete User',
                              desc: 'Are you sure , Do you Want to Delete ${widget.user['name']} ?',
                              btnCancelOnPress: () {},
                              btnOkOnPress: () async {
                                setState(() {
                                  isloading = true;
                                });
                                final res=await NetworkService.sendRequest(path: "/user", context: context,method: "DELETE",body: {"del_user_id":widget.user['id']});
                                print(res);
                                setState(() {
                                    isloading=false;
                                  });
          
                                if(res!=null){
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    CupertinoPageRoute(builder: (context) => HomePage()),
                                    (route) => false,
                                  );
                                }
                              },
                            ).show();
                          }
                        else{
                          AwesomeDialog(
                              context: context,
                              btnOkText: "Yes",
                              dismissOnTouchOutside: false,
                              dismissOnBackKeyPress: false,
                              dialogType: DialogType.info,
                              animType: AnimType.topSlide,
                              title: 'Update User Role',
                              desc: 'Are you sure , Do you Want to Make ${widget.user['name']} as $value ?',
                              btnCancelOnPress: () {},
                              btnOkOnPress: () async {
                                setState(() {
                                  isloading = true;
                                });
                                final res=await NetworkService.sendRequest(path: "/user/role", context: context,method: "PUT",body: {"user_id":widget.user['id'],"role":value});
                                print(res);
                                setState(() {
                                    isloading=false;
                                  });
          
                                if(res!=null){
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    CupertinoPageRoute(builder: (context) => HomePage()),
                                    (route) => false,
                                  );
                                }
                              },
                            ).show();
                        }
                          
                          
                        },
                        itemBuilder: (context){
                          return [
                            PopupMenuItem(value: "delete",child: Text("Delete",style: TextStyle(color: Colors.orange.shade800))),
                            PopupMenuItem(value: widget.user['role']=="admin"? "user" : "admin",child: Text(widget.user['role']=="admin"? "Make as user" : "Make as admin",style: TextStyle(color: Colors.orange.shade800),))
                          ];
                        }
                      )
                    : Text("")
                  ],
                ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/svg/user-svgrepo-com.svg",
                        width: 20,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.user["name"],
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
                      Expanded(
                        child: GestureDetector(
                          onTap: () => makePhoneCall(widget.user["mobile_number"], context),
                          child: Text(
                            widget.user["mobile_number"],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: 18
                            ),
                            softWrap: true,
                          ),
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
                        widget.user["email"],
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
      
          if(isloading)
            Positioned.fill(
              child: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
            
          
        ],
      ),
    );
  }
}