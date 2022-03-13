import 'dart:async';

import 'package:flutter/material.dart';
import 'package:instagram_profile/view/components/widget/heart_animation_widget.dart';
import 'package:instagram_profile/view/controller/controller.dart';
import 'package:ipa/ipa.dart' as ipa;
import 'package:lottie/lottie.dart';
import 'package:man/man.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPost extends StatefulWidget {
  const VideoPost({
    Key? key,
    required this.url,
    this.isReel = false,
    this.height,
    this.post,
  }) : super(key: key);
  final String url;

  final bool isReel;
  final int? height;

  final ipa.Video? post;
  @override
  _VideoPostState createState() => _VideoPostState();
}

class _VideoPostState extends State<VideoPost> {
  late VideoPlayerController? _controller;
  final isHeartAnimating = false.man;

  final _controllerLike = Controller();
  late final bool result;
  final _checkMusicIcon = false.man;
  final isVolumeOn = false.man;
  bool _forceToFit = false;

  void _setFitting() {
    if (widget.isReel) {
      if (_controller!.value.isInitialized) {
        if (widget.height! >= MediaQuery.of(context).size.height * .8) {
          _forceToFit = true;
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        _setFitting();
        setState(() {});
      });

    _controller?.setVolume(0);

    _controller?.setLooping(true);
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      onVisibilityChanged: (info) {
        final visiblePercentage = info.visibleFraction;
        if (visiblePercentage == 1) {
          _controller?.play();
        } else {
          _controller?.pause();
        }
      },
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      child: _controller!.value.isInitialized
          ? Stack(
              children: [
                if (widget.isReel)
                  GestureDetector(
                    onTap: () async {
                      _checkMusicIcon.value = true;

                      isVolumeOn.value = !isVolumeOn.value;

                      Timer(const Duration(seconds: 3), () {
                        _checkMusicIcon.value = false;
                      });
                      if (isVolumeOn.value) {
                        _controller?.setVolume(100);
                      } else {
                        _controller?.setVolume(0);
                      }
                    },
                    child: _forceToFit
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: Center(child: VideoPlayer(_controller!)),
                          )
                        : Center(
                            child: AspectRatio(
                              aspectRatio: _controller!.value.aspectRatio,
                              child: Center(child: VideoPlayer(_controller!)),
                            ),
                          ),
                  )
                else
                  GestureDetector(
                    onDoubleTap: () async {
                      _controllerLike
                          .postLikeController(widget.post as ipa.Post);

                      isHeartAnimating.value = true;

                      await ipa
                          .IPA()
                          .media
                          .like(postId: widget.post!.id.split("_").first);
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          children: [
                            Center(
                              child: AspectRatio(
                                aspectRatio:
                                    _controller!.value.aspectRatio < 0.7
                                        ? 0.7
                                        : _controller!.value.aspectRatio,
                                child: Center(child: VideoPlayer(_controller!)),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Man(
                              builder: () {
                                return Opacity(
                                  opacity: isHeartAnimating.value ? 1 : 0,
                                  child: HeartAnimationWidget(
                                    onEnd: () {
                                      isHeartAnimating.value = false;
                                    },
                                    duration: const Duration(seconds: 1),
                                    isAnimating: isHeartAnimating.value,
                                    child: const Icon(
                                      Icons.favorite,
                                      color: Colors.white,
                                      size: 80,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                if (widget.isReel)
                  Man(
                    builder: () {
                      return Align(
                        child: Padding(
                          padding: const EdgeInsets.all(25),
                          child: _checkMusicIcon.value
                              ? (isVolumeOn.value
                                  ? GestureDetector(
                                      child: reelsVolumeIcon(isOn: true),
                                    )
                                  : reelsVolumeIcon(isOn: false))
                              : Container(),
                        ),
                      );
                    },
                  )
                else
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(25),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isVolumeOn.value = !isVolumeOn.value;
                            });
                            if (isVolumeOn.value) {
                              _controller?.setVolume(100);
                            } else {
                              _controller?.setVolume(0);
                            }
                          },
                          child: isVolumeOn.value
                              ? const Icon(
                                  Icons.volume_up,
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
              ],
            )
          : Lottie.network(
              "https://assets2.lottiefiles.com/packages/lf20_Ch2iSK.json",
            ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
    _controller = null;
  }
}

Widget reelsVolumeIcon({required bool isOn}) {
  return Container(
    height: 40,
    width: 40,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.black.withOpacity(0.8),
    ),
    child: Icon(
      isOn ? Icons.volume_up : Icons.volume_off,
      color: Colors.white,
      size: 20,
    ),
  );
}
