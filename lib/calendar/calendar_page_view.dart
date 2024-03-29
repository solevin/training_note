import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_note/db/advice.dart';

final focusProvider = StateProvider.autoDispose<DateTime>((ref) => DateTime.now());
final selectedDayProvider = StateProvider.autoDispose<DateTime>((ref) => DateTime.now());
final isSelectedProvider = StateProvider.autoDispose<List<bool>>((ref) => [true, false]);
final ballQuantityProvider = StateProvider.autoDispose<String>((ref) => '0');
final scoreProvider = StateProvider<String>((ref) => '0');
final memoProvider = StateProvider<String>((ref) => '');
final idProvider = StateProvider<int>((ref) => -1);
final adviceListProvider = StateProvider<List<Advice>>((ref) => []);
