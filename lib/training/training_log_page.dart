import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:training_note/calendar/calendar_page_view.dart';
import 'package:training_note/training/display_image_page.dart';
import 'package:training_note/training/play_video_page.dart';
import 'package:training_note/training/result_page.dart';
import 'package:training_note/db/advice.dart';
import 'package:training_note/db/training_log.dart';
import 'package:training_note/db/training_log_dao.dart';
import 'package:training_note/db/media.dart';
import 'package:training_note/db/media_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:training_note/training/set_training_page_view.dart';
import 'package:training_note/training/training_log_page_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class TrainingLogPage extends HookConsumerWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (_) => const TrainingLogPage(),
    );
  }

  const TrainingLogPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime selectedDay = ref.watch(selectedDayProvider);
    String date = DateFormat('M/d (E)').format(selectedDay);
    final isTraining = ref.read(isTrainingProvider);
    return Scaffold(
      appBar: AppBar(title: Text(date)),
      body: SingleChildScrollView(
        child: Column(
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
            photoListWidget(ref),
            shootPhotoButton(context, ref),
            inputMemo(ref),
            finishTrainingButton(ref, context, selectedDay),
          ],
        ),
      ),
    );
  }
}

Widget photoListWidget(WidgetRef ref) {
  return Padding(
    padding: EdgeInsets.all(10.r),
    child: SizedBox(
      height: 100.h,
      child: SingleChildScrollView(
        child: Wrap(
          children: ref.watch(imageListProvider),
        ),
      ),
    ),
  );
}

Widget shootPhotoButton(BuildContext context, WidgetRef ref) {
  return Padding(
    padding: EdgeInsets.all(10.r),
    child: Container(
      height: 30.h,
      width: 50.w,
      color: Colors.green,
      child: GestureDetector(
        onTap: () async {
          showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                title: Text("タイトル"),
                children: <Widget>[
                  SimpleDialogOption(
                    onPressed: () => getImage(ref, context),
                    child: Text("写真"),
                  ),
                  SimpleDialogOption(
                    onPressed: () => getVideo(ref, context),
                    child: Text("動画"),
                  ),
                ],
              );
            },
          );
        },
      ),
    ),
  );
}

Future<void> saveMedia(String type, String path, DateTime selectedDay) async {
  final dao = MediaDao();
  final target = Media(
    type: type,
    year: selectedDay.year,
    month: selectedDay.month,
    day: selectedDay.day,
    path: path,
  );
  await dao.create(target);
}

Future<void> getImage(WidgetRef ref, BuildContext context) async {
  final picker = ImagePicker();
  try {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile == null) {
      return;
    }
    await saveMedia('image', pickedFile.path, ref.watch(selectedDayProvider));
    final newImage = newImageWidget(ref, pickedFile.path);
    final tmpList = ref.watch(imageListProvider);
    tmpList.add(newImage);
    ref.read(imageListProvider.notifier).state = [...tmpList];
    Navigator.pop(context);
  } catch (e) {
    print('Failed to pick image: $e');
  }
}

Future<void> getVideo(WidgetRef ref, BuildContext context) async {
  final picker = ImagePicker();
  try {
    final pickedFile = await picker.getVideo(source: ImageSource.camera);
    if (pickedFile == null) {
      return;
    }
    final pickedVideo = File(pickedFile.path);
    await saveMedia('video', pickedFile.path, ref.watch(selectedDayProvider));
    final thumbNail = await getThumbnail(pickedFile.path);
    final newVideo = newVideoWidget(ref, pickedFile.path, thumbNail);
    final tmpList = ref.watch(imageListProvider);
    tmpList.add(newVideo);
    ref.read(imageListProvider.notifier).state = [...tmpList];
    Navigator.pop(context);
  } catch (e) {
    print('Failed to pick image: $e');
  }
}

Future<Widget> getThumbnail(String path) async {
  final bytes = await VideoThumbnail.thumbnailData(
    video: path,
    imageFormat: ImageFormat.JPEG,
    quality: 25,
  );
  final image = Image.memory(bytes!);
  return Stack(
    children: [
      image,
      const Icon(Icons.play_circle_filled_sharp),
    ],
  );
}

Widget inputMemo(WidgetRef ref) {
  String text = ref.read(memoProvider);
  ScrollController _scrollController = ScrollController();
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
        child: Scrollbar(
          controller: _scrollController,
          child: TextField(
            scrollController: _scrollController,
            style: TextStyle(fontSize: 15.sp),
            keyboardType: TextInputType.multiline,
            maxLines: 5,
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
          dao.create(trainingLog);
        }
        showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text("練習を終了しますか？"),
              actions: <Widget>[
                CupertinoDialogAction(
                  onPressed: () {
                    Navigator.of(context).push<dynamic>(
                      ResultPage.route(),
                    );
                  },
                  child: Text("終了する"),
                ),
                CupertinoDialogAction(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("続ける"),
                ),
              ],
            );
          },
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

Widget newImageWidget(WidgetRef ref, String imagePath) {
  return Padding(
    padding: EdgeInsets.all(8.r),
    child: SizedBox(
      height: 100.h,
      child: Builder(builder: (context) {
        return GestureDetector(
          child: Image.file(File(imagePath)),
          onTap: () {
            ref.read(imageFileProvider.notifier).state = File(imagePath);
            Navigator.of(context).push<dynamic>(
              DisplayImagePage.route(),
            );
          },
        );
      }),
    ),
  );
}

Widget newVideoWidget(WidgetRef ref, String videoPath, Widget thumbNail) {
  return Padding(
    padding: EdgeInsets.all(8.r),
    child: SizedBox(
      height: 100.h,
      child: Builder(builder: (context) {
        return GestureDetector(
          child: thumbNail,
          onTap: () {
            ref.read(videoFileProvider.notifier).state = File(videoPath);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PlayVideoPage(File(videoPath))),
            );
          },
        );
      }),
    ),
  );
}
