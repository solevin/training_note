import 'package:hooks_riverpod/hooks_riverpod.dart';

final isSelectedProvider =
    StateProvider.autoDispose<List<bool>>((ref) => [true, false, false, false]);
final woodDistanceProvider = StateProvider.autoDispose<List<int>>((ref) => []);
final utDistanceProvider = StateProvider.autoDispose<List<int>>((ref) => []);
final ironDistanceProvider = StateProvider.autoDispose<List<int>>((ref) => []);
final wedgeDistanceProvider = StateProvider.autoDispose<List<int>>((ref) => []);
