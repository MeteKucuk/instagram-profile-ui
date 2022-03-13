import 'package:flutter/material.dart';
import 'package:instagram_profile/view/controller/controller.dart';
import 'package:ipa/ipa.dart' as ipa;
import 'package:man/man.dart';

// ignore: must_be_immutable
class LikeButtons extends StatefulWidget {
  const LikeButtons({Key? key, required this.post}) : super(key: key);

  final ipa.Post post;

  @override
  State<LikeButtons> createState() => _LikeButtonsState();
}

class _LikeButtonsState extends State<LikeButtons> {
  final _controller = Controller();

  bool isHeartAnimating = false;

// use to just updating ui force
  final _dumbVariable = 0.man;

  @override
  Widget build(BuildContext context) {
    return Man(
      builder: () {
        return _controller.checkIfLike(postId: widget.post)
            ? IconButton(
                icon: const Icon(Icons.favorite),
                color: Colors.red,
                iconSize: 30.0,
                onPressed: () async {
                  if (_controller.likedPost.value.contains(widget.post.id)) {
                    _controller.likedPost.value.remove(widget.post.id);
                  } else {
                    _controller.unLikedPost.value.add(widget.post.id);
                  }
                  _controller.likeCountMap[widget.post.id] =
                      --widget.post.likeCount;

                  _dumbVariable.value++;

                  await ipa
                      .IPA()
                      .media
                      .unlike(postId: widget.post.id.split("_").first);
                },
              )
            : IconButton(
                icon: const Icon(Icons.favorite_border_outlined),
                color: Colors.black,
                iconSize: 30.0,
                onPressed: () async {
                  if (_controller.unLikedPost.value.contains(widget.post.id)) {
                    _controller.unLikedPost.value.remove(widget.post.id);
                  } else {
                    _controller.likedPost.value.add(widget.post.id);
                  }
                  _controller.likeCountMap[widget.post.id] =
                      ++widget.post.likeCount;

                  _dumbVariable.value++;

                  await ipa
                      .IPA()
                      .media
                      .like(postId: widget.post.id.split("_").first);
                },
              );
      },
    );
  }
}
