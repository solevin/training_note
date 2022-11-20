import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:training_note/training/training_log_page_view.dart';
import 'package:video_player/video_player.dart';

class PlayVideoPage extends HookConsumerWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (_) => const PlayVideoPage(),
    );
  }

  const PlayVideoPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoFile = ref.watch(videoFileProvider);
    print(videoFile.path);
    final videoControllerProvider = StateProvider<VideoPlayerController>(
        (ref) => VideoPlayerController.file(videoFile));
    final controller = ref.watch(videoControllerProvider);
    controller.initialize().then((_) {
      controller.play();
    });
    return Scaffold(
      body: VideoPlayer(controller),
    );
  }
}
