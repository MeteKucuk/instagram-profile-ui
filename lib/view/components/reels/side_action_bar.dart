import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_profile/view/components/widget/likecount.dart';
import 'package:instagram_profile/view/controller/controller.dart';
import 'package:ipa/ipa.dart' as ipa;
import 'package:man/man.dart';

class SideActionBar extends StatefulWidget {
  SideActionBar({Key? key, required this.index, required this.reel})
      : super(key: key);
  final int index;

  final ipa.Reel reel;

  @override
  State<SideActionBar> createState() => _SideActionBarState();
}

class _SideActionBarState extends State<SideActionBar> {
  final _controller = Controller();

  final controller = Get.put(Controller());

  bool isLiked = false;
  int countLike = 0;

  late int reelLikeCount;
  @override
  void initState() {
    reelLikeCount = widget.reel.likeCount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Man(
            builder: () {
              return _controller.checkIfLike(reelId: widget.reel)
                  ? IconButton(
                      icon: const Icon(Icons.favorite),
                      color: Colors.red,
                      iconSize: 30.0,
                      onPressed: () async {
                        if (_controller.likedPost.value
                            .contains(widget.reel.id)) {
                          _controller.likedPost.value.remove(widget.reel.id);
                        } else {
                          _controller.unLikedPost.value.add(widget.reel.id);
                        }
                        controller.likeCountMap[widget.reel.id] =
                            --reelLikeCount;

                        await ipa
                            .IPA()
                            .media
                            .unlike(postId: widget.reel.id.split("_").first);
                      },
                    )
                  : IconButton(
                      icon: const Icon(Icons.favorite_border_outlined),
                      color: Colors.white,
                      iconSize: 30.0,
                      onPressed: () async {
                        if (_controller.unLikedPost.value
                            .contains(widget.reel.id)) {
                          _controller.unLikedPost.value.remove(widget.reel.id);
                        } else {
                          _controller.likedPost.value.add(widget.reel.id);
                        }
                        controller.likeCountMap[widget.reel.id] =
                            ++reelLikeCount;

                        await ipa
                            .IPA()
                            .media
                            .like(postId: widget.reel.id.split("_").first);
                      },
                    );
            },
          ),
          LikeCount(reel: widget.reel),
          IconButton(
            onPressed: () {},
            icon: Transform(
              transform: Matrix4.rotationZ(5.8),
              child: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
