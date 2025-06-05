
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:sampleflutter/custom_controls/custom_ad.dart';
import 'package:sampleflutter/custom_controls/custom_appbar.dart';
import 'package:sampleflutter/custom_controls/event_card.dart';
import 'package:sampleflutter/utils/network_request.dart';
import 'package:table_calendar/table_calendar.dart';

class AllEventsPage extends StatefulWidget {
  final String curUser;
  const AllEventsPage({super.key, required this.curUser});

  @override
  State<AllEventsPage> createState() => _AllEventsPageState();
}

class _AllEventsPageState extends State<AllEventsPage> with TickerProviderStateMixin {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  List<String> eventDates = [];
  late Future<Map<String, List>> _eventsFuture;

  int noOfPendings = 0;
  int noOfCanceled = 0;
  int noOfCompleted = 0;

  List<DateTime> get eventDateObjects => eventDates.map((e) => DateTime.parse(e)).toList();

  @override
  void initState() {
    super.initState();
    fetchEventDates(_focusedDay.month, _focusedDay.year);
    _eventsFuture = getEvents();
  }

  Future<void> fetchEventDates(int month, int year) async {
    final res = await NetworkService.sendRequest(
      path: "/event/calendar?month=$month&year=$year",
      context: context,
    );
    if (res!=null) {
      setState(() {
        eventDates = List<String>.from(res['events']);
      });
    }
  }

  Future<Map<String, List>> getEvents() async {
    final res = await NetworkService.sendRequest(
      path: "/event/specific?date=${DateFormat("yyyy-MM-dd").format(_selectedDay)}",
      context: context,
    );

    if (res!=null) {
      final List<Map> eventsList = List.from(res['events']);
      final List<Map> pending = eventsList.where((e) => e["event_status"] == "pending").toList();
      final List<Map> canceled = eventsList.where((e) => e["event_status"] == "canceled").toList();
      final List<Map> finished = eventsList.where((e) => e["event_status"] == "completed").toList();

      setState(() {
        noOfPendings = pending.length;
        noOfCanceled = canceled.length;
        noOfCompleted = finished.length;
      });

      return {
        "pending": pending,
        "canceled": canceled,
        "finished": finished,
      };
    } else {
      return {
        "pending": [],
        "canceled": [],
        "finished": [],
      };
    }
  }

  Widget _buildEvents({required List events, required int currentTabIndex}) {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        return EventCard(
          eventDetails: events[index],
          currentTabIndex: currentTabIndex,
          curUser: widget.curUser,
        );
      },
    );
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
                    imageUrl: "$BASEURL/panchagam/calendar?date=${DateFormat("yyyy-MM-dd").format(_selectedDay)}",
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
            TableCalendar(
              firstDay: DateTime.utc(2025, 1, 1),
              lastDay: DateTime.utc(DateTime.now().year, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Colors.orange.shade800,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.orange.shade400,
                  shape: BoxShape.circle,
                ),
              ),
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  bool isEventDay = eventDateObjects.any((d) => isSameDay(d, day));
                  if (isEventDay) {
                    return Container(
                      margin: const EdgeInsets.all(6.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.orange.shade600, width: 2),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${day.day}',
                        style: const TextStyle(color: Colors.black),
                      ),
                    );
                  }
                  return null;
                },
              ),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _calendarFormat = CalendarFormat.week;
                  _eventsFuture = getEvents(); // update future
                });
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
                fetchEventDates(focusedDay.month, focusedDay.year);
              },
            ),
            const SizedBox(height: 10),
            TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.center,
              labelPadding: EdgeInsets.only(left: 25,right: 25),
              labelColor: Colors.black,
              indicatorColor: Colors.orange,
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
                          ? _buildEvents(events: pending, currentTabIndex: 0)
                          : const Center(child: Text("No Data Found")),
                      canceled.isNotEmpty
                          ? _buildEvents(events: canceled, currentTabIndex: 1)
                          : const Center(child: Text("No Data Found")),
                      finished.isNotEmpty
                          ? _buildEvents(events: finished, currentTabIndex: 2)
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
