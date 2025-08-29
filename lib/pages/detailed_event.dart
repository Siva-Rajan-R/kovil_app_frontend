import 'package:sampleflutter/utils/custom_print.dart';

import 'package:flutter/material.dart';
import 'package:sampleflutter/custom_controls/contact_desc_card.dart';
import 'package:sampleflutter/custom_controls/cust_bottom_appbar.dart';
import 'package:sampleflutter/custom_controls/custom_appbar.dart';
import 'package:sampleflutter/utils/builders/event_info.dart';
import 'package:sampleflutter/utils/builders/event_report.dart';
import 'package:sampleflutter/utils/enums.dart';
import 'package:sampleflutter/utils/global_variables.dart';

class DetailedEventPage extends StatefulWidget {
  final Map eventDetails;
  final List<Widget>? eventStatusUpdateButtons;
  final bool isForBookedEvents;
  
  const DetailedEventPage({
    required this.eventDetails,
    this.eventStatusUpdateButtons,
    this.isForBookedEvents=false,
    super.key,
  });

  @override
  State<DetailedEventPage> createState() => _DetailedEventPageState();
}

class _DetailedEventPageState extends State<DetailedEventPage> with SingleTickerProviderStateMixin {
  int curTabIndex=0;
  late TabController _tabController;
  bool isLoading = false;

  @override
  void initState() {

    super.initState();
    _tabController = TabController(length: currentUserRole==UserRoleEnum.ADMIN.name? 3 : 2, vsync: this);

    _tabController.addListener(() {
      setState(() {
        curTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    printToConsole("buttons from detailed event page ${widget.eventStatusUpdateButtons} $curTabIndex");
    return Scaffold(
      bottomNavigationBar: curTabIndex == 0 && widget.eventStatusUpdateButtons!=null
          ? CustomBottomAppbar(
              bottomAppbarChild: Center(
                child: SizedBox(
                  width: 500,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [...widget.eventStatusUpdateButtons!],
                  ),
                ),
              ),
            )
          : null,
      appBar: KovilAppBar(withIcon: true),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(height: 10),
            (widget.isForBookedEvents)? Expanded(
              child: buildEventInfo(widget.eventDetails,context,isForBookedEvents: true),
            )
            : Expanded(
              child: Column(
                children: [
                  TabBar(
                    isScrollable: currentUserRole == UserRoleEnum.ADMIN.name? true : false,
                    tabAlignment: currentUserRole == UserRoleEnum.ADMIN.name? TabAlignment.center : TabAlignment.fill,
                    labelPadding: EdgeInsets.only(left: 25,right: 25),
                    controller: _tabController,
                    labelColor: Colors.black,
                    indicatorColor: Colors.orange,
                    tabs:  [
                      Tab(text: 'Event Info'),
                      Tab(text: 'Event Report'),
                      if (currentUserRole == UserRoleEnum.ADMIN.name) Tab(text: 'Contact Description')
                    ],
                    onTap: (index){
                      printToConsole("jiiiij $index");
                      setState(() {
                        curTabIndex=index;
                      });
                    },
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        buildEventInfo(widget.eventDetails,context),
                        DefaultTabController(
                          length: 2, 
                          child: Column(
                            children: [
                              TabBar(
                                labelColor: Colors.black,
                                indicatorColor: Colors.orange,
                                tabs: [
                                  Tab(text: "Actual Report"),
                                  Tab(text: "Assigned Report")
                                ],
                              ),
                              Expanded(
                                child: TabBarView(
                                  children: [
                                    buildEventReport(widget.eventDetails, context,isForAssign: false),
                                    buildEventReport(widget.eventDetails, context,isForAssign: true)
                                  ]
                                ),
                              )
                            ],
                          )
                        ),
                        if (currentUserRole == UserRoleEnum.ADMIN.name) ContactDescCard(eventDetails: widget.eventDetails,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            
          ],
        ),
      ),
    );
  }
}

