import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoPlayerPage extends StatefulWidget {
  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (_) => VideoPlayerPage(),
      settings: RouteSettings(),
    );
  }
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  VideoPlayerController? _controller;
  final imagePicker = ImagePicker();
  Future getVideoFromCamera() async {
    final pickedFile = await imagePicker.getVideo(source: ImageSource.camera);
    _controller = VideoPlayerController.file(File(pickedFile!.path));
    _controller!.initialize().then((_) {
      _controller!.pause();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            // ignore: unnecessary_null_comparison
            child: _controller == null
                ? Text(
                    '動画を選択してください',
                    style: Theme.of(context).textTheme.headline4,
                  )
                : VideoPlayer(_controller!)),
        floatingActionButton:
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          FloatingActionButton(
              onPressed: getVideoFromCamera, child: Icon(Icons.video_call)),
          FloatingActionButton(
              onPressed: () {
                setState(() {
                  _controller!.play();
                });
              },
              child: Icon(Icons.video_call)),
        ]));
  }
}

Future<Widget> getThumbnail(String path) async {
  final bytes = await VideoThumbnail.thumbnailData(
    video: path,
  );
  final image = Image.memory(bytes!);
  return image;
}
