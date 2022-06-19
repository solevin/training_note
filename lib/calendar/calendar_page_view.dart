import 'package:hooks_riverpod/hooks_riverpod.dart';

final focusProvider = StateProvider<DateTime>((ref) => DateTime.now());
final selectedProvider = StateProvider<DateTime>((ref) => DateTime.now());
final isSelectedProvider = StateProvider<List<bool>>((ref) => [true, false]);
final ballQuantityProvider = StateProvider<String>((ref) => '0');
final scoreProvider = StateProvider<String>((ref) => '0');
final memoProvider = StateProvider<String>((ref) => '');
