import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_note/calendar/calendar_page.dart';
import 'package:training_note/calendar/calendar_page_view.dart';
import 'package:training_note/db/training_log.dart';
import 'package:training_note/db/training_log_dao.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:training_note/home/home_page.dart';

final indexProvider = StateProvider<int>((ref) => 0);

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
    int id = ModalRoute.of(context)!.settings.arguments as int;
    DateTime selectedDay = ref.watch(selectedProvider);
    List<bool> isSelected = ref.watch(isSelectedProvider);
    String ballQuantity = ref.watch(ballQuantityProvider);
    String score = ref.watch(scoreProvider);
    String memo = ref.watch(memoProvider);
    String date = DateFormat('M/d (E)').format(selectedDay);
    final dao = TrainingLogDao();
    return Scaffold(
      appBar: AppBar(title: Text(date)),
      body: Column(
        children: [
          isPractice(ref, isSelected),
          isSelected[0] == true ? inputBallQuantity(ref) : inputScore(ref),
          inputMemo(ref),
          Padding(
            padding: EdgeInsets.all(8.r),
            child: GestureDetector(
              onTap: () async {
                int ballQuantityResult;
                try{
                  ballQuantityResult = int.parse(ballQuantity);
                }catch(e){
                  ballQuantityResult = 0;
                }
                int scoreResult;
                try{
                  scoreResult = int.parse(score);
                }catch(e){
                  scoreResult = 0;
                }
                final trainingLog = TrainingLog(
                  year: selectedDay.year,
                  month: selectedDay.month,
                  day: selectedDay.day,
                  ballQuantity: ballQuantityResult,
                  score: scoreResult,
                  memo: memo,
                );
                if (id >= 0) {
                  await dao.update(id, trainingLog);
                } else {
                  dao.create(trainingLog);
                }
                Navigator.of(context).push<dynamic>(
                  HomePage.route(),
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
