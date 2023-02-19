import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_note/training/training_view.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

// class PlayVideoPage extends ConsumerWidget {
//   static Route<dynamic> route() {
//     return MaterialPageRoute<dynamic>(
//       builder: (_) => const PlayVideoPage(),
//     );
//   }

//   const PlayVideoPage({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final videoFile = ref.watch(videoFileProvider);
//     final videoControllerProvider = StateProvider<VideoPlayerController>(
//         (ref) => VideoPlayerController.file(videoFile));
//     final chewieController = ChewieController(
//       videoPlayerController: ref.watch(videoControllerProvider),
//       // aspectRatio: 1.w / 1.h,
//       autoPlay: true,
//       looping: false,
//       // Try playing around with some of these other options:

//       // materialProgressColors: ChewieProgressColors(
//       //   playedColor: Colors.red,
//       //   handleColor: Colors.blue,
//       //   backgroundColor: Colors.grey,
//       //   bufferedColor: Colors.lightGreen,
//       // ),
//       placeholder: Container(
//         color: Colors.grey,
//       ),
//       autoInitialize: true,
//     );
//     final controller = ref.watch(videoControllerProvider);
//     controller.initialize().then((_) {
//       controller.play();
//     });
//     return Scaffold(
//       body: Chewie(
//         controller: chewieController,
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Chewie Sample',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: MyHomePage(title: 'Chewie Sample'),
//     );
//   }
// }

class PlayVideoPage extends StatefulWidget {
  PlayVideoPage(this.file);

  final File file;

  @override
  _PlayVideoPageState createState() => _PlayVideoPageState();
}

class _PlayVideoPageState extends State<PlayVideoPage> {
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.file(widget.file);
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 3 / 2,
      autoPlay: false,
      looping: true,
      // Try playing around with some of these other options:

      //showControls: false,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.red,
        handleColor: Colors.blue,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.lightGreen,
      ),
      placeholder: Container(
        color: Colors.grey,
      ),
      autoInitialize: true,
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Center(
                child: Chewie(
                  controller: chewieController,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
