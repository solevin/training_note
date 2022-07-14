import 'package:hooks_riverpod/hooks_riverpod.dart';

final isAchievedProvider = StateProvider.autoDispose<bool>((ref) => false);
