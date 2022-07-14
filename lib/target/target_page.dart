import 'package:flutter/material.dart';
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
            FutureBuilder(
              future: setTargetList(ref, context),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
                if (snapshot.hasData) {
                  return SingleChildScrollView(
                    child: SizedBox(
                        height: 200.h,
                        child: ListView(children: snapshot.data!)),
                  );
                } else {
                  return const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  );
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: commonBottomNavigationBar(context, ref),
    );
  }
}

Future<DateTime> selectDate(BuildContext context) async {
  final selected = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.utc(2020, 1, 1),
    lastDate: DateTime.utc(2050, 12, 31),
  );
  if (selected != null) {
    return selected;
  } else {
    return DateTime.now();
  }
}

Widget eachTarget(TargetLog target, WidgetRef ref) {
  if (target.isAchieved == 1) {
    ref.read(isAchievedProvider.notifier).state = true;
  }
  bool isAchieved = ref.watch(isAchievedProvider);
  return Padding(
    padding: EdgeInsets.all(8.r),
    child: Row(
      children: [
        Checkbox(
          activeColor: Colors.blue,
          value: isAchieved,
          onChanged: (value) {
            ref.read(isAchievedProvider.notifier).state = value!;
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

Future<List<Widget>> setTargetList(WidgetRef ref, BuildContext context) async {
  List<Widget> targetList = [];
  final dao = TargetLogDao();
  final targetLogList = await dao.findAll();
  for (int i = 0; i < targetLogList.length; i++) {
    targetList.add(eachTarget(targetLogList[i], ref));
  }
  targetList.add(addTargetButton(context));
  return targetList;
}

Widget addTargetButton(BuildContext context) {
  return Container(
    height: 50.h,
    width: 60.w,
    color: Colors.amber,
    child: GestureDetector(
      child: const Icon(Icons.add),
      onTap: () async {
      },
    ),
  );
}
