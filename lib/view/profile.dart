import 'dart:math';

import 'package:flutter/material.dart';
import 'package:instagram_profile/view/profile_post.dart';
import 'package:instagram_profile/view/profile_reels.dart';
import 'package:ipa/ipa.dart' as ipa;

class InstaProfilePage extends StatefulWidget {
  const InstaProfilePage({Key? key, required this.profile}) : super(key: key);

  final ipa.Profile profile;

  @override
  _InstaProfilePageState createState() => _InstaProfilePageState();
}

class _InstaProfilePageState extends State<InstaProfilePage> {
  double get randHeight => Random().nextInt(100).toDouble();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Persistent AppBar that never scrolls
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.profile.username,
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.0,
      ),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          // allows you to build a list of elements that would be scrolled away till the body reached the top
          headerSliverBuilder: (context, _) {
            return [
              SliverList(
                delegate: SliverChildListDelegate([
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(widget.profile.profilePicUrl),
                  ),
                ]),
              ),
            ];
          },
          // You tab view goes here
          body: Column(
            children: <Widget>[
              const TabBar(
                tabs: [
                  Tab(
                    icon: Icon(Icons.grid_view, color: Colors.black),
                  ),
                  Tab(icon: Icon(Icons.list, color: Colors.black)),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    ProfilePost(profile: widget.profile),
                    const ProfileReels(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
