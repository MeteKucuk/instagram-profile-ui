import 'package:flutter/material.dart';
import 'package:instagram_profile/view/components/profile/profile_post.dart';
import 'package:instagram_profile/view/components/reels/profile_reels.dart';
import 'package:ipa/ipa.dart' as ipa;

import 'components/profile/expandable_text.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key, required this.profile}) : super(key: key);

  final ipa.Profile profile;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  final ScrollController nestedController = ScrollController();
  late TabController _controller;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
    _controller.addListener(() {
      setState(() {
        _selectedIndex = _controller.index;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Persistent AppBar that never scrolls
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.profile.username,
          style: const TextStyle(color: Colors.black),
        ),
        elevation: 0.0,
      ),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          controller: nestedController,
          headerSliverBuilder: (context, _) {
            return [
              SliverList(
                delegate: SliverChildListDelegate([
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await ipa.IPA().logout();
                              },
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    NetworkImage(widget.profile.profilePicUrl),
                              ),
                            ),
                            profileInformation(
                              title: "Posts",
                              value: widget.profile.mediaCount.toString(),
                            ),
                            profileInformation(
                              title: "Followers",
                              value: widget.profile.followerCount.toString(),
                            ),
                            profileInformation(
                              title: "Following",
                              value: widget.profile.followingCount.toString(),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(widget.profile.fullName),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: ExpandableText(post: widget.profile),
                      ),
                    ],
                  ),
                ]),
              ),
            ];
          },
          // You tab view goes here
          body: Column(
            children: <Widget>[
              TabBar(
                controller: _controller,
                unselectedLabelColor: Colors.grey,
                labelColor: Colors.black,
                indicatorColor: Colors.black.withOpacity(0.5),
                tabs: [
                  Tab(
                    icon: Icon(
                      Icons.grid_on_rounded,
                      color: _selectedIndex == 0 ? Colors.black : Colors.grey,
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.video_library_outlined,
                      color: _selectedIndex == 1 ? Colors.black : Colors.grey,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _controller,
                  children: [
                    ProfilePost(
                      nestedController: nestedController,
                      profile: widget.profile,
                    ),
                    ProfileReels(
                      profile: widget.profile,
                      nestedController: nestedController,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column profileInformation({required String title, required String value}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
