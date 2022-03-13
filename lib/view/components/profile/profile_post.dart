import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_profile/view/components/nopost_yet.dart';
import 'package:instagram_profile/view/components/profile/post_page.dart';
import 'package:instagram_profile/view/controller/controller.dart';
import 'package:ipa/ipa.dart' as ipa;
import 'package:transparent_image/transparent_image.dart';

class ProfilePost extends StatefulWidget {
  const ProfilePost({
    Key? key,
    required this.profile,
    required this.nestedController,
  }) : super(key: key);
  final ipa.Profile profile;
  final ScrollController nestedController;

  @override
  State<ProfilePost> createState() => _ProfilePostState();
}

class _ProfilePostState extends State<ProfilePost>
    with AutomaticKeepAliveClientMixin<ProfilePost> {
  final ScrollController _controller = ScrollController();

  bool _hasMore = true;

  late Future<List<ipa.Post>> loadPost;

  final _isProgressVisible = ValueNotifier(false);

  final _controllerMan = Controller();
  @override
  void initState() {
    loadPost = ipa.IPA().media.getPosts(userId: widget.profile.id);

    _controller.addListener(_onScrool);

    super.initState();
  }

  Future<void> _onScrool() async {
    if (_controller.offset > 200) {
      widget.nestedController.animateTo(
        _controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.ease,
      );
    } else {
      widget.nestedController.animateTo(
        0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.ease,
      );
    }

    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange &&
        _hasMore) {
      _isProgressVisible.value = true;

      final posts = await ipa.IPA().media.getPosts(userId: widget.profile.id);

      setState(() {
        loadPost.then((value) => value.addAll(posts));
        _isProgressVisible.value = false;
      });

      if (posts.isEmpty) {
        _hasMore = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<ipa.Post> posts = snapshot.data as List<ipa.Post>;

          _controllerMan.postHeight.value.addAll(posts
              .map((post) => post.displayResources[0].height.toInt())
              .toList());

          return MasonryGridView.count(
            controller: _controller,
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 10, bottom: 15),
            crossAxisCount: 2,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
            itemCount: posts.length + 1,
            itemBuilder: (context, index) {
              if (index == posts.length) {
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

              if (posts.isNotEmpty) {
                switch (posts[index].typename) {
                  case "GraphImage":
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return PostPage(
                                height: _controllerMan.postHeight.value[index]
                                    .toDouble(),
                                post: posts,
                                index: index,
                                profile: ipa.IPA().profile,
                              );
                            },
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: posts[index].displayUrl,
                        ),
                      ),
                    );
                  case "GraphVideo":
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return PostPage(
                                height:
                                    MediaQuery.of(context).size.height * 0.50,
                                post: posts,
                                index: index,
                                profile: ipa.IPA().profile,
                              );
                            },
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: posts[index].displayUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: AnimatedContainer(
                              duration: const Duration(seconds: 1),
                              child: const Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );

                  case "GraphSidecar":
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return PostPage(
                                height:
                                    MediaQuery.of(context).size.height * 0.50,
                                post: posts,
                                index: index,
                                profile: ipa.IPA().profile,
                              );
                            },
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: posts[index].displayUrl,
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: AnimatedContainer(
                              duration: const Duration(seconds: 1),
                              child: const Icon(
                                Icons.photo_library_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                }
              }

              return const NoPostYet();
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          );
        }
      },
      future: loadPost,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
