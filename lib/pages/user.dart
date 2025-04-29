import 'dart:convert';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:sampleflutter/custom_controls/cust_snacbar.dart';
import 'package:sampleflutter/custom_controls/custom_appbar.dart';
import 'package:sampleflutter/custom_controls/user_card.dart';
import 'package:sampleflutter/utils/network_request.dart';
import 'package:sampleflutter/utils/user.dart';

Widget _buildUsers(List<Map> users,BuildContext context){
  if (users!=[]){
    print("naan aagi");
    return ListView.builder(
        itemCount: users.length,
        itemBuilder: (context,index){
          return UserCard(user: users[index],);
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
  UserPage({super.key});

  List<Map> customUsers=users;
  Future getUsers(BuildContext context)async {
    final List<Map> users;
    final List<Map> admins;
    final res=await NetworkService.sendRequest(path: '/users',context: context);
    final decodedRes=jsonDecode(res.body);
    print("res $decodedRes");
    if (res.statusCode!=200){
      customSnackBar(content: decodedRes['detail'], contentType: AnimatedSnackBarType.error).show(context);
      return {
        'admins':[],
        'users':[]
      };
    }
    else{
      final usersList=List<Map>.from(decodedRes['users']);
      users=usersList.where((u)=>u['role']=='user').toList();
      admins=usersList.where((u)=>u['role']=='admin').toList();
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
                    return const Center(child: CircularProgressIndicator());
                  }
                  else{
                    print("anap shhort $snapshot.data");
                    final List<Map> admins=snapshot.data['admins'];
                    final List<Map> users=snapshot.data['users'];
                    return TabBarView(
                          children: [
                            admins.isNotEmpty? _buildUsers(admins, context) : Center(child: Text("No Data Found"),),
                            users.isNotEmpty? _buildUsers(users, context) : Center(child: Text("No Data Found"),)
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