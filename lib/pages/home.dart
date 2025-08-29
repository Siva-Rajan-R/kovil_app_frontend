import 'dart:async';
import 'dart:io';
import 'package:sampleflutter/utils/custom_print.dart';
import 'dart:ui';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
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
  printToConsole("items ${items.length}");
  List<Widget> rows=[];
  List<Widget> temp=[];


  int count=0;
  // FeaturesContainer(svgLink: items[i]["svg"], label: items[i]["label"], shadowColor: items[i]["sc"], containerColor: items[i]["cc"])
  for(int i=0 ; i<items.length ; i++){
      printToConsole("$i");
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
  printToConsole("rows length $rows",color: ConsoleColors.yellow);
  return rows;
    
  }
  

bool isVersionLess(String appVersion, String serverVersion) {
  List<int> p1 = appVersion.split('.').map(int.parse).toList();
  List<int> p2 = serverVersion.split('.').map(int.parse).toList();

  for (int i = 0; i < p1.length; i++) {
    if (p1[i] < p2[i]) return true;
    if (p1[i] > p2[i]) return false;
  }
  return false; // equal versions
}


class HomePage extends StatefulWidget{
  const HomePage(
    {
      super.key
    }
  );

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List? newNotifications=[];
  List? seenNotifications=[];
  bool isNotificationClicked=false;
  String newNotificationsCounts='';

  Map? versionUpdateInfo;

  bool isLoading=false;
  bool isClickedLater=false;


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
    //   "current_version": "1.1.0",
    //   "is_debug": false,
    //   "is_mandatory": false,
    //   "android_update_url": "https://drive.google.com/file/d/1jcStDM7QhCcxKHhQasmIiuhBx-phXdjb/view?usp=drive_link",
    //   "is_trigger_login":true,
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
    
