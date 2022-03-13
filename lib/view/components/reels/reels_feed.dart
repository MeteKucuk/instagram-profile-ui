import 'package:flutter/material.dart';
import 'package:instagram_profile/view/components/profile/type/video_post.dart';
import 'package:instagram_profile/view/components/reels/reels_information_bar.dart';
import 'package:instagram_profile/view/components/reels/side_action_bar.dart';
import 'package:instagram_profile/view/components/widget/heart_animation_widget.dart';
import 'package:instagram_profile/view/controller/controller.dart';
import 'package:ipa/ipa.dart' as ipa;
import 'package:man/man.dart';

class ReelsFeeds extends StatefulWidget {
  const ReelsFeeds(
      {Key? key,
      required this.index,
      required this.reel,
      required this.profile})
      : super(key: key);

  final int index;
  final ipa.Reel reel;
  final ipa.Profile profile;

  @override
  State<ReelsFeeds> createState() => _ReelsFeedsState();
}

class _ReelsFeedsState extends State<ReelsFeeds> {
  final isHeartAnimating = false.man;
  final _dumbVariable = 0.man;

  final _controller = Controller();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          GestureDetector(
            onDoubleTap: () async {
              isHeartAnimating.value = true;

              _dumbVariable.value++;

              await ipa
                  .IPA()
                  .media
                  .like(postId: widget.reel.id.split("_").first);
            },
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        VideoPost(
                          isReel: true,
                          height: widget.reel.videoVersions[0].height,
                          url: widget.reel.videoVersions[0].src,
                        ),
                        Center(
                          child: Man(
                            builder: () {
                              return Opacity(
                                opacity: isHeartAnimating.value ? 1 : 0,
                                child: Man(
                                  builder: () {
                                    return HeartAnimationWidget(
                                      onEnd: () =>
                                          isHeartAnimating.value = false,
                                      duration:
                                          const Duration(milliseconds: 1000),
                                      isAnimating: isHeartAnimating.value,
                                      child: const Icon(
                                        Icons.favorite,
                                        color: Colors.white,
                                        size: 80,
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Flexible(
                                  flex: 15,
                                  child: ReelsInformationBar(
                                    profile: widget.profile,
                                    reel: widget.reel,
                                  ),
                                ),
                                Flexible(
                                  flex: 2,
                                  child: SideActionBar(
                                    reel: widget.reel,
                                    index: widget.index,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
