import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_note/calendar/training_log_page.dart';
import 'package:training_note/calendar/calendar_page_view.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Widget calendarPage(BuildContext context, WidgetRef ref) {
  DateTime focusedDay = ref.watch(focusProvider);
  DateTime selectedDay = ref.watch(selectedProvider);
  Map<DateTime, List> preEvents = ref.watch(preEventProvider);
  final tmp = {
    DateTime.now().subtract(Duration(days: 2)): ['Event A6', 'Event B6'],
    DateTime.now(): ['Event A7', 'Event B7', 'Event C7', 'Event D7'],
    DateTime.now().add(Duration(days: 1)): [
      'Event A8',
      'Event B8',
      'Event C8',
      'Event D8'
    ],
    DateTime.now().add(Duration(days: 3)):
        Set.from(['Event A9', 'Event A9', 'Event B9']).toList(),
  };
  ref.read(preEventProvider.notifier).state.addAll(tmp);

  LinkedHashMap<DateTime, List> events = LinkedHashMap<DateTime, List>(
    equals: isSameDay,
    hashCode: getHashCode,
  )..addAll(preEvents);

  List getEventForDay(DateTime day) {
    return events[day] ?? [];
  }

  return Column(
    children: [
      Padding(
        padding: EdgeInsets.fromLTRB(0, 10.h, 0, 0),
        child: TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2050, 12, 31),
          focusedDay: focusedDay,
          eventLoader: getEventForDay,
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
          ),
          selectedDayPredicate: (day) {
            return isSameDay(selectedDay, day);
          },
          onDaySelected: (newSelectedDay, newFocusedDay) {
            if (!isSameDay(selectedDay, newSelectedDay)) {
              ref.read(selectedProvider.notifier).state = newSelectedDay;
              ref.read(focusProvider.notifier).state = newFocusedDay;
              getEventForDay(selectedDay);
            } else {
              Navigator.of(context).push<dynamic>(
                TrainingLogPage.route(),
              );
              // ref.read(preEventProvider.notifier).state.addAll({
              //   selectedDay: ['test']
              // });
            }
          },
          onPageChanged: (newFocusedDay) {
            ref.read(focusProvider.notifier).state = newFocusedDay;
          },
        ),
      ),
      ListView(
        shrinkWrap: true,
        children: getEventForDay(selectedDay)
            .map((event) => ListTile(
                  title: Text(event.toString()),
                ))
            .toList(),
      )
    ],
  );
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}
