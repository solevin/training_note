import 'package:flutter/material.dart';
import 'package:training_note/calendar/calendar_page_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:training_note/training/training_log_page_view.dart';
import 'package:intl/intl.dart';

class DisplayImagePage extends HookConsumerWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (_) => const DisplayImagePage(),
    );
  }

  const DisplayImagePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime selectedDay = ref.watch(selectedDayProvider);
    String date = DateFormat('M/d (E)').format(selectedDay);
    final imageFile = ref.watch(imageFileProvider);
    return Scaffold(
      appBar: AppBar(title: Text(date)),
      body: Image.file(imageFile)
    );
  }
}
