import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_profile/view/components/nopost_yet.dart';
import 'package:instagram_profile/view/components/reels/reels_page.dart';
import 'package:ipa/ipa.dart' as ipa;
import 'package:lottie/lottie.dart';
import 'package:transparent_image/transparent_image.dart';

class ProfileReels extends StatefulWidget {
  const ProfileReels({
    Key? key,
    required this.profile,
    required this.nestedController,
  }) : super(key: key);
  final ipa.Profile profile;
  final ScrollController nestedController;

  @override
  State<ProfileReels> createState() => _ProfileReelsState();
}

class _ProfileReelsState extends State<ProfileReels>
    with AutomaticKeepAliveClientMixin<ProfileReels> {
  late Future<List<ipa.Reel>> loadReels;

  final ScrollController _controller = ScrollController();
  final _isProgressVisible = ValueNotifier(false);

  bool _hasMore = true;

  @override
  void initState() {
    super.initState();

    loadReels = ipa.IPA().media.getReels(userId: widget.profile.id);
    _controller.addListener(_onScrool);
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
        _hasMore) {
      _isProgressVisible.value = true;

      final posts = await ipa.IPA().media.getReels(userId: widget.profile.id);

      setState(() {
        loadReels.then((value) => value.addAll(posts));
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
          final reels = snapshot.data as List<ipa.Reel>;
          if (reels.isNotEmpty) {
            return MasonryGridView.count(
              controller: _controller,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              padding: const EdgeInsets.only(top: 10, bottom: 15),
              crossAxisCount: 2,
              itemCount: reels.length,
              itemBuilder: (context, index) {
                if (index == reels.length) {
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

                return Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ReelsPage(
                                index: index,
                                reels: reels,
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
                          image: reels[index].imageVersions[0].src,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(
                              Icons.play_arrow_outlined,
                              color: Colors.white,
                              size: 30,
                            ),
                            Text(
                              reels[index].playCount.toString(),
                              style: const TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          } else {
            return const NoPostYet();
          }
        }

        return Lottie.network(
          "https://assets5.lottiefiles.com/datafiles/nT4vnUFY9yay7QI/data.json",
        );
      },
      future: loadReels,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
