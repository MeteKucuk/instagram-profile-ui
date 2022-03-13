import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ipa/ipa.dart' as ipa;

import 'reels_feed.dart';

class ReelsPage extends StatefulWidget {
  const ReelsPage(
      {Key? key,
      required this.reels,
      required this.profile,
      required this.index})
      : super(key: key);

  final List<ipa.Reel> reels;
  final ipa.Profile profile;
  final int index;
  @override
  State<ReelsPage> createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage> {
  late final PageController pageController;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    super.initState();
    pageController = PageController(
      initialPage: widget.index,
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        body: PageView.builder(
          controller: pageController,
          scrollDirection: Axis.vertical,
          itemCount: widget.reels.length,
          itemBuilder: (context, index) {
            return ReelsFeeds(
              index: index,
              reel: widget.reels[index],
              profile: widget.profile,
            );
          },
        ),
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            backgroundColor: Colors.black,
            floating: true,
            snap: true,
            title: const Text(
              'Reels',
              style: TextStyle(color: Colors.white),
            ),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          )
        ],
      ),
    );
  }
}
