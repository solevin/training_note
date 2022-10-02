import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_note/calendar/calendar_page.dart';
import 'package:training_note/calendar/calendar_page_view.dart';
import 'package:training_note/db/advice.dart';
import 'package:training_note/db/training_log.dart';
import 'package:training_note/db/training_log_dao.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:training_note/training/set_training_page_view.dart';
import 'package:training_note/training/training_log_page_view.dart';

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
    String date = DateFormat('M/d (E)').format(selectedDay);
    final isTraining = ref.read(isTrainingProvider);
    return Scaffold(
      appBar: AppBar(title: Text(date)),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(5.r),
            child: Text(
              '目標',
              style: TextStyle(fontSize: 20.sp),
            ),
          ),
          adviceListWidget(ref),
          isTraining == true ? inputBallQuantity(ref) : inputScore(ref),
          inputMemo(ref),
          addTraininglogButton(ref, context, selectedDay),
        ],
      ),
    );
  }
}

Widget inputMemo(WidgetRef ref) {
  String text = ref.read(memoProvider);
  return Column(
    children: [
      Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.fromLTRB(15.w, 0, 0, 5.h),
          child: Text(
            'メモ',
            style: TextStyle(fontSize: 20.sp),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 0),
        child: TextField(
          style: TextStyle(fontSize: 15.sp),
          keyboardType: TextInputType.multiline,
          maxLines: null,
          controller: TextEditingController(text: text),
          decoration: const InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
          onChanged: (text) {
            ref.read(memoProvider.notifier).state = text;
          },
        ),
      ),
    ],
  );
}

Widget inputBallQuantity(WidgetRef ref) {
  String text = ref.read(ballQuantityProvider).toString();
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
                controller: TextEditingController(text: text),
                // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                onChanged: (text) {
                  ref.read(ballQuantityProvider.notifier).state = text;
                },
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

Widget inputScore(WidgetRef ref) {
  String text = ref.read(scoreProvider).toString();
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
                controller: TextEditingController(text: text),
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                onChanged: (text) {
                  ref.read(scoreProvider.notifier).state = text;
                },
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

Widget addTraininglogButton(
    WidgetRef ref, BuildContext context, DateTime selectedDay) {
  // int id = ModalRoute.of(context)!.settings.arguments as int;
  final id = ref.watch(idProvider);
  String ballQuantity = ref.watch(ballQuantityProvider);
  String score = ref.watch(scoreProvider);
  String memo = ref.watch(memoProvider);
  final dao = TrainingLogDao();
  int isgame = 1;

  return Padding(
    padding: EdgeInsets.all(8.r),
    child: GestureDetector(
      onTap: () async {
        int ballQuantityResult;
        try {
          ballQuantityResult = int.parse(ballQuantity);
        } catch (e) {
          ballQuantityResult = 0;
        }
        int scoreResult;
        try {
          scoreResult = int.parse(score);
        } catch (e) {
          scoreResult = 0;
        }
        if (scoreResult <= 0) {
          scoreResult = 0;
          isgame = 0;
        } else {
          isgame = 1;
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (prefs.getInt('score') == null ||
              prefs.getInt('score')! > int.parse(score)) {
            prefs.setInt('bestscore', int.parse(score));
          }
        }
        final trainingLog = TrainingLog(
          year: selectedDay.year,
          month: selectedDay.month,
          day: selectedDay.day,
          ballQuantity: ballQuantityResult,
          score: scoreResult,
          isgame: isgame,
          memo: memo,
        );
        if (id >= 0) {
          await dao.update(id, trainingLog);
        } else {
          dao.create(trainingLog);
        }
        Navigator.of(context).push<dynamic>(
          CalendarPage.route(),
        );
      },
      child: Container(
        height: 30.h,
        width: 80.w,
        color: Colors.blue,
        child: Center(
          child: Text(
            'add',
            style: TextStyle(fontSize: 20.sp, color: Colors.white),
          ),
        ),
      ),
    ),
  );
}

Widget adviceListWidget(WidgetRef ref) {
  return SingleChildScrollView(
    child: SizedBox(
      height: 150.h,
      child: ListView(
        children: adviceListContents(ref),
      ),
    ),
  );
}

List<Widget> adviceListContents(WidgetRef ref) {
  final contentsList = <Widget>[];
  final decideAdviceList = ref.read(decideAdviceListProvider);
  for (int i = 0; i < decideAdviceList.length; i++) {
    final advice = decideAdviceList[i];
    contentsList.add(adviceContent(ref, advice, i));
  }
  return contentsList;
}

Widget adviceContent(WidgetRef ref, Advice advice, int index) {
  final isCheckedList = ref.watch(achieveCheckboxListProvider);
  return Center(
    child: Padding(
      padding: EdgeInsets.all(5.r),
      child: Row(
        children: [
          Checkbox(
              value: isCheckedList[index],
              onChanged: (value) {
                var tmp = isCheckedList;
                tmp[index] = value!;
                ref.read(achieveCheckboxListProvider.notifier).state = [...tmp];
              }),
          Text(
            advice.contents,
            style: TextStyle(fontSize: 20.sp),
          ),
        ],
      ),
    ),
  );
}
