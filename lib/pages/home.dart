import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sampleflutter/custom_controls/custom_appbar.dart';
import 'package:sampleflutter/custom_controls/features_container.dart';
import 'package:sampleflutter/pages/add_event_name.dart';
import 'package:sampleflutter/pages/add_events.dart';
import 'package:sampleflutter/pages/add_worker.dart';
import 'package:sampleflutter/pages/all_events.dart';
import 'package:sampleflutter/pages/dashboard.dart';
import 'package:sampleflutter/pages/event_download.dart';
import 'package:sampleflutter/pages/login.dart';
import 'package:sampleflutter/pages/send_notification.dart';
import 'package:sampleflutter/pages/tamil_calendar.dart';
import 'package:sampleflutter/pages/today_events.dart';
import 'package:sampleflutter/pages/user.dart';
import 'package:sampleflutter/utils/delete_local_storage.dart';
import 'package:sampleflutter/utils/enums.dart';
import 'package:sampleflutter/utils/open_phone.dart';
import 'package:sampleflutter/utils/random_loading.dart';
import 'package:sampleflutter/utils/secure_storage_init.dart';

List<Widget> rowBuilder(List<Map<String,dynamic>> items){
  print("items ${items.length}");
  List<Widget> rows=[];
  List<Widget> temp=[];

  int count=0;
  // FeaturesContainer(svgLink: items[i]["svg"], label: items[i]["label"], shadowColor: items[i]["sc"], containerColor: items[i]["cc"])
  for(int i=0 ; i<items.length ; i++){
      print(i);
      temp.add(FeaturesContainer(svgLink: items[i]["svg"], label: items[i]["label"], shadowColor: items[i]["sc"], containerColor: items[i]["cc"],route: items[i]["route"],));
      count++;
      if(count==3){
        rows.add(Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: List.from(temp),));
        rows.add(SizedBox(height: 10,));
        temp.clear();
        count=0;
      }
    }
  if(temp.isNotEmpty){
    rows.add(Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: List.from(temp),));
    temp.clear();
  }
  print("rows length $rows");
  return rows;
    
  }
  
  


class HomePage extends StatefulWidget{
  final Map? triggerVersionDialogInfo;
  const HomePage(
    {
      this.triggerVersionDialogInfo,
      super.key
    }
  );

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future getCurrentUserRole() async {
    return await secureStorage.read(key: 'role');
  }

