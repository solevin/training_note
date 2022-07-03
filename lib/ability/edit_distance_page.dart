import 'package:flutter/material.dart';
import 'package:training_note/ability/edit_distance_view.dart';
import 'package:training_note/db/distance_by_count.dart';
import 'package:training_note/db/distance_by_count_dao.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EditDistancePage extends HookConsumerWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (_) => const EditDistancePage(),
      settings: const RouteSettings(),
    );
  }

  const EditDistancePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<bool> isSelected = ref.watch(isSelectedProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit',
          style: TextStyle(fontSize: 20.sp),
        ),
      ),
      body: FutureBuilder(
        future: getDistanceList(),
        builder:
            (BuildContext context, AsyncSnapshot<List<List<int>>> snapshot) {
          if (snapshot.hasData) {
            final index = isSelected.indexOf(true);
            return Column(
              children: [
                selectKind(ref, isSelected),
                selectEditWidget(index, ref, snapshot.data![index]),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey)),
            );
          }
        },
      ),
    );
  }
}

Widget selectKind(WidgetRef ref, List<bool> isSelected) {
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
            padding: EdgeInsets.all(8.r),
            child: Text(
              'ウッド',
              style: TextStyle(fontSize: 15.sp),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.r),
            child: Text(
              'ユーティリティ',
              style: TextStyle(fontSize: 15.sp),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.r),
            child: Text(
              'アイアン',
              style: TextStyle(fontSize: 15.sp),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.r),
            child: Text(
              'ウェッジ',
              style: TextStyle(fontSize: 15.sp),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget selectEditWidget(int select, WidgetRef ref, List<int> dinstanceList) {
  switch (select) {
    case 0:
      return Center(child: editWood(ref, dinstanceList));
    case 1:
      return editUt(ref, dinstanceList);
    case 2:
      return editIron(ref, dinstanceList);
    case 3:
      return editWedge(ref, dinstanceList);
    default:
      return const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white));
  }
}

Widget editWood(WidgetRef ref, List<int> dinstanceList) {
  return Column(
    children: [
      inputEachClub(ref, dinstanceList, 0, 0),
      inputEachClub(ref, dinstanceList, 1, 0),
      inputEachClub(ref, dinstanceList, 2, 0),
      inputEachClub(ref, dinstanceList, 3, 0),
      inputEachClub(ref, dinstanceList, 4, 0),
      inputEachClub(ref, dinstanceList, 5, 0),
    ],
  );
}

Widget editUt(WidgetRef ref, List<int> dinstanceList) {
  return Column(
    children: [
      inputEachClub(ref, dinstanceList, 0, 1),
      inputEachClub(ref, dinstanceList, 1, 1),
      inputEachClub(ref, dinstanceList, 2, 1),
      inputEachClub(ref, dinstanceList, 3, 1),
      inputEachClub(ref, dinstanceList, 4, 1),
    ],
  );
}

Widget editIron(WidgetRef ref, List<int> dinstanceList) {
  return Column(
    children: [
      inputEachClub(ref, dinstanceList, 0, 2),
      inputEachClub(ref, dinstanceList, 1, 2),
      inputEachClub(ref, dinstanceList, 2, 2),
      inputEachClub(ref, dinstanceList, 3, 2),
      inputEachClub(ref, dinstanceList, 4, 2),
      inputEachClub(ref, dinstanceList, 5, 2),
      inputEachClub(ref, dinstanceList, 6, 2),
    ],
  );
}

Widget editWedge(WidgetRef ref, List<int> dinstanceList) {
  return Column(
    children: [
      inputEachClub(ref, dinstanceList, 0, 3),
      inputEachClub(ref, dinstanceList, 1, 3),
      inputEachClub(ref, dinstanceList, 2, 3),
      inputEachClub(ref, dinstanceList, 3, 3),
    ],
  );
}

Widget inputEachClub(
    WidgetRef ref, List<int> dinstanceList, int num, int kind) {
  final kindList = ['W', 'U', 'I', 'W'];
  final woodNums = [1, 3, 4, 5, 7, 9];
  final utNums = [3, 4, 5, 6, 7];
  final ironNums = [3, 4, 5, 6, 7, 8, 9];
  final wedgeNums = ['P', 'A', 'S', 'L'];
  String clubName = '';
  switch (kind) {
    case 0:
      clubName = '${woodNums[num]}${kindList[kind]}';
      break;
    case 1:
      clubName = '${utNums[num]}${kindList[kind]}';
      break;
    case 2:
      clubName = '${ironNums[num]}${kindList[kind]}';
      break;
    case 3:
      clubName = '${wedgeNums[num]}${kindList[kind]}';
      break;
  }
  return Padding(
    padding: EdgeInsets.all(8.r),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 15.w, 0),
          child: Text(
            clubName,
            style: TextStyle(fontSize: 20.sp),
          ),
        ),
        SizedBox(
          width: 100.w,
          child: TextField(
            style: TextStyle(fontSize: 15.sp),
            keyboardType: TextInputType.number,
            controller: TextEditingController(text: dinstanceList[num].toString()),
            decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            onChanged: (text) {
              dinstanceList[num] = int.parse(text);
              switch (kind) {
                case 0:
                  ref.read(woodDistanceProvider.notifier).state = dinstanceList;
                  break;
                case 1:
                  ref.read(utDistanceProvider.notifier).state = dinstanceList;
                  break;
                case 2:
                  ref.read(ironDistanceProvider.notifier).state = dinstanceList;
                  break;
                case 3:
                  ref.read(wedgeDistanceProvider.notifier).state = dinstanceList;
                  break;
              }
            },
          ),
        ),
      ],
    ),
  );
}

Future<List<List<int>>> getDistanceList() async {
  final dao = DistanceByCountDao();
  List<List<int>> distanceList = [];
  for (int i = 0; i < 4; i++) {
    final tmpIdList = await dao.findBykind(i);
    List<int> tmpDistanceList = [];
    for (int j = 0; j < tmpIdList.length; j++) {
      final tmp = await dao.findById(tmpIdList[j]);
      tmpDistanceList.add(tmp.distance);
    }
    distanceList.add(tmpDistanceList);
  }
  return distanceList;
}
