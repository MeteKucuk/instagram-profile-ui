import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:instagram_profile/view/components/profile/post_bottom_section.dart';
import 'package:instagram_profile/view/components/profile/type/video_post.dart';
import 'package:instagram_profile/view/components/widget/heart_animation_widget.dart';
import 'package:instagram_profile/view/components/widget/like_buttons.dart';
import 'package:instagram_profile/view/controller/controller.dart';
import 'package:ipa/ipa.dart' as ipa;
import 'package:man/man.dart';
import 'package:transparent_image/transparent_image.dart';

class CarouselPost extends StatefulWidget {
  const CarouselPost({
    required this.post,
    Key? key,
  }) : super(key: key);

  final ipa.Carousel post;

  @override
  State<CarouselPost> createState() => _CarouselPostState();
}

class _CarouselPostState extends State<CarouselPost>
    with AutomaticKeepAliveClientMixin {
  final _controller = Controller();
  final isHeartAnimating = false.man;
  late PageController _pageController;
  late int itemCount = widget.post.carouselMedia.length;
  int pageNumber = 0;
  final showContainer = true.man;

  @override
  void initState() {
    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {
        pageNumber = _pageController.page!.round();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: widget.post.carouselMedia[0].displayResources[0].height
              .toDouble(),
          width: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            itemCount: itemCount,
            onPageChanged: (index) {
              showContainer.value = true;

              Timer(const Duration(seconds: 3), () {
                if (mounted) {
                  showContainer.value = false;
                }
              });
            },
            itemBuilder: (context, pagePosition) {
              return GestureDetector(
                onDoubleTap: () async {
                  _controller.postLikeController(widget.post);
                  if (mounted) {
                    isHeartAnimating.value = true;
                  }

                  await ipa
                      .IPA()
                      .media
                      .like(postId: widget.post.id.split("_").first);
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    widget.post.carouselMedia[pagePosition].isVideo
                        ? VideoPost(
                            url: widget
                                .post.carouselMedia[pagePosition].videoUrl,
                          )
                        : FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: widget
                                .post.carouselMedia[pagePosition].displayUrl,
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
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: Man(
                        builder: () {
                          return showContainer.value
                              ? Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    height: 40,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.black.withOpacity(0.9),
                                      border: Border.all(
                                        style: BorderStyle.none,
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    margin: const EdgeInsets.only(
                                      top: 10,
                                      right: 10,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${pagePosition + 1}/$itemCount',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Container();
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    LikeButtons(post: widget.post),
                    if (widget.post.likeCount == -1)
                      const AutoSizeText(
                        "Likes are hidden",
                        maxLines: 1,
                      )
                    else
                      Man(
                        builder: () {
                          return Text(
                            _controller.likeCountMap.value[widget.post.id]
                                .toString(),
                          );
                        },
                      )
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: _buildPageIndicator(itemCount, pageNumber),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.downloading_outlined),
                      iconSize: 30.0,
                      onPressed: () => {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        PostBottomSection(
          post: widget.post,
          isCarousel: true,
          ownerUsername: widget.post.ownerUsername,
          caption: widget.post.caption,
          likeCount: widget.post.likeCount,
          postId: widget.post.id,
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;

  List<Widget> _buildPageIndicator(int itemCount, int pageNumber) {
    final List<Widget> list = [];
    for (var i = 0; i < itemCount; i++) {
      list.add(
        i == pageNumber
            ? _indicator(
                true,
              )
            : _indicator(
                false,
              ),
      );
    }
    return list;
  }

  Widget _indicator(
    bool isActive,
  ) {
    return SizedBox(
      height: 10,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 2.0),
        height: isActive ? 10 : 5.0,
        width: isActive ? 10 : 5.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? Colors.blueAccent : Colors.grey,
        ),
      ),
    );
  }
}
