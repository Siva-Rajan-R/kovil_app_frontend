import 'dart:convert';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sampleflutter/custom_controls/cust_snacbar.dart';
import 'package:sampleflutter/custom_controls/event_card.dart';
import 'package:sampleflutter/custom_controls/custom_appbar.dart';
import 'package:sampleflutter/custom_controls/custom_ad.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:sampleflutter/utils/network_request.dart';

Widget _buildEvents({
  required List events,
  required int currentTabIndex,
  required BuildContext context,
  required String curUser,
}) {
  return ListView.builder(
    itemCount: events.length,
    itemBuilder: (context, index) {
      return EventCard(
        eventDetails: events[index],
        currentTabIndex: currentTabIndex,
        curUser: curUser,
      );
    },
  );
}

class TodayEventsPage extends StatefulWidget {
  final String curUser;
  const TodayEventsPage({super.key, required this.curUser});

  @override
  State<TodayEventsPage> createState() => _TodayEventsPageState();
}

class _TodayEventsPageState extends State<TodayEventsPage> {
  late Future<Map<String, List>> _eventsFuture;
  int noOfPendings = 0;
  int noOfCanceled = 0;
  int noOfCompleted = 0;

  @override
  void initState() {
    super.initState();
    _eventsFuture = getEvents();
  }

  Future<Map<String, List>> getEvents() async {
    final res = await NetworkService.sendRequest(
      path: "/event/specific?date=${DateFormat("yyyy-MM-dd").format(DateTime.now())}",
      context: context,
    );

    final decodedRes = jsonDecode(utf8.decode(res.bodyBytes));

    if (res.statusCode == 200) {
      final eventsList = List<Map>.from(decodedRes['events']);

      final pending = eventsList.where((e) => e["event_status"] == "pending").toList();
      final canceled = eventsList.where((e) => e["event_status"] == "canceled").toList();
      final finished = eventsList.where((e) => e["event_status"] == "completed").toList();

      setState(() {
        noOfPendings = pending.length;
        noOfCanceled = canceled.length;
        noOfCompleted = finished.length;
      });

      return {
        'pending': pending,
        'canceled': canceled,
        'finished': finished,
      };
    } else {
      customSnackBar(content: decodedRes['detail'], contentType: AnimatedSnackBarType.error).show(context);
      return {
        'pending': [],
        'canceled': [],
        'finished': [],
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KovilAppBar(
        withIcon: true,
        titleSize: 20,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => ImageShowerDialog(
                    imageUrl: "$BASEURL/panchagam/calendar?date=${DateFormat("yyyy-MM-dd").format(DateTime.now())}",
                  ),
                ),
              ),
              child: SvgPicture.asset(
                "assets/svg/calendar-svgrepo-com.svg",
                width: 30,
              ),
            ),
          )
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const SizedBox(height: 10),
            TabBar(
              labelColor: Colors.black,
              indicatorColor: Colors.orange,
              isScrollable: true,
              tabAlignment: TabAlignment.center,
              labelPadding: EdgeInsets.only(left: 25,right: 25),
              tabs: [
                Tab(text: 'Pending ($noOfPendings)'),
                Tab(text: 'Canceled ($noOfCanceled)'),
                Tab(text: 'Completed ($noOfCompleted)'),
              ],
            ),
            Expanded(
              child: FutureBuilder<Map<String, List>>(
                future: _eventsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Colors.orange));
                  }

                  final pending = snapshot.data?['pending'] ?? [];
                  final canceled = snapshot.data?['canceled'] ?? [];
                  final finished = snapshot.data?['finished'] ?? [];

                  return TabBarView(
                    children: [
                      pending.isNotEmpty
                          ? _buildEvents(events: pending, currentTabIndex: 0, context: context, curUser: widget.curUser)
                          : const Center(child: Text("No Data Found")),
                      canceled.isNotEmpty
                          ? _buildEvents(events: canceled, currentTabIndex: 1, context: context, curUser: widget.curUser)
                          : const Center(child: Text("No Data Found")),
                      finished.isNotEmpty
                          ? _buildEvents(events: finished, currentTabIndex: 2, context: context, curUser: widget.curUser)
                          : const Center(child: Text("No Data Found")),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
