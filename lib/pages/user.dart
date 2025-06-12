
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sampleflutter/custom_controls/custom_appbar.dart';
import 'package:sampleflutter/custom_controls/user_card.dart';
import 'package:sampleflutter/utils/network_request.dart';
import 'package:sampleflutter/utils/random_loading.dart';


Widget _buildUsers({required List users,required BuildContext context,required String curuser }){
  if (users!=[]){
    print("naan aagi");
    return ListView.builder(
        itemCount: users.length,
        itemBuilder: (context,index){
          return UserCard(user: users[index],curUser: curuser,);
        }
      );
  }

  else{
    return Center(
      child: Text("No Data Found"),
    );
  }
}

// ignore: must_be_immutable
class UserPage extends StatelessWidget{
  final String curUser;
  const UserPage({super.key,required this.curUser});

  Future getUsers(BuildContext context)async {
    final List<Map> users;
    final List<Map> admins;
    final res=await NetworkService.sendRequest(path: '/users',context: context);
    print("res $res");
    if (res==null){
      return {
        'admins':[],
        'users':[]
      };
    }
    else{
      final usersList=List<Map>.from(res['users']);
      users=usersList.where((u)=>u['role']=='user').toList();
      admins=usersList.where((u)=>u['role']=="admin").toList();
        return {
        'users':users,
        'admins':admins
      };
    }

    
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: KovilAppBar(withIcon: true,),
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
              child: FutureBuilder(
                future: getUsers(context),
                builder: (context,snapshot){
                  if (snapshot.connectionState==ConnectionState.waiting){
                    return Center(
                      child: Column(
                        
                        children: [
                          LottieBuilder.asset(getRandomLoadings()),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Please wait while fetching users...",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w600,color: Colors.orange),),
                              VerticalDivider(),
                              SizedBox(width: 30,height: 30, child: CircularProgressIndicator(color: Colors.orange,padding: EdgeInsets.all(5),))
                            ],
                          )
                        ],
                      )
                    );
                  }
                  else{
                    print("anap shhort $snapshot.data");
                    List admins=[];
                    List users=[];
                    if (snapshot.data!=null){
                      admins=snapshot.data!['admins'];
                      users=snapshot.data!['users'];
                    }
                    return TabBarView(
                          children: [
                            admins.isNotEmpty? _buildUsers(users: admins,context: context,curuser: curUser) : Center(child: Text("No Data Found"),),
                            users.isNotEmpty? _buildUsers(users: users,context: context,curuser: curUser) : Center(child: Text("No Data Found"),)
                          ],
                      );
                  }
                },
              ),
            )
          ],
        ),
      ),
    ); 
    
  }
}