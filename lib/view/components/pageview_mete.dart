import 'dart:async';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:instagram_profile/view/video_mete.dart';
import 'package:ipa/ipa.dart' as ipa;
import 'package:transparent_image/transparent_image.dart';

class PageCareousel extends StatefulWidget {
  const PageCareousel({Key? key, required this.post, required this.itemCount})
      : super(key: key);

  final ipa.Post post;

  final int itemCount;

  @override
  State<PageCareousel> createState() => _PageCareouselState();
}

class _PageCareouselState extends State<PageCareousel>
    with AutomaticKeepAliveClientMixin {
  late PageController _pageController;

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

  int pageNumber = 0;
  bool showContainer = true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    DateTime date = DateTime.fromMillisecondsSinceEpoch(
        widget.post.takenAtTimestamp * 1000);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: PageView.builder(
              controller: _pageController,
              itemCount: widget.itemCount,
              onPageChanged: (index) {
                setState(() {
                  showContainer = true;
                });
                Timer(const Duration(seconds: 5), () {
                  if (mounted) {
                    setState(() {
                      showContainer = false;
                    });
                  }
                });
              },
              pageSnapping: true,
              itemBuilder: (context, pagePosition) {
                final carouselPost = widget.post as ipa.Carousel;

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    carouselPost.carouselMedia[pagePosition].isVideo
                        ? VideoApp(
                            url: carouselPost
                                .carouselMedia[pagePosition].videoUrl)
                        : FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: carouselPost
                                .carouselMedia[pagePosition].displayUrl,
                            fit: BoxFit.cover,
                          ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: showContainer
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
                                        width: 2)),
                                margin:
                                    const EdgeInsets.only(top: 10, right: 10),
                                child: Center(
                                  child: Text(
                                    '${pagePosition + 1}/${widget.itemCount}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                    ),
                  ],
                );
              }),
        ),
        Row(children: [
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  iconSize: 30.0,
                  onPressed: () => {},
                ),
                widget.post.likeCount == -1
                    ? const Expanded(child: Text("User likes are hidden"))
                    : Text(widget.post.likeCount.toString()),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPageIndicator(widget.itemCount, pageNumber),
            ),
          ),
          Expanded(
            flex: 1,
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
        ]),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.post.caption == ""
                  ? Text(pastDate(date))
                  : Text(widget.post.ownerUsername,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      )),
              const SizedBox(
                width: 10,
              ),
              widget.post.caption == ""
                  ? Container()
                  : Expanded(
                      child: Text(
                        widget.post.caption,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
            ],
          ),
        ),
        widget.post.caption == ""
            ? Container()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(pastDate(date)),
              )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

List<Widget> _buildPageIndicator(int itemCount, int pageNumber) {
  List<Widget> list = [];
  for (var i = 0; i < itemCount; i++) {
    list.add(i == pageNumber
        ? _indicator(
            true,
          )
        : _indicator(
            false,
          ));
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
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        height: isActive ? 12 : 7.0,
        width: isActive ? 12 : 7.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? Colors.blueAccent : Colors.grey,
        ),
      ));
}

String pastDate(DateTime date) {
  String formattedDate = DateFormat('yyyy MMMM dd').format(date);
  return formattedDate;
}
