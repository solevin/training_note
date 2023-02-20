import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_note/db/advice.dart';
import 'dart:io';

final checkboxListProvider = StateProvider<List<bool>>((ref) => []);
final isTrainingProvider = StateProvider<bool>((ref) => true);
final decideAdviceListProvider = StateProvider<List<Advice>>((ref) => []);
final achieveCheckboxListProvider = StateProvider<List<bool>>((ref) => []);
final imageListProvider = StateProvider.autoDispose<List<Widget>>((ref) => []);
final tmp = File('assets/images/A_1_0.jpeg');
final videoFileProvider = StateProvider<File>((ref) => tmp);
final imageFileProvider = StateProvider<File>((ref) => tmp);
final trainingTimeProvider = StateProvider<int>((ref) => 0);