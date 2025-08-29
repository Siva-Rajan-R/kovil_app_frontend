
import 'package:sampleflutter/utils/custom_print.dart';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sampleflutter/custom_controls/custom_appbar.dart';
import 'package:sampleflutter/custom_controls/user_card.dart';
import 'package:sampleflutter/utils/global_variables.dart';
import 'package:sampleflutter/utils/network_request.dart';
import 'package:sampleflutter/utils/random_loading.dart';




// ignore: must_be_immutable
class UserPage extends StatefulWidget{
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<Map> users=[];
  List<Map> admins=[];
  bool isLoading=true;

  void onUsersDelete(String userRole,String userId){
    List userListToDelete=users;
    if (userRole=='admin'){
      userListToDelete=admins;
    }

    setState(() {
      userListToDelete.removeWhere((user)=>user['id']==userId);
    });
  }

  void onUsersRoleChanged(String prevUserRole,String userId){
    List userListToUpdate=admins;
    List swappedUserList=users;
    String userRole='admin';

    printToConsole("hyyyyyyyyyyyyyyyyyyyyyyyyyy $admins $users $userId $prevUserRole");
    if (prevUserRole=='admin'){
      userListToUpdate=users;
      swappedUserList=admins;
      userRole='user';
    }
    printToConsole("llllllllllllllllll $swappedUserList ");
    Map userToAdd=swappedUserList.firstWhere((user)=>user['id']==userId) ?? {};
     printToConsole("$userToAdd");
    userToAdd['role']=userRole;
    setState(() {
      userListToUpdate.add(userToAdd);
      swappedUserList.removeWhere((user)=>user['id']==userId);
    });
  }

  Widget _buildUsers({required List users,required BuildContext context}){
    if (users.isNotEmpty){
      printToConsole("naan aagi");
      return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: users.length,
        itemBuilder: (context,index){
          return RepaintBoundary(
            child: UserCard(
              onDelete: (userRole,userId) => onUsersDelete(userRole, userId),
              onRoleChangeed: (userRole, userId) => onUsersRoleChanged(userRole, userId),
              user: users[index]
            )
          );
        }
      );
    }

    else{
      return Center(
        child: Text("No Data Found"),
      );
    }
}

  Future getUsers(BuildContext context)async {
    final res=await NetworkService.sendRequest(path: '/users',context: context);
    printToConsole("res $res");
    if (res==null){
      setState(() {
        users=[];
        admins=[];
        isLoading=false;
      });
    }
    else{
      final usersList=List<Map>.from(res['users']);

      setState(() {
        users=usersList.where((u)=>u['role']=='user').toList();
        admins=usersList.where((u)=>u['role']=="admin").toList();
        isLoading=false;
      });
    }
  }

  @override
  void initState(){
    super.initState();
    
    getUsers(context);
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: MediaQuery.of(context).size.width>phoneSize? null : KovilAppBar(withIcon: true,),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const SizedBox(height: 10),
            const TabBar(
              labelColor: Colors.black,
              indicatorColor: Colors.orange,
              
              tabs: [
                Tab(text: 'Admin'),
                Tab(text: 'User'),
              ],
            ),

            Expanded(
              child: isLoading? Center(
                child: Column(
                  children: [
                    LottieBuilder.asset(getRandomLoadings(),height: MediaQuery.of(context).size.height*0.5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Please wait while fetching users...",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w600,color: Colors.orange),),
                        VerticalDivider(),
                        SizedBox(width: 30,height: 30, child: CircularProgressIndicator(color: Colors.orange,padding: EdgeInsets.all(5),))
                      ],
                    )
                  ],
                ),
              )
              : TabBarView(
                  children: [
                    admins.isNotEmpty? _buildUsers(users: admins,context: context) : Center(child: Text("No Data Found"),),
                    users.isNotEmpty? _buildUsers(users: users,context: context) : Center(child: Text("No Data Found"),)
                  ],
              )

            )
          ],
        ),
      ),
    ); 
    
  }
}