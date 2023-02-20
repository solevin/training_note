import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PlayVideoWidget extends StatelessWidget {
  final VideoPlayerController controller;

  const PlayVideoWidget({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) => 
    controller.value.isInitialized
      ? Container(
        alignment: Alignment.topCenter,
        child:  buildVideoPlayer()
      )
      : Container(
        child: const Center(
          child: CircularProgressIndicator()
        ),
      );
  
  Widget buildVideoPlayer() => 
    Stack(
      fit: StackFit.expand,
      children: <Widget>[
        buildFullScreen(
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            // child: VideoPlayer(controller),
            child: Chewie(
              controller: ChewieController(
                videoPlayerController: controller,
                fullScreenByDefault: true,
                allowFullScreen: false,
              )
            ),
          ),
        )
      ],
    );

  Widget buildFullScreen({
    required Widget child
  }) {
    final size = controller.value.size;
    final width = size.width;
    final height  = size.height;

    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: width,
        height: height,
        child: child,
      ),
    );
  }
}