  @override
  Widget build(BuildContext context) {
  List<Map<String,dynamic>> visibleFeatures=[];
    return FutureBuilder(
      future: getCurrentUserRole(),
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LottieBuilder.asset(getRandomLoadings()),
                    SizedBox(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Please wait while fetching",style: TextStyle(fontWeight: FontWeight.w600,color: Colors.orange),),
                        VerticalDivider(),
                        SizedBox(width: 30,height: 30, child: CircularProgressIndicator(color: Colors.orange,padding: EdgeInsets.all(5),))
                      ],
                    )
                  ],
                )
              )
            )
          );
        }
        else{
          final String curUserRole=snapshot.data ?? "";
          print("cur role $curUserRole ${UserRoleEnum.ADMIN.name}");
          final List<Map<String,dynamic>> featuresSvg=[
            {"label":"Tamil Calendar","svg":"assets/svg/calendar-svgrepo-com.svg","cc":Colors.yellow.shade50,"sc":Colors.yellow.shade300,"route":TamilCalendarPage()},
            {"label":"All Events","svg":"assets/svg/event svy.svg","cc":Colors.purple.shade50,"sc":Colors.purple.shade100,"route":AllEventsPage(curUser: curUserRole,)},
            {"label":"Today Events","svg":"assets/svg/news-svgrepo-com.svg","cc":Colors.pink.shade50,"sc":Colors.pink.shade100,"route":TodayEventsPage(curUser: curUserRole,)},
            {"label":"Add Workers","svg":"assets/svg/service-workers-svgrepo-com.svg","cc":Colors.brown.shade50,"sc":Colors.brown.shade100,"route":AddWorkerPage()},
            {"label":"Add Events Name","svg":"assets/svg/writing-svgrepo-com.svg","cc":Colors.teal.shade50,"sc":Colors.teal.shade100,"route":AddEventName()},
            {"label":"Add Events","svg":"assets/svg/calendar-add-event-svgrepo-com.svg","cc":Colors.green.shade50,"sc":Colors.green.shade100,"route":AddEventsPage()},
            {"label":"Users","svg":"assets/svg/users-young-svgrepo-com.svg","cc":Colors.cyan.shade50,"sc":Colors.cyan.shade100,"route":UserPage(curUser: curUserRole,)},
            {"label":"Download&Delete","svg":"assets/svg/download-svgrepo-com.svg","cc":Colors.grey.shade300,"sc":Colors.grey.shade300,"route":EventDownloadPage()},
            {"label":"Dashboard","svg":"assets/svg/analytics-clipboard-svgrepo-com.svg","cc":Colors.pink.shade50,"sc":Colors.pink.shade300,"route":DashboardPage()},
            {"label":"Send\nNotification","svg":"assets/svg/notification-bell-svgrepo-com.svg","cc":Colors.orange.shade50,"sc":Colors.orange.shade300,"route":SendNotificationPage()},
            {"label":"Logout","svg":"assets/svg/logout-svgrepo-com.svg","cc":Colors.red.shade50,"sc":Colors.red.shade100,"route":LoginPage()},
            
          ];
          if (curUserRole==UserRoleEnum.ADMIN.name){
            visibleFeatures=featuresSvg;
          }
          else{
            visibleFeatures=[
              ...featuresSvg.sublist(0,3),
              featuresSvg.last
              
            ];
            print(visibleFeatures);
          }

          List<Widget> actions=[];
          if (widget.triggerVersionDialogInfo!=null){
            if (widget.triggerVersionDialogInfo!['triggerDialog'] ?? false) {
              widget.triggerVersionDialogInfo!["triggerDialog"]=false;
              actions.add(
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: IconButton(
                    icon: Icon(Icons.download),
                    onPressed: () {
                      openUrl(widget.triggerVersionDialogInfo!["updateUrl"], context);
                    },
                  ),
                )
              );
              WidgetsBinding.instance.addPostFrameCallback((_) {
                AwesomeDialog(
                  context: context,
                  btnOkText: "Install",
                  btnCancelText: "Later",
                  btnCancelColor: Colors.yellow.shade700,
                  headerAnimationLoop: false,
                  dismissOnTouchOutside: false,
                  dismissOnBackKeyPress: false,
                  dialogType: DialogType.info,
                  animType: AnimType.topSlide,
                  title: 'New Version',
                  desc: 'A new version is available ${widget.triggerVersionDialogInfo!['currentVersion']}. Please install.',
                  btnOkOnPress: () async {
                    print("pressed install");
                    if (widget.triggerVersionDialogInfo!['isTriggerLogin']){
                      await deleteStoredLocalStorageValues();
                    }
                    openUrl(widget.triggerVersionDialogInfo!["updateUrl"], context);
                  },
                  btnCancelOnPress: widget.triggerVersionDialogInfo!['isMandatory']? null : ()=>print("later clicked"),
                  autoDismiss: false,
                  onDismissCallback: (type) {
                    print(type);
                    if (widget.triggerVersionDialogInfo!['isMandatory']){
                      if (widget.triggerVersionDialogInfo!['oldVersion'] == widget.triggerVersionDialogInfo!['currentVersion']) {
                      
                        Navigator.of(context).pop();
                      }
                    }
                    else{
                      Navigator.of(context).pop();
                    }
                  },
                  
                ).show();
              });
            }
          }
          return Scaffold(
            appBar: KovilAppBar(withIcon: true,actions: actions,),
              body:SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                "Features",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange.shade800
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),
                      ...rowBuilder(visibleFeatures)
                        
                      ],
                    )
                  ],
                ),
              )
            );
        }
      }
    );
    
  }
} 