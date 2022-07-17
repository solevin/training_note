import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final isDisplayProvider = StateProvider.autoDispose<bool>((ref) => false);
final isVisibleProvider = StateProvider.autoDispose<bool>((ref) => false);
final targetListProvider = StateProvider.autoDispose<List<Widget>>((ref) => []);
final contentsProvider = StateProvider.autoDispose<String>((ref) => '');
final dateProvider =
    StateProvider.autoDispose<String>((ref) => DateFormat('yyyy/M/d').format(DateTime.now()));
