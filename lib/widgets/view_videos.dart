import 'package:churchapp/util/string_constants.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class ViewVideos extends StatefulWidget {
  const ViewVideos({
    Key key,
    @required this.url,
  }) : super(key: key);

  final String url;

  @override
  _ViewVideosState createState() => _ViewVideosState();
}

class _ViewVideosState extends State<ViewVideos> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
              : Container(),
        ),
        Center(
          child: IconButton(
            icon: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            ),
            onPressed: () {
              setState(() {
                _controller.value.isPlaying
                    ? _controller.pause()
                    : _controller.play();
              });
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.pause();
    _controller.dispose();
  }
}
