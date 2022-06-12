import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:collection';
import 'package:table_calendar/table_calendar.dart';
import 'package:training_note/calendar/calendar_page.dart';

final focusProvider = StateProvider<DateTime>((ref) => DateTime.now());
final selectedProvider = StateProvider<DateTime>((ref) => DateTime.now());
final preEventProvider = StateProvider<Map<DateTime, List>>((ref) => {});
final isSelectedProvider = StateProvider<List<bool>>((ref) => [true, false]);
