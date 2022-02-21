import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:instagram_profile/view/components/nopost_yet.dart';
import 'package:instagram_profile/view/post_page.dart';

import 'package:ipa/ipa.dart' as ipa;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:transparent_image/transparent_image.dart';
import 'package:lottie/lottie.dart';

class ProfilePost extends StatefulWidget {
  const ProfilePost({Key? key, required this.profile}) : super(key: key);
  final ipa.Profile profile;

  @override
  State<ProfilePost> createState() => _ProfilePostState();
}

class _ProfilePostState extends State<ProfilePost>
    with AutomaticKeepAliveClientMixin<ProfilePost> {
  late PageController pageController;

  final _isProgressVisible = ValueNotifier(false);

  List posts = [];

  bool _hasMore = true;

  late Future<List<ipa.Post>> loadPost;

  final ScrollController _controller = ScrollController();

  bool _isLoading = false;

  @override
  void initState() {
    loadPost = ipa.IPA().media.getPosts(userId: widget.profile.id);

    _controller.addListener(_onScrool);

    super.initState();
  }

  _onScrool() async {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange &&
        _hasMore) {
      _isProgressVisible.value = true;

      final posts = await ipa.IPA().media.getPosts(userId: widget.profile.id);

      if (posts.isEmpty) {
        _hasMore = false;
      }
      _isProgressVisible.value = false;
    }
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ipa.Post> posts = snapshot.data as List<ipa.Post>;

            return MasonryGridView.count(
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 10, bottom: 15),
                addAutomaticKeepAlives: true,
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
                          child: CircularProgressIndicator()),
                    );
                  }

                  if (posts.isNotEmpty) {
                    switch (posts[index].typename) {
                      case "GraphImage":
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return PostPage(
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                post: posts,
                                index: index,
                                profile: ipa.IPA().profile,
                              );
                            }));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: FadeInImage.memoryNetwork(
                              height: 200,
                              placeholder: kTransparentImage,
                              image: posts[index].displayUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      case "GraphVideo":
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return PostPage(
                                height:
                                    MediaQuery.of(context).size.height * 0.65,
                                post: posts,
                                index: index,
                                profile: ipa.IPA().profile,
                              );
                            }));
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
                                          size: 30))),
                            ],
                          ),
                        );

                      case "GraphSidecar":
                        return GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return PostPage(
                                  height:
                                      MediaQuery.of(context).size.height * 0.75,
                                  post: posts,
                                  index: index,
                                  profile: ipa.IPA().profile,
                                );
                              }));
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
                                            Icons.photo_library_rounded,
                                            color: Colors.white,
                                            size: 20))),
                              ],
                            ));
                    }
                  }

                  return const NoPostYet();
                });
          } else {
            return Center(
                child: Lottie.network(
                    "https://assets5.lottiefiles.com/datafiles/nT4vnUFY9yay7QI/data.json"));
          }
        },
        future: loadPost);
  }

  @override
  bool get wantKeepAlive => true;
}
