import 'package:flutter/material.dart';
import 'package:training_note/db/target_log.dart';
import 'package:training_note/db/target_log_dao.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_note/home/home_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:training_note/target/target_page_view.dart';

class CreateTargetPage extends HookConsumerWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (_) => const CreateTargetPage(),
    );
  }

  const CreateTargetPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Target',
            style: TextStyle(fontSize: 20.sp),
          ),
          automaticallyImplyLeading: false),
      body: Column(
        children: [
          Container(
            height: 50.h,
            width: 60.w,
            color: Colors.amber,
            child: GestureDetector(
              child: const Icon(Icons.add),
              onTap: () async {},
            ),
          ),
        ],
      ),
    );
  }
}
