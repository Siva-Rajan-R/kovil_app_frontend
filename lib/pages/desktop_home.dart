import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sampleflutter/custom_controls/custom_appbar.dart';
import 'package:sampleflutter/custom_controls/features_container.dart';
import 'package:sampleflutter/pages/add_event_name.dart';
import 'package:sampleflutter/pages/add_events.dart';
import 'package:sampleflutter/pages/add_worker.dart';
import 'package:sampleflutter/pages/all_events.dart';
import 'package:sampleflutter/pages/assigned_events.dart';
import 'package:sampleflutter/pages/dashboard.dart';
import 'package:sampleflutter/pages/event_download.dart';
import 'package:sampleflutter/pages/leave_management.dart';
import 'package:sampleflutter/pages/login.dart';
import 'package:sampleflutter/pages/recived_notification.dart';
import 'package:sampleflutter/pages/request_leave.dart';
import 'package:sampleflutter/pages/send_notification.dart';
import 'package:sampleflutter/pages/tamil_calendar.dart';
import 'package:sampleflutter/pages/today_events.dart';
import 'package:sampleflutter/pages/user.dart';
import 'package:sampleflutter/utils/delete_local_storage.dart';
import 'package:sampleflutter/utils/enums.dart';
import 'package:sampleflutter/utils/global_variables.dart';
import 'package:sampleflutter/utils/network_request.dart';
import 'package:sampleflutter/utils/open_phone.dart';
import 'package:sampleflutter/utils/random_loading.dart';


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
  


class DesktopHomePage extends StatefulWidget{
  const DesktopHomePage(
    {
      super.key
    }
  );

  @override
  State<DesktopHomePage> createState() => _DesktopHomePageState();
}

class _DesktopHomePageState extends State<DesktopHomePage> {
  List? newNotifications=[];
  List? seenNotifications=[];
  bool isNotificationClicked=false;
  String newNotificationsCounts='';

  Map? versionUpdateInfo;

  bool isLoading=false;
  bool isClickedLater=false;

  int curTabIndex=0;

  Widget pageToShow=Center(child:Text("Select any of the features"));


  Future getNotifications()async {
    
    final res=await NetworkService.sendRequest(
      context: context,
      path: "/app/notifications"
    );

    if (res!=null){
      setState(() {
        isNotificationClicked=false;
        newNotifications=res['notifications']['new'] ?? [];
        seenNotifications=res['notifications']['seen'] ?? []; 
        newNotificationsCounts=(newNotifications!=null && newNotifications!.length>9)? "9+" : (newNotifications!=null) ? newNotifications!.length.toString() : "";
      });
        
    }
  }


  Future getCurrentVersion() async {
    return await NetworkService.sendRequest(path: "/app/version", context: context);
    // return {
    //   "current_version": "1.1.2",
    //   "is_debug": false,
    //   "is_mandatory": true,
    //   "windows_update_url": "https://drive.google.com/file/d/1jcStDM7QhCcxKHhQasmIiuhBx-phXdjb/view?usp=drive_link",
    //   "is_trigger_login":false,
    // };

  }

  Future<void> getAllFuctions() async {
    setState(() {
      isLoading=true;
    });

    final results=await Future.wait(
      [
        getNotifications(),
        getCurrentVersion()
      ]
    );

    versionUpdateInfo=results[1];
    setState(() {
      isLoading=false;
    });
  }

  @override
  void initState(){
    super.initState();
    getAllFuctions();
    print("$newNotifications \n $seenNotifications ");
  }

