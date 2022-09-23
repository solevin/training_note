import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_note/db/advice.dart';
import 'package:training_note/db/distance_by_count_dao.dart';
import 'package:training_note/home/home_view.dart';
import 'package:training_note/training/training_log_page.dart';
import 'package:training_note/calendar/calendar_page_view.dart';
import 'package:training_note/training/set_training_page.dart';
import 'package:training_note/training/set_training_page_view.dart';
import 'package:training_note/db/training_log_dao.dart';
import 'package:training_note/db/advice_dao.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CalendarPage extends HookConsumerWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (_) => const CalendarPage(),
    );
  }

  const CalendarPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime focusedDay = ref.watch(focusProvider);
    DateTime selectedDay = ref.watch(selectedProvider);
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Calendar',
            style: TextStyle(fontSize: 20.sp),
          ),
          automaticallyImplyLeading: false),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.golf_course),
        onPressed: () async {
          ref.read(idProvider.notifier).state =
              await setDateProvider(ref, DateTime.now());
          // ref.read(checkBoxProvider.notifier).init(adviceList.length);
          Navigator.of(context).push<dynamic>(
            SetTrainingPage.route(),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: FutureBuilder(
        future: getSnapshot(ref, focusedDay),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            return futureCalendar(
                focusedDay, selectedDay, snapshot.data!, context, ref);
          } else {
            return syncCalendar(focusedDay, ref);
          }
        },
      ),
      bottomNavigationBar: commonBottomNavigationBar(context, ref),
    );
  }
}

Widget futureCalendar(DateTime focusedDay, DateTime selectedDay, List snapshot,
    BuildContext context, WidgetRef ref) {
  LinkedHashMap<DateTime, List> events = LinkedHashMap<DateTime, List>(
    equals: isSameDay,
    hashCode: getHashCode,
  )..addAll(snapshot[0]);

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
        padding: EdgeInsets.fromLTRB(0, 20.h, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(60.w, 0, 0, 0),
              child: SizedBox(
                width: 130.w,
                child: Row(
                  children: [
                    Text(
                      '年間 : ',
                      style: TextStyle(fontSize: 20.sp),
                    ),
                    Text(
                      snapshot[1][0].toString(),
                      style: TextStyle(fontSize: 20.sp),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 130.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '月間 : ',
                    style: TextStyle(fontSize: 20.sp),
                  ),
                  Text(
                    snapshot[1][1].toString(),
                    style: TextStyle(fontSize: 20.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
              final id = await setDateProvider(ref, selectedDay);
              Navigator.of(context).push<dynamic>(
                TrainingLogPage.route(id: id),
              );
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
    WidgetRef ref) async {
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

Future<int> setDateProvider(WidgetRef ref, DateTime selectedDay) async {
  final dao = TrainingLogDao();
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

Future<List<int>> getTrainingAmount(int year, int month) async {
  final dao = TrainingLogDao();
  final yearIds = await dao.findByYear(year);
  final monthIds = await dao.findByMonth(year, month);
  int yearSum = 0;
  int monthSum = 0;
  for (int i = 0; i < yearIds.length; i++) {
    final training = await dao.findById(yearIds[i]);
    yearSum += training.ballQuantity;
  }
  for (int i = 0; i < monthIds.length; i++) {
    final training = await dao.findById(monthIds[i]);
    monthSum += training.ballQuantity;
  }

  return [yearSum, monthSum];
}

Future<List> getSnapshot(WidgetRef ref, DateTime focusedDay) async {
  final dao = DistanceByCountDao();
  await dao.initDistance();
  final events = await addEvents(ref);
  final trainingAmount =
      await getTrainingAmount(focusedDay.year, focusedDay.month);
  return [events, trainingAmount];
}

Future<List<Advice>> setAdviceList(WidgetRef ref) async {
  final dao = AdviceDao();
  final adviceList = await dao.findAll();
  final initCheckList = <bool>[];
  final check = ref.watch(checkboxListProvider);
  for (int i = 0; i < adviceList.length; i++) {
    initCheckList.add(false);
  }
  while (check.isEmpty) {
    await Future.delayed(Duration(milliseconds: 10));
    ref.read(checkboxListProvider.notifier).state = initCheckList;
  }
  return adviceList;
}
