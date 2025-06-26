import 'package:intl/intl.dart';

String formatUtcToLocal(String utcString) {
  DateTime utcTime = DateTime.parse(utcString);
  DateTime localTime = utcTime.add(const Duration(hours: 5,minutes: 30));
  return DateFormat('dd-MMM-yyyy / hh:mm a').format(localTime);
}