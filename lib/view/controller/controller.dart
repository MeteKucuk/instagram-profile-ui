import 'dart:developer';

import 'package:ipa/ipa.dart' as ipa;
import 'package:man/man.dart';
import 'package:get/get.dart';

class Controller {
  Controller._();

  static final _controller = Controller._();

  factory Controller() => _controller;

  final likedPost = <String>[].man;

  final unLikedPost = <String>[].man;

  final likeCountMap = <String, int>{}.obs;

  var test = <String, int>{};

  final postHeight = <int>[].man;

  bool checkIfLike({ipa.Post? postId, ipa.Reel? reelId}) {
    return true;
  }

  void postLikeController(ipa.Post post) {
    if (checkIfLike(postId: post) == false) {
      if (unLikedPost.value.contains(post.id)) {
        unLikedPost.value.remove(post.id);
      } else {
        likedPost.value.add(post.id);
      }
      post.likeCount++;
    }
  }
}