    printToConsole("$newNotifications \n $seenNotifications ");
  }

  @override
  Widget build(BuildContext context) {
  List<Map<String,dynamic>> visibleFeatures=[];
      printToConsole("cur role $currentUserRole ${UserRoleEnum.ADMIN.name}");
      final List<Map<String,dynamic>> featuresSvg=[
        {"label":"Tamil Calendar","svg":"assets/svg/calendar-svgrepo-com.svg","cc":Colors.yellow.shade50,"sc":Colors.yellow.shade300,"route":TamilCalendarPage()},
        {"label":"All Events","svg":"assets/svg/event svy.svg","cc":Colors.purple.shade50,"sc":Colors.purple.shade100,"route":AllEventsPage()},
        {"label":"Today Events","svg":"assets/svg/news-svgrepo-com.svg","cc":Colors.pink.shade50,"sc":Colors.pink.shade100,"route":TodayEventsPage()},
        {"label":"Assigned\nEvents","svg":"assets/svg/write-document-svgrepo-com.svg","cc":Colors.lightBlue.shade50,"sc":Colors.lightBlue.shade300,"route":AssignedEventsPage()},
        {"label":"Request\nLeave","svg":"assets/svg/suitcase-svgrepo-com.svg","cc":Colors.lightGreen.shade50,"sc":Colors.lightGreen.shade300,"route":RequestLeavePage()},
        {"label":"Leave\nManager","svg":"assets/svg/notepad-note-svgrepo-com.svg","cc":Colors.indigo.shade50,"sc":Colors.indigo.shade300,"route":LeaveManagementPage()},
        {"label":"Workers","svg":"assets/svg/service-workers-svgrepo-com.svg","cc":Colors.brown.shade50,"sc":Colors.brown.shade100,"route":AddWorkerPage()},
        {"label":"Event Names","svg":"assets/svg/writing-svgrepo-com.svg","cc":Colors.teal.shade50,"sc":Colors.teal.shade100,"route":AddEventNamePage()},
        {"label":"Add Events","svg":"assets/svg/calendar-add-event-svgrepo-com.svg","cc":Colors.green.shade50,"sc":Colors.green.shade100,"route":AddEventsPage()},
        // {"label":"Booked Events","svg":"assets/svg/booked_calendar-svgrepo-com.svg","cc":Colors.lime.shade50,"sc":Colors.lime.shade100,"route":BookedEventsPage()},
        {"label":"Users","svg":"assets/svg/users-young-svgrepo-com.svg","cc":Colors.cyan.shade50,"sc":Colors.cyan.shade100,"route":UserPage()},
        {"label":"Download&Delete","svg":"assets/svg/download-svgrepo-com.svg","cc":Colors.grey.shade300,"sc":Colors.grey.shade300,"route":EventDownloadPage()},
        {"label":"Dashboard","svg":"assets/svg/analytics-clipboard-svgrepo-com.svg","cc":Colors.pink.shade50,"sc":Colors.pink.shade300,"route":DashboardPage()},
        {"label":"Send\nNotification","svg":"assets/svg/notification-bell-svgrepo-com.svg","cc":Colors.orange.shade50,"sc":Colors.orange.shade300,"route":SendNotificationPage()},
        {"label":"Logout","svg":"assets/svg/logout-svgrepo-com.svg","cc":Colors.red.shade50,"sc":Colors.red.shade100,"route":LoginPage()},
        
      ];
      if (currentUserRole==UserRoleEnum.ADMIN.name){
        visibleFeatures=featuresSvg;
      }
      else{
        visibleFeatures=[
          ...featuresSvg.sublist(0,5),
          featuresSvg.last
          
        ];
        printToConsole("$visibleFeatures");
      }

      printToConsole("visible feature==================  ");
      
      printToConsole(packageInfo!.version);
      String updateUrl="";
      bool triggerDialog=false;
      String currentVersion=packageInfo!.version;
      String oldVersion=packageInfo!.version;
      bool isMandatory=false;
      bool isTriggerLogin=false;


      if (versionUpdateInfo!=null){
        printToConsole("hii welocome to gere $versionUpdateInfo $currentVersion");
        currentVersion=versionUpdateInfo!['current_version'];

        if(isVersionLess(oldVersion, currentVersion)){
          isMandatory=versionUpdateInfo!["is_mandatory"] ?? false;
          isTriggerLogin=versionUpdateInfo!['is_trigger_login'] ?? false;
          triggerDialog=true;

          if(isClickedLater){
            triggerDialog=false;
          }
          printToConsole("ehich is android");
          if(Platform.isAndroid){
            printToConsole("ehich is android");
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
                  printToConsole("$e");
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
              printToConsole("pressed install");
              if (isTriggerLogin){
                await deleteStoredLocalStorageValues();
              }
              openUrl(updateUrl, context);
            },
            btnCancelOnPress: isMandatory? null : ()=>printToConsole("later clicked"),
            autoDismiss: false,
            onDismissCallback: (type) {
              printToConsole("$type");
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
      printToConsole("size of the screen bro : 🙏🦒 ${MediaQuery.of(context).size.height}");
      return Stack(
        children: [
          Scaffold(
            appBar: KovilAppBar(withIcon: true,actions: actions,),
              body:SizedBox.expand(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Features",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade800
                            ),
                          ),
                          Row(
                            children: [
                              // if(currentUserRole==UserRoleEnum.ADMIN.name)
                            //     MouseRegion(
                            //     cursor: SystemMouseCursors.click,
                            //     child: GestureDetector(
                            //       onTap: () async {
                            //         final generatedLink=await NetworkService.sendRequest(
                            //           path: '/user/generate/client-link', 
                            //           context: context,
                            //           method: "get"
                            //         );
                            //         if(generatedLink!=null){
                            //           clipboardDialog(context, generatedLink);
                            //         }

                            //       },
                            //       child: Padding(
                            //         padding: const EdgeInsets.only(right: 8.0),
                            //         child: SvgPicture.asset(
                            //           "assets/svg/paper-rocket-svgrepo-com.svg",
                            //           width: 30,
                            //           height: 30,
                            //         )
                            //     ),
                            //   ),
                            // ),
                          GestureDetector(
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
                              });
                              Navigator.of(context).push(CupertinoPageRoute(builder: (context)=> RecivedNotificationPage(newNotificationsList: newNotifications,seenNotificationList: seenNotifications)));
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
                          )
                            ],
                          )
                          
                        ],
                      ),
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        color: Colors.orange,
                        onRefresh: ()=>getNotifications(),
                        child: SingleChildScrollView(
                          physics:AlwaysScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              ...rowBuilder(visibleFeatures)
                            ],
                          ),
                        ),
                      ),
                    )
                  
                    
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