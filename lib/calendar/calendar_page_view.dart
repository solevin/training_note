import 'package:hooks_riverpod/hooks_riverpod.dart';

final focusProvider = StateProvider<DateTime>((ref) => DateTime.now());
final selectedProvider = StateProvider<DateTime>((ref) => DateTime.now());
final preEventProvider = StateProvider<Map<DateTime, List>>((ref) => {});
final isSelectedProvider = StateProvider<List<bool>>((ref) => [true, false]);
final ballQuantityProvider = StateProvider<int>((ref) => 0);
final memoProvider = StateProvider<String>((ref) => '');
