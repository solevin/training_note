import 'package:hooks_riverpod/hooks_riverpod.dart';

final isSelectedProvider =
    StateProvider.autoDispose<List<bool>>((ref) => [true, false, false, false]);
final woodDistanceProvider =
    StateProvider<List<int>>((ref) => [0, 0, 0, 0, 0, 0]);
final utDistanceProvider = StateProvider<List<int>>((ref) => [0, 0, 0, 0, 0]);
final ironDistanceProvider =
    StateProvider<List<int>>((ref) => [0, 0, 0, 0, 0, 0, 0]);
final wedgeDistanceProvider = StateProvider<List<int>>((ref) => [0, 0, 0, 0]);
