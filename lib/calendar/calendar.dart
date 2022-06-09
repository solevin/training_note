import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';

Widget calendarPage() {
  DateTime focusedDay = DateTime.now();
  return Column(
    children: [
      Padding(
        padding: EdgeInsets.fromLTRB(0, 10.h, 0, 0),
        child: TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2050, 12, 31),
          focusedDay: focusedDay,
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
          ),
        ),
      ),
    ],
  );
}
