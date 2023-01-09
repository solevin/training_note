import 'dart:io';

import 'package:flutter/material.dart';
import 'package:training_note/db/advice.dart';
import 'package:intl/intl.dart';
import 'package:training_note/calendar/calendar_page_view.dart';
import 'package:training_note/db/advice_dao.dart';
import 'package:training_note/db/media.dart';
import 'package:training_note/db/media_dao.dart';
import 'package:training_note/training/set_training_page_view.dart';
import 'package:training_note/training/training_log_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:training_note/training/training_log_page_view.dart';

class SetTrainingPage extends HookConsumerWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (_) => const SetTrainingPage(),
    );
  }

  const SetTrainingPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isTraining = ref.watch(isTrainingProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Advice',
          style: TextStyle(fontSize: 20.sp),
        ),
      ),
      body: Column(
        children: [
          isPractice(ref, isTraining),
          SingleChildScrollView(
            child: SizedBox(
              height: 200.h,
              child: ListView(
                children: adviceWidgetList(ref),
              ),
            ),
          ),
          Container(
            width: 30.w,
            height: 30.h,
            color: Colors.green,
            child: GestureDetector(
              onTap: () {
                decideAdvice(ref);
                initAchieveCheckboxList(ref);
                setMedia(ref);
                Navigator.of(context).push<dynamic>(
                  TrainingLogPage.route(),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

List<Widget> adviceWidgetList(WidgetRef ref) {
  final result = <Widget>[];
  final adviceList = ref.watch(adviceListProvider);
  for (int i = 0; i < adviceList.length; i++) {
    // final tmpWidget = await adviceWidget(adviceList[i], isCheckedList[i],ref);
    final tmpWidget = adviceWidget(adviceList[i], ref, i);
    result.add(tmpWidget);
  }
  return result;
}

Widget adviceWidget(Advice advice, WidgetRef ref, int index) {
  final isCheckedList = ref.watch(checkboxListProvider);
  return Padding(
    padding: EdgeInsets.fromLTRB(10.w, 5.h, 0, 0),
    child: Row(
      children: [
        Checkbox(
          value: isCheckedList[index],
          onChanged: (value) {
            var tmp = isCheckedList;
            tmp[index] = value!;
            ref.read(checkboxListProvider.notifier).state = [...tmp];
          },
        ),
        Text(
          advice.contents,
          style: TextStyle(fontSize: 20.sp),
        )
      ],
    ),
  );
}

Future<List<Advice>> setAdviceList(WidgetRef ref) async {
  final dao = AdviceDao();
  final adviceList = await dao.findAll();
  final initCheckList = <bool>[];
  for (int i = 0; i < adviceList.length; i++) {
    initCheckList.add(false);
  }
  // ref.read(checkboxListProvider.notifier).state = [...initCheckList];
  final check = ref.watch(checkboxListProvider);
  if (adviceList.length > check.length) {
    // print('object');
  }
  while (adviceList.length > check.length) {
    await Future.delayed(const Duration(milliseconds: 20));
    ref.read(checkboxListProvider.notifier).state = [...initCheckList];
  }
  // print('1');
  return adviceList;
}

Widget isPractice(WidgetRef ref, bool isTraining) {
  List<bool> isSelected = [];
  if (isTraining) {
    isSelected = [true, false];
  } else {
    isSelected = [false, true];
  }
  return Padding(
    padding: EdgeInsets.all(10.r),
    child: Center(
      child: ToggleButtons(
        isSelected: isSelected,
        onPressed: (index) {
          if (index == 0) {
            ref.read(isTrainingProvider.notifier).state = true;
          } else {
            ref.read(isTrainingProvider.notifier).state = false;
          }
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

void decideAdvice(WidgetRef ref) {
  final checkboxList = ref.watch(checkboxListProvider);
  List<Advice> decideAdviceList = [];
  final adviceList = ref.watch(adviceListProvider);
  for (int i = 0; i < checkboxList.length; i++) {
    if (checkboxList[i]) {
      decideAdviceList.add(adviceList[i]);
    }
  }
  ref.read(decideAdviceListProvider.notifier).state = [...decideAdviceList];
}

void initAchieveCheckboxList(WidgetRef ref) {
  final decideAdviceList = ref.watch(decideAdviceListProvider);
  final checkboxList = <bool>[];
  for (int i = 0; i < decideAdviceList.length; i++) {
    checkboxList.add(false);
  }
  ref.read(achieveCheckboxListProvider.notifier).state = [...checkboxList];
}

void setMedia(WidgetRef ref) async {
  final dao = MediaDao();
  final selectedDay = ref.watch(selectedDayProvider);
  final idList = await dao.findByDate(
      selectedDay.year, selectedDay.month, selectedDay.day);
  final mediaWidgetList = <Widget>[];
  for (int i = 0; i < idList.length; i++) {
    final tmpMedia = await dao.findById(idList[i]);
    if (tmpMedia.type == 'image') {
      mediaWidgetList.add(newImageWidget(ref, tmpMedia.path));
    } else if (tmpMedia.type == 'video') {
      final thumbNail = await getThumbnail(tmpMedia.path);
      mediaWidgetList.add(newVideoWidget(ref, tmpMedia.path, thumbNail));
    }
  }
}
