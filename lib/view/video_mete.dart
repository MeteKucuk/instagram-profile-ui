import 'dart:developer';

import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoApp extends StatefulWidget {
  final String url;

  const VideoApp({Key? key, required this.url}) : super(key: key);
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });

    _controller?.setVolume(0);

    _controller?.setLooping(true);
  }

  bool isVolumeOn = false;
  @override
  Widget build(BuildContext context) {
    log(widget.url);
    return VisibilityDetector(
      onVisibilityChanged: (info) {
        var visiblePercentage = info.visibleFraction;
        if (visiblePercentage == 1) {
          _controller?.play();
          log("play");
        } else {
          _controller?.pause();
        }
      },
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      child: _controller!.value.isInitialized
          ? Stack(children: [
              AspectRatio(aspectRatio: 0.9, child: VideoPlayer(_controller!)),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isVolumeOn = !isVolumeOn;
                        });
                        if (isVolumeOn) {
                          _controller?.setVolume(100);
                        } else {
                          _controller?.setVolume(0);
                        }
                      },
                      child: isVolumeOn
                          ? const Icon(
                              Icons.volume_down,
                              size: 20,
                              color: Colors.white,
                            )
                          : const Icon(
                              Icons.volume_off,
                              size: 20,
                              color: Colors.white,
                            ),
                    ),
                  ),
                ),
              ),
            ])
          : const CircularProgressIndicator(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
    _controller = null;
  }
}
