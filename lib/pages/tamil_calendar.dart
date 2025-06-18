import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sampleflutter/custom_controls/custom_appbar.dart';
import 'package:sampleflutter/utils/network_request.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class TamilCalendarPage extends StatefulWidget {
  const TamilCalendarPage({super.key});

  @override
  State<TamilCalendarPage> createState() => _TamilCalendarPageState();
}

class _TamilCalendarPageState extends State<TamilCalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay= DateTime.now();
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: KovilAppBar(withIcon: true,titleSize: 20,),
      body: Column(
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
                shape: BoxShape.circle
                
              ),
              todayDecoration: BoxDecoration(
                color: Colors.orange.shade400,
                shape: BoxShape.circle
                
              ),
            ),
            onDaySelected: (selectedDay, focusedDay) {
              print(DateFormat("yyyy-MM-dd").format(selectedDay));
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _calendarFormat = CalendarFormat.week; // 👉 shrink to week
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              print("$focusedDay,$_focusedDay");
              _focusedDay = focusedDay;
            },
          ),
          SizedBox(height: 20,),
          Expanded(
            child:SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InteractiveViewer(
                        minScale: 0.5,
                        maxScale: 4.0,
                        panEnabled: true,
                        child: CachedNetworkImage(
                          imageUrl:"$BASEURL/panchagam/calendar?date=${DateFormat("yyyy-MM-dd").format(_selectedDay)}",
                            placeholder: (context, url) {
                                return SizedBox(
                                  height: 100,
                                  child: Center(
                                    child: CircularProgressIndicator(color: Colors.orange,),
                                  ),
                                );
                            },
                            errorWidget: (context, error, stackTrace) {
                              print("Image load error: $error"); // 👈 debug print
                              return const Center(
                                child: SizedBox(
                                  height: 100,
                                  child: Text(
                                    '⚠️ Unable to load image. Check your internet connection.',
                                    style: TextStyle(color: Colors.red,fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.center,

                                  ),
                                ),
                              );
                            },
                        ),
                      ),
                  ),
                ],
              ),
            ),
          ),
          
        ],


      ),
    );
  }
}
