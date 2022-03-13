import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:man/man.dart';

import '../../controller/controller.dart';
import 'package:ipa/ipa.dart' as ipa;

class LikeCount extends StatelessWidget {
  LikeCount({Key? key, required this.reel}) : super(key: key);

  final _controller = Controller();

  final ipa.Reel reel;

  final controller = Get.find<Controller>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Man(
        builder: () {
          return Text(controller.likeCountMap.value[reel.id].toString(),
              style: const TextStyle(color: Colors.white));
        },
      ),
    );
  }
}
