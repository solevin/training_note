import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

final achieveCheckboxListProvider = StateProvider<List<bool>>((ref) => []);
final imageListProvider = StateProvider.autoDispose<List<Widget>>((ref) => []);
final tmp = File('assets/images/A_1_0.jpeg');
final videoFileProvider = StateProvider<File>((ref) => tmp);
final imageFileProvider = StateProvider<File>((ref) => tmp);
