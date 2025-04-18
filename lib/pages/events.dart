import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sampleflutter/custom_controls/custom_appbar.dart';
import 'package:table_calendar/table_calendar.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KovilAppBar(titleSize: 20,),
      body: DefaultTabController(
  length: 3,
  child: Column(
    children: [
      TableCalendar(
        firstDay: DateTime.utc(2025, 1, 1),
        lastDay: DateTime.utc(2026, 1, 1),
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
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
            _calendarFormat = CalendarFormat.week;
          });
        },
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
      ),
      const SizedBox(height: 10),
      const TabBar(
        labelColor: Colors.black,
        indicatorColor: Colors.orange,
        tabs: [
          Tab(text: 'Pending'),
          Tab(text: 'Cancelled'),
          Tab(text: 'Finished'),
        ],
      ),
      Expanded(
        child: TabBarView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.orange.shade400,
                      Colors.orange.shade600,
                      Colors.orange.shade800
                    ]),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.shade800,
                        blurRadius: 5,
                        spreadRadius: 2,
                        blurStyle: BlurStyle.outer
                      )
                    ]
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/svg/event svy.svg",
                              width: 20,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Sivan Poojai For Sivan",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 18
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/svg/user-svgrepo-com.svg",
                              width: 20,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "SIva Rajan R",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 18
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/svg/mobile-phone-svgrepo-com.svg",
                              width: 20,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "8248692839",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 18
                              ),
                            ),
                          ],
                        ),
                        
                      ],
                    ),
                  ),
                )
                
              ],
            ),
            Center(child: Text("Cancelled items here")),
            Center(child: Text("Finished items here")),
          ],
        ),
      ),
    ],
  ),
),
    );
  }
}
