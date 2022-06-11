import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final indexProvider = StateProvider<int>((ref) => 0);

class TrainingLogPage extends HookConsumerWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (_) => const TrainingLogPage(),
    );
  }

  const TrainingLogPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        child: Text(
          'TrainingLog',
          style: TextStyle(fontSize: 20.sp),
        ),
      ),
    );
  }
}
