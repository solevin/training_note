import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isDisplayProvider = StateProvider.autoDispose<bool>((ref) => false);
final isVisibleProvider = StateProvider.autoDispose<bool>((ref) => false);
final isAchievedProvider = StateProvider<List<bool>>((ref) => []);
final adviceListViewProvider = StateProvider.autoDispose<List<Widget>>((ref) => []);
final contentsProvider = StateProvider.autoDispose<String>((ref) => '');
final sourceProvider = StateProvider.autoDispose<String>((ref) => '');
final dateProvider = StateProvider.autoDispose<String>(
    (ref) => DateFormat('yyyy/M/d').format(DateTime.now()));
