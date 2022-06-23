import 'package:flutter/material.dart';
import 'package:training_note/db/training_log_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget abilityPage() {
  return FutureBuilder(
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
      });
}

Future<int> getBestScore() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getInt('bestscore') != null) {
    return prefs.getInt('bestscore')!;
  } else {
    return 0;
  }
}