  @override
  Widget build(BuildContext context) {
  List<Map<String,dynamic>> visibleFeatures=[];
      print("cur role $currentUserRole ${UserRoleEnum.ADMIN.name}");
      final List<Map<String,dynamic>> featuresSvg=[
        {"label":"Tamil Calendar","svg":"assets/svg/calendar-svgrepo-com.svg","cc":Colors.yellow.shade50,"sc":Colors.yellow.shade300,"route":TamilCalendarPage(),'canTap':false},
        {"label":"All Events","svg":"assets/svg/event svy.svg","cc":Colors.purple.shade50,"sc":Colors.purple.shade100,"route":AllEventsPage(),'canTap':true},
        {"label":"Today Events","svg":"assets/svg/news-svgrepo-com.svg","cc":Colors.pink.shade50,"sc":Colors.pink.shade100,"route":TodayEventsPage(),'canTap':true},
        {"label":"Assigned\nEvents","svg":"assets/svg/write-document-svgrepo-com.svg","cc":Colors.lightBlue.shade50,"sc":Colors.lightBlue.shade300,"route":AssignedEventsPage(),'canTap':false},
        {"label":"Request\nLeave","svg":"assets/svg/suitcase-svgrepo-com.svg","cc":Colors.lightGreen.shade50,"sc":Colors.lightGreen.shade300,"route":RequestLeavePage(),'canTap':false},
        {"label":"Leave\nManager","svg":"assets/svg/notepad-note-svgrepo-com.svg","cc":Colors.indigo.shade50,"sc":Colors.indigo.shade300,"route":LeaveManagementPage(),'canTap':false},
        {"label":"Workers","svg":"assets/svg/service-workers-svgrepo-com.svg","cc":Colors.brown.shade50,"sc":Colors.brown.shade100,"route":AddWorkerPage(),'canTap':false},
        {"label":"Event Names","svg":"assets/svg/writing-svgrepo-com.svg","cc":Colors.teal.shade50,"sc":Colors.teal.shade100,"route":AddEventNamePage(),'canTap':false},
        {"label":"Add Events","svg":"assets/svg/calendar-add-event-svgrepo-com.svg","cc":Colors.green.shade50,"sc":Colors.green.shade100,"route":AddEventsPage(),'canTap':true},
        {"label":"Users","svg":"assets/svg/users-young-svgrepo-com.svg","cc":Colors.cyan.shade50,"sc":Colors.cyan.shade100,"route":UserPage(),'canTap':false},
        {"label":"Download&Delete","svg":"assets/svg/download-svgrepo-com.svg","cc":Colors.grey.shade300,"sc":Colors.grey.shade300,"route":EventDownloadPage(),'canTap':false},
        {"label":"Dashboard","svg":"assets/svg/analytics-clipboard-svgrepo-com.svg","cc":Colors.pink.shade50,"sc":Colors.pink.shade300,"route":DashboardPage(),'canTap':false},
        {"label":"Send\nNotification","svg":"assets/svg/notification-bell-svgrepo-com.svg","cc":Colors.orange.shade50,"sc":Colors.orange.shade300,"route":SendNotificationPage(),'canTap':false},
        {"label":"Logout","svg":"assets/svg/logout-svgrepo-com.svg","cc":Colors.red.shade50,"sc":Colors.red.shade100,"route":LoginPage(),'canTap':true},
        
      ];
      if (currentUserRole==UserRoleEnum.ADMIN.name){
        visibleFeatures=featuresSvg;
      }
      else{
        visibleFeatures=[
          ...featuresSvg.sublist(0,5),
          featuresSvg.last
          
        ];
        print(visibleFeatures);
      }

      print("visible feature==================  ");
      
      print(packageInfo!.version);
      String updateUrl="";
      bool triggerDialog=false;
      String currentVersion=packageInfo!.version;
      String oldVersion=packageInfo!.version;
      bool isMandatory=false;
      bool isTriggerLogin=false;


      if (versionUpdateInfo!=null){
        print("hii welocome to gere $versionUpdateInfo $currentVersion");
        currentVersion=versionUpdateInfo!['current_version'];

        if(currentVersion!=oldVersion){
          isMandatory=versionUpdateInfo!["is_mandatory"]?? false;
          isTriggerLogin=versionUpdateInfo!['is_trigger_login'] ?? false;
          triggerDialog=true;

          if(isClickedLater){
            triggerDialog=false;
          }

          if(Platform.isAndroid){
            print("ehich is android");
            updateUrl=versionUpdateInfo!["android_update_url"] ?? "";
          }
          else if(Platform.isIOS){
            updateUrl=versionUpdateInfo!["ios_update_url"] ?? "";
          }
          else if(Platform.isWindows){
            updateUrl=versionUpdateInfo!["windows_update_url"] ?? "";
          }
          else{
            updateUrl=versionUpdateInfo!["macos_update_url"] ?? "";
          }

        }
      }

      List<Widget> actions=[];
      if (isClickedLater || triggerDialog) {
        actions.add(
          Padding(
            padding: const EdgeInsets.all(20),
            child: IconButton(
              icon: Icon(Icons.download),
              onPressed: () async {
                try{
                  if (isTriggerLogin){
                    await deleteStoredLocalStorageValues();
                  }
                  openUrl(updateUrl, context);
                }
                catch(e){
                  print(e);
                }
                
              },
            ),
          )
        );
      }
      if(triggerDialog){
        WidgetsBinding.instance.addPostFrameCallback((_) {
          AwesomeDialog(
            context: context,
            btnOkText: "Install",
            width: MediaQuery.of(context).size.width>400? 500 : null,
            btnCancelText: "Later",
            btnCancelColor: Colors.yellow.shade700,
            headerAnimationLoop: false,
            dismissOnTouchOutside: false,
            dismissOnBackKeyPress: false,
            dialogType: DialogType.info,
            animType: AnimType.topSlide,
            title: 'New Version',
            desc: 'A new version is available $currentVersion. Please install.',
            btnOkOnPress: () async {
              print("pressed install");
              if (isTriggerLogin){
                await deleteStoredLocalStorageValues();
              }
              openUrl(updateUrl, context);
            },
            btnCancelOnPress: isMandatory? null : ()=>print("later clicked"),
            autoDismiss: false,
            onDismissCallback: (type) {
              print(type);
              if (isMandatory){
                if (oldVersion == currentVersion) {
                
                  Navigator.of(context).pop();
                }
              }
              else{
                isClickedLater=true;
                Navigator.of(context).pop();
              }
            },
            
          ).show();
        });
      }
      
      return Stack(
        children: [
          Scaffold(
            appBar: KovilAppBar(withIcon: true,actions: actions,),
              body:RefreshIndicator(
                onRefresh: ()=> getNotifications(),
                color: Colors.orange,
                child: Row(  
                  children: [
                    Column(
                      children: [
                        SizedBox(height: 10,),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                              onTap: () async {
                                if (isNotificationClicked==false && newNotifications!.isNotEmpty){
                                  unawaited(
                                    NetworkService.sendRequest(
                                      path: '/app/notifications/seen', 
                                      context: context,
                                      method: "PUT"
                                    )
                                  );
                          
                                }
                                setState(() {
                                  isNotificationClicked=true;
                                  pageToShow=RecivedNotificationPage(newNotificationsList: newNotifications,seenNotificationList: seenNotifications);
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Badge(
                                  isLabelVisible:isNotificationClicked? false : (newNotifications!=null && newNotifications!.isNotEmpty)? true : false,
                                  backgroundColor: Colors.orange.shade700,
                                  label: Text(newNotificationsCounts,overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.bold),),
                                  child: Lottie.asset(
                                    "assets/lotties/notification_bell.json",
                                    width: 50,
                                    height: 50,
                                    animate: isNotificationClicked? false : (newNotifications!=null && newNotifications!.isNotEmpty)? true : false
                                    
                                  ),
                                ),
                              ),
                            ),
                        ),
                      ],
                    ),
                    SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              for(Map i in visibleFeatures)
                                GestureDetector(
                                  onTap: () => i['canTap']? null : setState(() {
                                    pageToShow=i['route'];
                                  }),
                                  child: FeaturesContainer(svgLink: i['svg'], label: i['label'], shadowColor: i['sc'], containerColor: i['cc'], route: i['route'],canTap: i['canTap'],)
                                )
                            ],
                          ),
                        ],
                      ),
                    ),
                    VerticalDivider(width: 20,),
                    Expanded(child: Center(child: pageToShow))
                  ],
                ),
              )
            ),

            if (isLoading)
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2.2, sigmaY:1 ),
                  child: Container(
                    color: Colors.black12,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          LottieBuilder.asset(getRandomLoadings(),height: MediaQuery.of(context).size.height*0.5,),
                        ],
                      )
                    )
                  ),
                ),
        ],
      );
    
  }
} 