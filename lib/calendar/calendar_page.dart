import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_note/calendar/training_log_page.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final focusProvider = StateProvider<DateTime>((ref) => DateTime.now());
final selectedProvider = StateProvider<DateTime>((ref) => DateTime.now());

Widget calendarPage(BuildContext context, WidgetRef ref) {
  DateTime focusedDay = ref.watch(focusProvider);
  DateTime selectedDay = ref.watch(selectedProvider);
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
          selectedDayPredicate: (day) {
            return isSameDay(selectedDay, day);
          },
          onDaySelected: (newSelectedDay, newFocusedDay) {
            if (!isSameDay(selectedDay, newSelectedDay)) {
              ref.read(selectedProvider.notifier).state = newSelectedDay;
              // ref.read(focusProvider.notifier).state = newFocusedDay;
            } else {
              Navigator.of(context).push<dynamic>(
                TrainingLogPage.route(),
              );
            }
          },
        ),
      ),
    ],
  );
}
