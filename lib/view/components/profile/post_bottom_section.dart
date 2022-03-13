import 'package:flutter/material.dart';
import 'package:instagram_profile/view/components/widget/like_buttons.dart';
import 'package:instagram_profile/view/controller/controller.dart';
import 'package:intl/intl.dart';
import 'package:ipa/ipa.dart' as ipa;

import 'package:man/man.dart';

const TextStyle dateTextStyle = TextStyle(color: Colors.grey, fontSize: 12);
Text pastDate(DateTime date) {
  final formattedDate = DateFormat('dd MMMM').format(date);

  final dateTimeNow = DateTime.now();

  final difference = dateTimeNow.difference(date).inDays;
  if (difference < 7) {
    return Text(
      difference.toString() + " days ago",
      style: dateTextStyle,
    );
  } else {
    return Text(
      formattedDate,
      style: dateTextStyle,
    );
  }
}

class PostBottomSection extends StatelessWidget {
  PostBottomSection({
    Key? key,
    required this.post,
    required this.isCarousel,
    required this.ownerUsername,
    required this.caption,
    required this.likeCount,
    required this.postId,
  }) : super(key: key);
  final ipa.Post post;
  final bool isCarousel;

  final String ownerUsername;
  final String caption;
  final int likeCount;
  final String postId;

  final isMaxLine = false.man;
  final _controller = Controller();

  @override
  Widget build(BuildContext context) {
    final numLines = '\n'.allMatches(caption).length + 1;
    final DateTime date =
        DateTime.fromMillisecondsSinceEpoch(post.takenAtTimestamp * 1000);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isCarousel)
          Container()
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    LikeButtons(post: post),
                    if (post.likeCount == -1)
                      const Text("likes are hidden")
                    else
                      Man(
                        builder: () {
                          return Text(
                            _controller.likeCountMap.value[postId].toString(),
                          );
                        },
                      )
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.downloading_outlined),
                  iconSize: 30.0,
                  onPressed: () => {},
                ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (caption == "")
                pastDate(date)
              else
                Man(
                  builder: () {
                    return Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedSize(
                            curve: Curves.easeIn,
                            duration: const Duration(milliseconds: 300),
                            child: RichText(
                              maxLines: isMaxLine.value ? null : 1,
                              text: TextSpan(
                                text: ownerUsername,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "  $caption",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (numLines <= 2 || isMaxLine.value)
                            const Text("")
                          else
                            GestureDetector(
                              onTap: () {
                                isMaxLine.value = true;
                              },
                              child: const Text("..More"),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
        if (caption == "")
          Container()
        else
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: pastDate(date))
      ],
    );
  }
}
