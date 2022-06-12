import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_note/calendar/calendar_page_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

final indexProvider = StateProvider<int>((ref) => 0);

class TrainingLogPage extends HookConsumerWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (_) => const TrainingLogPage(),
    );
  }

  const TrainingLogPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime selectedDay = ref.watch(selectedProvider);
    List<bool> isSelected = ref.watch(isSelectedProvider);
    final pageTitle = Text(DateFormat('M/d (E)').format(selectedDay));
    return Scaffold(
      appBar: AppBar(title: pageTitle),
      body: Column(
        children: [
          isPractice(ref, isSelected),
          isSelected[0] == true ? ballQuantity() : score(),
          memo(),
        ],
      ),
    );
  }
}

Widget isPractice(WidgetRef ref, List<bool> isSelected) {
  return Padding(
    padding: EdgeInsets.all(10.r),
    child: Center(
      child: ToggleButtons(
        isSelected: isSelected,
        onPressed: (index) {
          List<bool> tmpList = [];
          for (int i = 0; i < isSelected.length; i++) {
            if (index == i) {
              tmpList.add(true);
            } else {
              tmpList.add(false);
            }
          }
          ref.read(isSelectedProvider.notifier).state = tmpList;
        },
        children: [
          Padding(
            padding: EdgeInsets.all(10.r),
            child: Text(
              '練習',
              style: TextStyle(fontSize: 20.sp),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.r),
            child: Text(
              'コース',
              style: TextStyle(fontSize: 20.sp),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget memo() {
  return Column(
    children: [
      Text(
        'メモ',
        style: TextStyle(fontSize: 15.sp),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 0),
        child: TextField(
          style: TextStyle(fontSize: 15.sp),
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: const InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget ballQuantity() {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '球数 : ',
            style: TextStyle(fontSize: 20.sp),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 0),
            child: SizedBox(
              width: 80.w,
              child: TextField(
                style: TextStyle(fontSize: 15.sp),
                keyboardType: TextInputType.number,
                // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

Widget score() {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'スコア : ',
            style: TextStyle(fontSize: 20.sp),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 0),
            child: SizedBox(
              width: 80.w,
              child: TextField(
                style: TextStyle(fontSize: 15.sp),
                keyboardType: TextInputType.number,
                // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
