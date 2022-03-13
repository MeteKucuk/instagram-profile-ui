import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:instagram_profile/view/components/profile/post_bottom_section.dart';
import 'package:instagram_profile/view/components/profile/type/carousel_post.dart';
import 'package:instagram_profile/view/components/profile/type/image_post.dart';
import 'package:instagram_profile/view/components/profile/type/video_post.dart';
import 'package:intl/intl.dart';
import 'package:ipa/ipa.dart' as ipa;

import 'post_header.dart';

class PostPage extends StatefulWidget {
  const PostPage({
    Key? key,
    required this.post,
    required this.index,
    required this.profile,
    required this.height,
  }) : super(key: key);

  final List<ipa.Post> post;

  final int index;
  final ipa.Profile profile;
  final double height;

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage>
    with AutomaticKeepAliveClientMixin {
  final _controller = ScrollController();
  final _appBarController = ScrollController();

  late final List<ipa.Post> _post;
  bool _hasMore = true;

  final _isProgressVisible = ValueNotifier(false);
  @override
  void initState() {
    _post = widget.post;

    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (_controller.hasClients) {
        _controller.jumpTo(widget.index == 1
            ? widget.height * widget.index * 1.2
            : widget.height * widget.index * 1.45);

        _controller.addListener(() async {
          if (_controller.offset >= _controller.position.maxScrollExtent &&
              _hasMore) {
            _isProgressVisible.value = true;

            final posts =
                await ipa.IPA().media.getPosts(userId: widget.profile.id);

            for (final post in posts) {
              setState(() {
                _post.add(post);
              });
            }
            _isProgressVisible.value = false;

            if (posts.isEmpty) {
              _hasMore = false;
            }
          }
          if (_controller.position.userScrollDirection ==
              ScrollDirection.forward) {
            _appBarController.animateTo(
              0.0,
              curve: Curves.bounceIn,
              duration: const Duration(milliseconds: 50),
            );
          } else {
            _appBarController.animateTo(
              _controller.position.maxScrollExtent,
              curve: Curves.bounceIn,
              duration: const Duration(milliseconds: 50),
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _appBarController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: NestedScrollView(
        controller: _appBarController,
        floatHeaderSlivers: true,
        body: ListView.builder(
          shrinkWrap: true,
          controller: _controller,
          itemCount: _post.length,
          itemBuilder: (context, index) {
            if (index == _post.length) {
              return ValueListenableBuilder(
                valueListenable: _isProgressVisible,
                builder: (context, bool value, child) {
                  return Visibility(
                    visible: value,
                    child: child!,
                  );
                },
                child: const SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return _buildPostFeed(
              context,
              index,
              _post,
              widget.profile,
            );
          },
        ),
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            backgroundColor: Colors.white,
            floating: true,
            snap: true,
            title: const Text(
              'Posts',
              style: TextStyle(color: Colors.black),
            ),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

Widget _buildPostFeed(
  BuildContext context,
  int index,
  List<ipa.Post> posts,
  ipa.Profile profile,
) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 15.0),
    child: Column(
      children: <Widget>[
        PostHeader(posts: posts[index], profile: profile),
        _buildPost(
          context: context,
          typeName: posts[index].typename,
          post: posts[index],
        ),
      ],
    ),
  );
}

Widget _buildPost({
  required BuildContext context,
  required String typeName,
  required ipa.Post post,
}) {
  switch (typeName) {
    case 'GraphImage':
      return ImagePost(post: post as ipa.Image);
    case 'GraphVideo':
      final videoPost = post as ipa.Video;
      return Column(
        children: [
          VideoPost(
            post: post,
            height: videoPost.height,
            url: videoPost.videoUrl,
          ),
          PostBottomSection(
            post: post,
            isCarousel: false,
            ownerUsername: post.ownerUsername,
            caption: post.caption,
            likeCount: post.likeCount,
            postId: post.id,
          )
        ],
      );
    case 'GraphSidecar':
      return CarouselPost(
        post: post as ipa.Carousel,
      );
    default:
      return Container();
  }
}

int dateCalculate(int day) {
  final date = DateTime.now();

  return date.day - day;
}

String pastDate(DateTime date) {
  final String formattedDate = DateFormat('yyyy MMMM dd').format(date);
  return formattedDate;
}
