import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:training_note/db/advice.dart';
import 'package:training_note/db/advice_dao.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_note/home/home_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:training_note/advice/advice_page_view.dart';

class AdvicePage extends HookConsumerWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (_) => const AdvicePage(),
    );
  }

  const AdvicePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visible = ref.watch(isVisibleProvider);
    final display = ref.watch(isDisplayProvider);
    final int count = ref.watch(indexProvider);
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Advice',
            style: TextStyle(fontSize: 20.sp),
          ),
          automaticallyImplyLeading: false),
      body: Padding(
        padding: EdgeInsets.fromLTRB(0, 10.h, 0, 0),
        child: Column(
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
              future: setAdviceList(ref, context),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.hasData) {
                  final adviceList = ref.watch(adviceListProvider);
                  // ref.read(isDisplayProvider.notifier).state = true;
                  return Stack(
                    children: [
                      SingleChildScrollView(
                        child: SizedBox(
                          height: 400.h,
                          child: ListView(children: adviceList),
                        ),
                      ),
                      Visibility(
                        visible: visible,
                        child: addAdviceWidget(ref, context),
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
            addAdviceButton(ref, context)
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

Widget eachAdvice(Advice advice, WidgetRef ref, int id, int index) {
  if (advice.isAchieved == 1) {
    ref.read(isAchievedProvider.notifier).state[index] = true;
  }
  List<bool> isAchieved = ref.watch(isAchievedProvider);
  return Padding(
    padding: EdgeInsets.all(8.r),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Checkbox(
          activeColor: Colors.blue,
          value: isAchieved[index],
          onChanged: (value) async {
            print('change');
            print(value);
            print(isAchieved);
            isAchieved[index] = value!;
            ref.read(isAchievedProvider.notifier).state = isAchieved;
            final achieve = advice.isAchieved == 1 ? 0 : 1;
            final newAdvice = Advice(
              contents: advice.contents,
              date: advice.date,
              isAchieved: achieve,
              source: advice.source,
            );
            final dao = AdviceDao();
            dao.update(id, newAdvice);
          },
        ),
        Text(
          advice.contents,
          style: TextStyle(fontSize: 20.sp),
        ),
        Text(
          advice.source,
          style: TextStyle(fontSize: 20.sp),
        ),
        Text(
          advice.date,
          style: TextStyle(fontSize: 20.sp),
        ),
      ],
    ),
  );
}

Future<bool> setAdviceList(WidgetRef ref, BuildContext context) async {
  List<Widget> adviceList = [];
  final dao = AdviceDao();
  final adviceLogIds = await dao.findAllIds();
  final isDisplay = ref.watch(isDisplayProvider);
  int index = 0;
  ref.read(isAchievedProvider.notifier).state = [];
  for (int i = 0; i < adviceLogIds.length; i++) {
    final advice = await dao.findById(adviceLogIds[i]);
    if (isDisplay == true) {
      if (advice.isAchieved == 0) {
        final tmp = ref.watch(isAchievedProvider);
        tmp.add(false);
        ref.read(isAchievedProvider.notifier).state = tmp;
        adviceList.add(eachAdvice(advice, ref, adviceLogIds[i], index));
        index++;
      }
    } else {
      final tmp = ref.watch(isAchievedProvider);
      tmp.add(false);
      ref.read(isAchievedProvider.notifier).state = tmp;
      adviceList.add(eachAdvice(advice, ref, adviceLogIds[i], index));
      index++;
    }
  }
  ref.read(adviceListProvider.notifier).state = adviceList;
  ref.watch(adviceListProvider);
  return true;
}

Widget addAdviceButton(WidgetRef ref, BuildContext context) {
  return Container(
    height: 50.h,
    width: 60.w,
    color: Colors.amber,
    child: GestureDetector(
      child: const Icon(Icons.add),
      onTap: () async {
        ref.read(contentsProvider.notifier).state = '';
        ref.read(isVisibleProvider.notifier).state = true;
        ref.read(dateProvider.notifier).state =
            DateFormat('yyyy/M/d').format(DateTime.now());
      },
    ),
  );
}

Widget addAdviceWidget(WidgetRef ref, BuildContext context) {
  final contents = ref.watch(contentsProvider);
  final date = ref.watch(dateProvider);
  final source = ref.watch(sourceProvider);
  return Center(
    child: Container(
      height: 380.h,
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
            child: Text(
              'advice',
              style: TextStyle(fontSize: 20.sp),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(8.r),
              child: Text(
                'contents',
                style: TextStyle(fontSize: 15.sp),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.r),
            child: TextField(
              style: TextStyle(fontSize: 15.sp),
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
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(8.r),
              child: Text(
                'source',
                style: TextStyle(fontSize: 15.sp),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.r),
            child: TextField(
              style: TextStyle(fontSize: 15.sp),
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              onChanged: (text) {
                ref.read(sourceProvider.notifier).state = text;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  date,
                  style: TextStyle(fontSize: 20.sp),
                ),
                GestureDetector(
                  onTap: () async {
                    final date = await selectDate(context);
                    ref.read(dateProvider.notifier).state = date;
                  },
                  child: Center(
                    child: Container(
                      height: 40.r,
                      width: 40.r,
                      color: Colors.blue,
                      child: Icon(
                        Icons.calendar_month,
                        color: Colors.white,
                        size: 25.r,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.r),
            child: Container(
              height: 40.h,
              width: 100.w,
              color: Colors.blue,
              child: ElevatedButton(
                onPressed: contents.isEmpty
                    ? null
                    : () async {
                        final advice = Advice(
                          contents: contents,
                          date: date,
                          isAchieved: 0,
                          source: source,
                        );
                        final dao = AdviceDao();
                        await dao.create(advice);
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
          Padding(
            padding: EdgeInsets.all(8.r),
            child: Container(
              height: 40.h,
              width: 100.w,
              color: Colors.blue,
              child: ElevatedButton(
                onPressed: contents.isEmpty
                    ? null
                    : () async {
                        ref.read(isVisibleProvider.notifier).state = false;
                      },
                child: Center(
                  child: Text(
                    'cancel',
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
