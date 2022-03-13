import 'package:flutter/material.dart';
import 'package:instagram_profile/view/controller/controller.dart';
import 'package:ipa/ipa.dart' as ipa;
import 'package:man/man.dart';

class ReelsInformationBar extends StatelessWidget {
  // ignore: require_trailing_commas
  ReelsInformationBar({Key? key, required this.profile, required this.reel})
      : super(key: key);

  final ipa.Profile profile;
  final ipa.Reel reel;
  final _controller = Controller();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.20,
      color: Colors.transparent,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Row(
              children: [
                CircleAvatar(
                  child: ClipOval(
                    child: Image(
                      height: 50.0,
                      width: 50.0,
                      image: NetworkImage(profile.profilePicUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  profile.username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          buildMusicInfo(reel)
        ],
      ),
    );
  }

  Widget buildMusicInfo(ipa.Reel reel) {
    if (reel.hasMusic == true) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Row(
              children: [
                const Icon(Icons.music_note_sharp,
                    size: 12, color: Colors.white),
                Text(
                  reel.musicInfo!.artist,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                const Text(
                  " - ",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  reel.musicInfo!.title,
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                )
              ],
            ),
          )
        ],
      );
    } else if (reel.hasAudio == true) {
      return Padding(
        padding: const EdgeInsets.only(left: 18.0),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.music_note_sharp,
                    size: 12, color: Colors.white),
                Text(
                  reel.owner.username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                Man(
                  builder: () {
                    return Text(
                      _controller.likeCountMap.value.values.toString(),
                      style: const TextStyle(color: Colors.white),
                    );
                  },
                ),
                const Text(
                  " - ",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                const Text(
                  "Original Audio Content",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                )
              ],
            )
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 21.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            reel.caption,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
