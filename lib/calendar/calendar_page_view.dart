import 'package:hooks_riverpod/hooks_riverpod.dart';

final focusProvider = StateProvider.autoDispose<DateTime>((ref) => DateTime.now());
final selectedProvider = StateProvider.autoDispose<DateTime>((ref) => DateTime.now());
final isSelectedProvider = StateProvider.autoDispose<List<bool>>((ref) => [true, false]);
final ballQuantityProvider = StateProvider.autoDispose<String>((ref) => '0');
final scoreProvider = StateProvider.autoDispose<String>((ref) => '0');
final memoProvider = StateProvider.autoDispose<String>((ref) => '');
