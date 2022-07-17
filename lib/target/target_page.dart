import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:training_note/db/target_log.dart';
import 'package:training_note/db/target_log_dao.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_note/home/home_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:training_note/target/target_page_view.dart';

class TargetPage extends HookConsumerWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (_) => const TargetPage(),
    );
  }

  const TargetPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visible = ref.watch(isVisibleProvider);
    final display = ref.watch(isDisplayProvider);
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Target',
            style: TextStyle(fontSize: 20.sp),
          ),
          automaticallyImplyLeading: false),
      body: Padding(
        padding: EdgeInsets.fromLTRB(0, 10.h, 0, 0),
        child: Column(
          // children: [
          //   Row(
          //     children: [],
          //   ),
          //   Padding(
          //     padding: EdgeInsets.all(8.r),
          //     child: Center(
          //       child: Text(
          //         '年間目標',
          //         style: TextStyle(fontSize: 20.sp),
          //       ),
          //     ),
          //   ),
          //   Padding(
          //     padding: EdgeInsets.all(8.r),
          //     child: Center(
          //       child: Text(
          //         '月間目標',
          //         style: TextStyle(fontSize: 20.sp),
          //       ),
          //     ),
          //   ),
          // ],
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '未達成のみ表示',
                  style: TextStyle(fontSize: 20.sp),
                ),
                Switch(
                  value: display,
                  onChanged: (value) {
                    ref.read(isDisplayProvider.notifier).state = value;
                  },
                ),
              ],
            ),
            FutureBuilder(
              future: setTargetList(ref, context),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.hasData) {
                  final targetList = ref.watch(targetListProvider);
                  return Stack(
                    children: [
                      SingleChildScrollView(
                        child: SizedBox(
                          height: 400.h,
                          child: ListView(children: targetList),
                        ),
                      ),
                      Visibility(
                        visible: visible,
                        child: addTargetWidget(ref, context),
                      ),
                    ],
                  );
                } else {
                  return const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  );
                }
              },
            ),
            addTargetButton(ref, context)
          ],
        ),
      ),
      bottomNavigationBar: commonBottomNavigationBar(context, ref),
    );
  }
}

Future<String> selectDate(BuildContext context) async {
  final selected = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.utc(2020, 1, 1),
    lastDate: DateTime.utc(2050, 12, 31),
  );
  if (selected != null) {
    return DateFormat('yyyy/M/d').format(selected);
  } else {
    return DateFormat('yyyy/M/d').format(DateTime.now());
  }
}

Widget eachTarget(TargetLog target, WidgetRef ref, int id) {
  final isAchievedProvider = StateProvider.autoDispose<bool>((ref) => false);
  if (target.isAchieved == 1) {
    ref.read(isAchievedProvider.notifier).state = true;
  }
  bool isAchieved = ref.watch(isAchievedProvider);
  return Padding(
    padding: EdgeInsets.all(8.r),
    child: Row(
      // crossAxisAlignment:CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Checkbox(
          activeColor: Colors.blue,
          value: isAchieved,
          onChanged: (value) async {
            ref.read(isAchievedProvider.notifier).state = value!;
            final achieve = target.isAchieved == 1 ? 0 : 1;
            final newTarget = TargetLog(
              contents: target.contents,
              deadLine: target.deadLine,
              isAchieved: achieve,
            );
            final dao = TargetLogDao();
            dao.update(id, newTarget);
          },
        ),
        Text(
          target.contents,
          style: TextStyle(fontSize: 20.sp),
        ),
        Text(
          target.deadLine,
          style: TextStyle(fontSize: 20.sp),
        ),
      ],
    ),
  );
}

Future<bool> setTargetList(WidgetRef ref, BuildContext context) async {
  List<Widget> targetList = [];
  final dao = TargetLogDao();
  final targetLogIds = await dao.findAllIds();
  final isDisplay = ref.watch(isDisplayProvider);
  for (int i = 0; i < targetLogIds.length; i++) {
    final target = await dao.findById(targetLogIds[i]);
    if (isDisplay == true) {
      if (target.isAchieved == 0) {
        targetList.add(eachTarget(target, ref, targetLogIds[i]));
      }
    } else {
      targetList.add(eachTarget(target, ref, targetLogIds[i]));
    }
  }
  ref.read(targetListProvider.notifier).state = targetList;
  ref.watch(targetListProvider);
  return true;
}

Widget addTargetButton(WidgetRef ref, BuildContext context) {
  return Container(
    height: 50.h,
    width: 60.w,
    color: Colors.amber,
    child: GestureDetector(
      child: const Icon(Icons.add),
      onTap: () async {
        ref.read(contentsProvider.notifier).state = '';
        ref.read(isVisibleProvider.notifier).state = true;
      },
    ),
  );
}

Widget addTargetWidget(WidgetRef ref, BuildContext context) {
  final contents = ref.watch(contentsProvider);
  final deadLine = ref.watch(dateProvider);
  return Center(
    child: Container(
      height: 175.h,
      width: 250.w,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2.0),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.r),
            child: TextField(
              style: TextStyle(fontSize: 15.sp),
              // keyboardType: TextInputType.number,
              // controller:
              //     TextEditingController(text: distanceList[num].toString()),
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              onChanged: (text) {
                ref.read(contentsProvider.notifier).state = text;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.r),
            child: Container(
              height: 40.h,
              width: 80.w,
              color: Colors.green,
              child: GestureDetector(
                onTap: () async {
                  final date = await selectDate(context);
                  ref.read(dateProvider.notifier).state = date;
                },
                child: Center(
                  child: Text(
                    'date',
                    style: TextStyle(fontSize: 20.sp, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.r),
            child: Container(
              height: 40.h,
              width: 80.w,
              color: Colors.blue,
              child: ElevatedButton(
                onPressed: contents.isEmpty
                    ? null
                    : () async {
                        final target = TargetLog(
                          contents: contents,
                          deadLine: deadLine,
                          isAchieved: 0,
                        );
                        final dao = TargetLogDao();
                        await dao.create(target);
                        ref.read(isVisibleProvider.notifier).state = false;
                      },
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
    ),
  );
}
