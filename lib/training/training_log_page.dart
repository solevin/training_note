import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_note/calendar/calendar_page.dart';
import 'package:training_note/calendar/calendar_page_view.dart';
import 'package:training_note/training/set_training_page_view.dart';
import 'package:training_note/db/training_log.dart';
import 'package:training_note/db/training_log_dao.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrainingLogPage extends HookConsumerWidget {
  static Route<dynamic> route({
    required int id,
  }) {
    return MaterialPageRoute<dynamic>(
      builder: (_) => const TrainingLogPage(),
      settings: RouteSettings(arguments: id),
    );
  }

  const TrainingLogPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime selectedDay = ref.watch(selectedProvider);
    List<bool> isSelected = ref.watch(isSelectedProvider);
    String date = DateFormat('M/d (E)').format(selectedDay);
    return Scaffold(
      appBar: AppBar(title: Text(date)),
      body: Column(
        children: [
          isPractice(ref, isSelected),
          SizedBox(
            height: 530.h,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  isSelected[0] == true
                      ? inputBallQuantity(ref)
                      : inputScore(ref),
                  inputMemo(ref),
                  addTraininglogButton(ref, context, selectedDay),
                ],
              ),
            ),
          ),
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
  int id = ModalRoute.of(context)!.settings.arguments as int;
  String ballQuantity = ref.watch(ballQuantityProvider);
  String score = ref.watch(scoreProvider);
  String memo = ref.watch(memoProvider);
  final dao = TrainingLogDao();
  int game = 1;

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
          game = 0;
        } else {
          game = 1;
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
          game: game,
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

Widget todaysPointWidgetList(WidgetRef ref) {
  return ListView();
}

Widget eachTodaysPoint(WidgetRef ref) {
  return Container();
}
