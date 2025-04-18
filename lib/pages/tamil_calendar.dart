import 'package:flutter/material.dart';
import 'package:sampleflutter/custom_controls/custom_appbar.dart';
import 'package:table_calendar/table_calendar.dart';

class TamilCalendarPage extends StatefulWidget {
  const TamilCalendarPage({super.key});

  @override
  State<TamilCalendarPage> createState() => _TamilCalendarPageState();
}

class _TamilCalendarPageState extends State<TamilCalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KovilAppBar(titleSize: 20,),
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
              print(selectedDay);
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
              print("${focusedDay},${_focusedDay}");
              _focusedDay = focusedDay;
            },
          ),
          SizedBox(height: 20,),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InteractiveViewer(
                        minScale: 0.5,
                        maxScale: 4.0,
                        panEnabled: true,
                        child: Image.asset(
                          "assets/image/Screenshot 2025-04-13 170837.png"
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
