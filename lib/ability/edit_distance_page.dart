import 'package:flutter/material.dart';
import 'package:training_note/ability/ability_page.dart';
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
    List<bool> isSelected = ref.watch(isSelectedClubProvider);
    List<int> woodDistance = ref.watch(woodDistanceProvider);
    List<int> utDistance = ref.watch(utDistanceProvider);
    List<int> ironDistance = ref.watch(ironDistanceProvider);
    List<int> wedgeDistance = ref.watch(wedgeDistanceProvider);
    final index = isSelected.indexOf(true);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Edit',
          style: TextStyle(fontSize: 20.sp),
        ),
      ),
      body: Column(
        children: [
          selectKind(ref, isSelected),
          selectEditWidget(
            index,
            ref,
            woodDistance,
            utDistance,
            ironDistance,
            wedgeDistance,
          ),
          Padding(
            padding: EdgeInsets.all(15.h),
            child: Container(
              height: 35.h,
              width: 60.w,
              color: Colors.blue,
              child: GestureDetector(
                onTap: (() async {
                  final dao = DistanceByCountDao();
                  await dao.updateAll(
                      woodDistance, utDistance, ironDistance, wedgeDistance);
                  Navigator.of(context).push<dynamic>(
                    AbilityPage.route(),
                  );
                }),
                child: Center(
                  child: Text(
                    '保存',
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.white,
                    ),
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
          ref.read(isSelectedClubProvider.notifier).state = tmpList;
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

Widget selectEditWidget(int select, WidgetRef ref, List<int> woodDistance,
    List<int> utDistance, List<int> ironDistance, List<int> wedgeDistance) {
  switch (select) {
    case 0:
      return Center(child: editWood(ref, woodDistance));
    case 1:
      return editUt(ref, utDistance);
    case 2:
      return editIron(ref, ironDistance);
    case 3:
      return editWedge(ref, wedgeDistance);
    default:
      return const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white));
  }
}

Widget editWood(WidgetRef ref, List<int> distanceList) {
  return Column(
    children: [
      inputEachClub(ref, 0, 0, distanceList),
      inputEachClub(ref, 1, 0, distanceList),
      inputEachClub(ref, 2, 0, distanceList),
      inputEachClub(ref, 3, 0, distanceList),
      inputEachClub(ref, 4, 0, distanceList),
      inputEachClub(ref, 5, 0, distanceList),
    ],
  );
}

Widget editUt(WidgetRef ref, List<int> distanceList) {
  return Column(
    children: [
      inputEachClub(ref, 0, 1, distanceList),
      inputEachClub(ref, 1, 1, distanceList),
      inputEachClub(ref, 2, 1, distanceList),
      inputEachClub(ref, 3, 1, distanceList),
      inputEachClub(ref, 4, 1, distanceList),
    ],
  );
}

Widget editIron(WidgetRef ref, List<int> distanceList) {
  return Column(
    children: [
      inputEachClub(ref, 0, 2, distanceList),
      inputEachClub(ref, 1, 2, distanceList),
      inputEachClub(ref, 2, 2, distanceList),
      inputEachClub(ref, 3, 2, distanceList),
      inputEachClub(ref, 4, 2, distanceList),
      inputEachClub(ref, 5, 2, distanceList),
      inputEachClub(ref, 6, 2, distanceList),
    ],
  );
}

Widget editWedge(WidgetRef ref, List<int> distanceList) {
  return Column(
    children: [
      inputEachClub(ref, 0, 3, distanceList),
      inputEachClub(ref, 1, 3, distanceList),
      inputEachClub(ref, 2, 3, distanceList),
      inputEachClub(ref, 3, 3, distanceList),
    ],
  );
}

Widget inputEachClub(WidgetRef ref, int num, int kind, List<int> distanceList) {
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
            controller:
                TextEditingController(text: distanceList[num].toString()),
            decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            onChanged: (text) {
              List<int> tmpList = distanceList;
              try {
                tmpList[num] = int.parse(text);
              } catch (e) {
                tmpList[num] = distanceList[num];
              }
              switch (kind) {
                case 0:
                  ref.read(woodDistanceProvider.notifier).state = tmpList;
                  break;
                case 1:
                  ref.read(utDistanceProvider.notifier).state = tmpList;
                  break;
                case 2:
                  ref.read(ironDistanceProvider.notifier).state = tmpList;
                  break;
                case 3:
                  ref.read(wedgeDistanceProvider.notifier).state = tmpList;
                  break;
              }
            },
          ),
        ),
      ],
    ),
  );
}
