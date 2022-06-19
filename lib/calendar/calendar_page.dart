import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_note/calendar/training_log_page.dart';
import 'package:training_note/calendar/calendar_page_view.dart';
import 'package:training_note/db/training_log_dao.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Widget calendarPage(BuildContext context, WidgetRef ref) {
  DateTime focusedDay = ref.watch(focusProvider);
  DateTime selectedDay = ref.watch(selectedProvider);
  return FutureBuilder(
      future: addEvents(focusedDay.year, focusedDay.month, ref),
      builder: (BuildContext context,
          AsyncSnapshot<Map<DateTime, List<Map<String, Object>>>> snapshot) {
        if (snapshot.hasData) {
          return futureCalendar(
              focusedDay, selectedDay, snapshot.data!, context, ref);
        } else {
          return syncCalendar(focusedDay, ref);
        }
      });
}

Widget futureCalendar(
    DateTime focusedDay,
    DateTime selectedDay,
    Map<DateTime, List<Map<String, Object>>> preEvents,
    BuildContext context,
    WidgetRef ref) {
  LinkedHashMap<DateTime, List> events = LinkedHashMap<DateTime, List>(
    equals: isSameDay,
    hashCode: getHashCode,
  )..addAll(preEvents);

  List getEventForDay(DateTime day) {
    if (events[day] == null) {
      return [];
    } else {
      return events[day]!;
    }
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
            onDaySelected: (newSelectedDay, newFocusedDay) async {
              if (!isSameDay(selectedDay, newSelectedDay)) {
                ref.read(selectedProvider.notifier).state = newSelectedDay;
                ref.read(focusProvider.notifier).state = newFocusedDay;
                getEventForDay(selectedDay);
              } else {
                final id = await setDateProvider(ref);
                Navigator.of(context).push<dynamic>(
                  TrainingLogPage.route(id: id),
                );
              }
            },
            onPageChanged: (newFocusedDay) {
              ref.read(focusProvider.notifier).state = newFocusedDay;
            },
          )),
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

Widget syncCalendar(DateTime focusedDay, WidgetRef ref) {
  return Padding(
      padding: EdgeInsets.fromLTRB(0, 10.h, 0, 0),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2050, 12, 31),
        focusedDay: focusedDay,
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
        ),
        onPageChanged: (newFocusedDay) {
          ref.read(focusProvider.notifier).state = newFocusedDay;
        },
      ));
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

Future<Map<DateTime, List<Map<String, Object>>>> addEvents(
    int year, int month, WidgetRef ref) async {
  final dao = TrainingLogDao();
  Map<DateTime, List<Map<String, Object>>> preEvents = {};
  final eventList = await dao.findAll();
  for (int i = 0; i < eventList.length; i++) {
    final event = eventList[i];
    final date = DateTime(event.year, event.month, event.day);
    if (event.ballQuantity > 0) {
      final contents = {'ballQuantity': event.ballQuantity, 'memo': event.memo};
      if (preEvents[date] != null) {
        final tmpList = preEvents[date];
        tmpList!.add(contents);
        preEvents.addAll({date: tmpList});
      } else {
        preEvents.addAll({
          date: [contents]
        });
      }
    }
    if (event.score > 0) {
      final contents = {'score': event.score, 'memo': event.memo};
      if (preEvents[date] != null) {
        final tmpList = preEvents[date];
        tmpList!.add(contents);
        preEvents.addAll({date: tmpList});
      } else {
        preEvents.addAll({
          date: [contents]
        });
      }
    }
  }
  return preEvents;
}

Future<int> setDateProvider(WidgetRef ref) async {
  final dao = TrainingLogDao();
  final selectedDay = ref.read(selectedProvider);
  final eventId =
      await dao.findByDay(selectedDay.year, selectedDay.month, selectedDay.day);
  if (eventId.isNotEmpty) {
    final event = await dao.findById(eventId[0]);
    ref.read(ballQuantityProvider.notifier).state =
        event.ballQuantity.toString();
    ref.read(scoreProvider.notifier).state = event.score.toString();
    ref.read(memoProvider.notifier).state = event.memo;
    return eventId[0];
  } else {
    ref.read(ballQuantityProvider.notifier).state = '0';
    ref.read(scoreProvider.notifier).state = '0';
    ref.read(memoProvider.notifier).state = '';
    return -1;
  }
}
