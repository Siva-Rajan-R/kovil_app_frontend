import 'package:flutter/material.dart';
import 'package:sampleflutter/custom_controls/contact_desc_card.dart';
import 'package:sampleflutter/custom_controls/cust_bottom_appbar.dart';
import 'package:sampleflutter/custom_controls/custom_appbar.dart';
import 'package:sampleflutter/utils/builders/event_info.dart';
import 'package:sampleflutter/utils/builders/event_report.dart';
import 'package:sampleflutter/utils/enums.dart';

class DetailedEventPage extends StatefulWidget {
  final Map eventDetails;
  final List<Widget> eventStatusUpdateButtons;
  final String curUserRole;
  
  const DetailedEventPage({
    required this.eventDetails,
    required this.eventStatusUpdateButtons,
    required this.curUserRole,
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
    _tabController = TabController(length: widget.curUserRole==UserRoleEnum.ADMIN.name? 3 : 2, vsync: this);

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
    print(_tabController.index);
    return Scaffold(
      bottomNavigationBar: curTabIndex == 0
          ? CustomBottomAppbar(
              bottomAppbarChild: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [...widget.eventStatusUpdateButtons],
              ),
            )
          : null,
      appBar: KovilAppBar(withIcon: true),
      body: Column(
        children: [
          SizedBox(height: 10),
          TabBar(
            isScrollable: widget.curUserRole == UserRoleEnum.ADMIN.name? true : false,
            tabAlignment: widget.curUserRole == UserRoleEnum.ADMIN.name? TabAlignment.center : TabAlignment.fill,
            labelPadding: EdgeInsets.only(left: 25,right: 25),
            controller: _tabController,
            labelColor: Colors.black,
            indicatorColor: Colors.orange,
            tabs:  [
              Tab(text: 'Event Info'),
              Tab(text: 'Event Report'),
              if (widget.curUserRole == UserRoleEnum.ADMIN.name) Tab(text: 'Contact Description')
            ],
            onTap: (index){
              print("jiiiij $index");
              setState(() {
                curTabIndex=index;
              });
            },
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                buildEventInfo(widget.eventDetails, widget.curUserRole,context),
                buildEventReport(widget.eventDetails, context),
                if (widget.curUserRole == UserRoleEnum.ADMIN.name) ContactDescCard(eventDetails: widget.eventDetails,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

