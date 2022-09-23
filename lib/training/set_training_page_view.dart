import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:training_note/db/advice.dart';

final selectProvider = StateProvider.autoDispose<bool>((ref) => false);
final checkboxListProvider = StateProvider.autoDispose<List<bool>>((ref) => []);
final testListProvider = StateProvider.autoDispose<List<bool>>((ref) => [false,false,false]);
final testProvider = StateProvider.autoDispose<bool>((ref) => false);