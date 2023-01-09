import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_note/calendar/calendar_page.dart';
import 'package:training_note/calendar/calendar_page_view.dart';
import 'package:training_note/training/display_image_page.dart';
import 'package:training_note/training/play_video_page.dart';
import 'package:training_note/db/advice.dart';
import 'package:training_note/db/training_log.dart';
import 'package:training_note/db/training_log_dao.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:training_note/training/training_log_page.dart';
import 'package:training_note/training/set_training_page_view.dart';
import 'package:training_note/training/training_log_page_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:share/share.dart';

class ResultPage extends HookConsumerWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (_) => const ResultPage(),
    );
  }

  const ResultPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime selectedDay = ref.watch(selectedDayProvider);
    String date = DateFormat('M/d (E)').format(selectedDay);
    return Scaffold(
      appBar: AppBar(title: Text(date)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '練習お疲れ様でした',
              style: TextStyle(fontSize: 20.sp),
            ),
            photoListWidget(ref),
            shareButton(context, ref),
            finishTrainingButton(ref, context, selectedDay),
          ],
        ),
      ),
    );
  }
}

Widget shareButton(BuildContext context, WidgetRef ref) {
  return Container(
      padding: EdgeInsets.all(8.r),
      height: 30.h,
      width: 80.h,
      child: GestureDetector(
        onTap: () async {
          // await Share.shareFiles([imagePath]);
          showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  title: const Text("共有"),
                  children: <Widget>[
                    SimpleDialogOption(
                      onPressed: () => getImage(ref, context),
                      child: const Text("写真・動画あり"),
                    ),
                    SimpleDialogOption(
                      onPressed: () => Share.share(''),
                      child: const Text("写真・動画なし"),
                    ),
                  ],
                );
              });
        },
        child: Text(
          'share',
          style: TextStyle(fontSize: 10.sp),
        ),
      ));
}

Widget finishTrainingButton(
    WidgetRef ref, BuildContext context, DateTime selectedDay) {
  final id = ref.watch(idProvider);
  String ballQuantity = ref.watch(ballQuantityProvider);
  String score = ref.watch(scoreProvider);
  String memo = ref.watch(memoProvider);
  final dao = TrainingLogDao();
  int isGame = 1;

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
          isGame = 0;
        } else {
          isGame = 1;
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (prefs.getInt('score') == null ||
              prefs.getInt('score')! > int.parse(score)) {
            prefs.setInt('bestScore', int.parse(score));
          }
        }
        final trainingLog = TrainingLog(
          year: selectedDay.year,
          month: selectedDay.month,
          day: selectedDay.day,
          ballQuantity: ballQuantityResult,
          score: scoreResult,
          isGame: isGame,
          memo: memo,
        );
        if (id >= 0) {
          await dao.update(id, trainingLog);
        } else {
          await dao.create(trainingLog);
        }
        Navigator.of(context).push<dynamic>(
          ResultPage.route(),
        );
      },
      child: Container(
        height: 30.h,
        width: 80.w,
        color: Colors.blue,
        child: Center(
          child: Text(
            'finish',
            style: TextStyle(fontSize: 20.sp, color: Colors.white),
          ),
        ),
      ),
    ),
  );
}
