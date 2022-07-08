import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_note/home/home_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AdvicePage extends HookConsumerWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (_) => const AdvicePage(),
    );
  }

  const AdvicePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        child: Container(),
      ),
      bottomNavigationBar: commonBottomNavigationBar(context, ref),
    );
  }
}
