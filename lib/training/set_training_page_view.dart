import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:training_note/db/advice.dart';

final checkboxListProvider = StateProvider.autoDispose<List<bool>>((ref) => []);
final isTrainingProvider = StateProvider<bool>((ref) => true);
final decideAdviceListProvider = StateProvider<List<Advice>>((ref) => []);