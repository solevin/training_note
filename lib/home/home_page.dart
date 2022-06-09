import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:training_note/ability/ability_page.dart';
import 'package:training_note/advice/advice_page.dart';
import 'package:training_note/calendar/calendar.dart';
import 'package:training_note/target/target_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final indexProvider = StateProvider<int>((ref) => 0);

class HomePage extends HookConsumerWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (_) => const HomePage(),
    );
  }

  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime focusedDay = DateTime.now();
    final int count = ref.watch(indexProvider);
    final List<Widget> pages = [
      calendarPage(),
      advicePage(),
      abilityPage(),
      targetPage()
    ];
    final List<String> titles = ['Calendar', 'Advice', 'Ability', 'Target'];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          titles[count],
          style: TextStyle(fontSize: 20.sp),
        ),
      ),
      body: pages[count],
      bottomNavigationBar: BottomNavigationBar(
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
          ref.read(indexProvider.notifier).state = index;
        },
        currentIndex: count,
      ),
    );
  }
}
