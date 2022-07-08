import 'package:flutter/material.dart';
import 'package:training_note/db/distance_by_count_dao.dart';
import 'package:training_note/ability/edit_distance_page.dart';
import 'package:training_note/ability/edit_distance_view.dart';
import 'package:training_note/home/home_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AbilityPage extends HookConsumerWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (_) => const AbilityPage(),
    );
  }

  const AbilityPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Ability',
            style: TextStyle(fontSize: 20.sp),
          ),
          automaticallyImplyLeading: false),
      body: Column(
        children: [
          FutureBuilder(
            future: getBestScore(),
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ベストスコア : ',
                    style: TextStyle(fontSize: 20.sp),
                  ),
                  Text(
                    snapshot.hasData && snapshot.data! > 0
                        ? snapshot.data.toString()
                        : '-',
                    style: TextStyle(fontSize: 20.sp),
                  ),
                ],
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '飛距離 ',
                style: TextStyle(fontSize: 20.sp),
              ),
              Container(
                height: 25.h,
                width: 45.w,
                color: Colors.blue,
                child: GestureDetector(
                  onTap: (() async {
                    await getDistanceList(ref);
                    Navigator.of(context).push<dynamic>(
                      EditDistancePage.route(),
                    );
                  }),
                  child: Center(
                    child: Text(
                      'edit',
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          FutureBuilder(
            future: distanceWidgetList(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
              if (snapshot.hasData) {
                return SizedBox(
                  height: 300.h,
                  child: SingleChildScrollView(
                    child: Column(
                      children: snapshot.data!,
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: commonBottomNavigationBar(context, ref),
    );
  }
}

Future<int> getBestScore() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getInt('bestscore') != null) {
    return prefs.getInt('bestscore')!;
  } else {
    return 0;
  }
}

Future<List<Widget>> distanceWidgetList() async {
  final dao = DistanceByCountDao();
  final kinds = await dao.findAll();
  List<Widget> result = [];

  for (int i = 0; i < kinds.length; i++) {
    final tmpWidget = Padding(
        padding: EdgeInsets.all(8.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              kinds[i].club,
              style: TextStyle(fontSize: 20.sp),
            ),
            Text(
              ' : ',
              style: TextStyle(fontSize: 20.sp),
            ),
            Text(
              kinds[i].distance.toString(),
              style: TextStyle(fontSize: 20.sp),
            ),
          ],
        ));
    if (kinds[i].distance > 0) {
      result.add(tmpWidget);
    }
  }

  return result;
}

Future<List<List<int>>> getDistanceList(WidgetRef ref) async {
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
  ref.read(woodDistanceProvider.notifier).state = distanceList[0];
  ref.read(utDistanceProvider.notifier).state = distanceList[1];
  ref.read(ironDistanceProvider.notifier).state = distanceList[2];
  ref.read(wedgeDistanceProvider.notifier).state = distanceList[3];

  return distanceList;
}
