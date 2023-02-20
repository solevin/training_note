import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_note/calendar/calendar_page.dart';
import 'package:training_note/ability/ability_page.dart';
import 'package:training_note/advice/advice_page.dart';
import 'package:training_note/target/target_page.dart';

final indexProvider = StateProvider<int>((ref) => 0);

Widget commonBottomNavigationBar(BuildContext context, WidgetRef ref) {
  final int count = ref.watch(indexProvider);
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.calendar_month),
        label: 'calendar',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.record_voice_over),
        label: 'advice',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.tag_faces),
        label: 'ability',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.military_tech),
        label: 'target',
      )
    ],
    onTap: (int index) {
      if (index != count) {
        ref.read(indexProvider.notifier).state = index;
        switch (index) {
          case 0:
            Navigator.of(context).push<dynamic>(
              CalendarPage.route(),
            );
            break;
          case 1:
            Navigator.of(context).push<dynamic>(
              AdvicePage.route(),
            );
            break;
          case 2:
            Navigator.of(context).push<dynamic>(
              AbilityPage.route(),
            );
            break;
          case 3:
            Navigator.of(context).push<dynamic>(
              TargetPage.route(),
            );
            break;
        }
      }
    },
    currentIndex: count,
  );
}