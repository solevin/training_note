import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final achieveCheckboxListProvider = StateProvider<List<bool>>((ref) => []);
final testImageprovider = StateProvider<Widget>((ref) => Padding(
      padding: EdgeInsets.all(8.r),
      child: SizedBox(
          height: 100.h, child: Image.asset('assets/images/A_1_0.jpeg')),
    ));
