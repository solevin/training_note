import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_note/home/home_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
        child: Container(),
      ),
      bottomNavigationBar: commonBottomNavigationBar(context, ref),
    );
  }
}
