import 'package:flutter/material.dart';
import 'package:training_note/db/advice.dart';
import 'package:intl/intl.dart';
import 'package:training_note/db/advice_dao.dart';
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
        // automaticallyImplyLeading: false,
      ),
      body: FutureBuilder(
        future: setAdviceList(ref),
        builder: (BuildContext context, AsyncSnapshot<List<Advice>> snapshot) {
          if (snapshot.hasData) {
            final adviceList = snapshot.data!;
            return Column(
              children: [
                isPractice(ref, isTraining),
                SingleChildScrollView(
                  child: SizedBox(
                    height: 200.h,
                    child: ListView(
                      children: adviceWidgetList(ref, adviceList),
                    ),
                  ),
                ),
                Container(
                  width: 30.w,
                  height: 30.h,
                  color: Colors.green,
                  child: GestureDetector(
                    onTap: () {
                      decideAdvice(ref, adviceList);
                      initAchieveCheckboxList(ref);
                      Navigator.of(context).push<dynamic>(
                        TrainingLogPage.route(),
                      );
                    },
                  ),
                )
              ],
            );
          } else {
            return const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            );
          }
        },
      ),
    );
  }
}

List<Widget> adviceWidgetList(WidgetRef ref, List<Advice> adviceList) {
  final result = <Widget>[];
  for (int i = 0; i < adviceList.length; i++) {
    // final tmpWidget = await adviceWidget(adviceList[i], isCheckedList[i],ref);
    final tmpWidget = adviceWidget(adviceList[i], ref, i);
    result.add(tmpWidget);
  }
  return result;
}

// Future<Widget> adviceWidget(int id, bool isChecked,WidgetRef ref) async {
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
  final check = ref.watch(checkboxListProvider);
  for (int i = 0; i < adviceList.length; i++) {
    initCheckList.add(false);
  }
  while (check.isEmpty) {
    await Future.delayed(const Duration(milliseconds: 10));
    ref.read(checkboxListProvider.notifier).state = initCheckList;
  }
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

void decideAdvice(WidgetRef ref, List<Advice> adviceList) {
  final checkboxList = ref.read(checkboxListProvider);
  List<Advice> decideAdviceList = [];
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
