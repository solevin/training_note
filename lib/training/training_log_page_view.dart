import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final achieveCheckboxListProvider = StateProvider<List<bool>>((ref) => []);