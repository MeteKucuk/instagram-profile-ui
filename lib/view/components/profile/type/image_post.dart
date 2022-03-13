import 'package:flutter/material.dart';
import 'package:instagram_profile/view/components/profile/post_bottom_section.dart';
import 'package:instagram_profile/view/controller/controller.dart';

import 'package:ipa/ipa.dart' as ipa;
import 'package:man/man.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../widget/heart_animation_widget.dart';

class ImagePost extends StatefulWidget {
  const ImagePost({Key? key, required this.post}) : super(key: key);
  final ipa.Post post;

  @override
  State<ImagePost> createState() => _ImagePostState();
}

class _ImagePostState extends State<ImagePost> {
  final _controller = Controller();
  Managed<bool> isHeartAnimating = false.man;

  late bool hasLiked;

  @override
  void initState() {
    hasLiked = widget.post.viewerHasLiked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            GestureDetector(
              onDoubleTap: () async {
                _controller.postLikeController(widget.post);
                isHeartAnimating.value = true;

                await ipa
                    .IPA()
                    .media
                    .like(postId: widget.post.id.split("_").first);
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: widget.post.displayUrl,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
          ],
        ),
        PostBottomSection(
          caption: widget.post.caption,
          likeCount: widget.post.likeCount,
          ownerUsername: widget.post.ownerUsername,
          postId: widget.post.id,
          post: widget.post,
          isCarousel: false,
        )
      ],
    );
  }
}
