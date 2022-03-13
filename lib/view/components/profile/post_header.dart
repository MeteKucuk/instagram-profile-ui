import 'package:flutter/material.dart';
import 'package:ipa/ipa.dart' as ipa;
import 'package:auto_size_text/auto_size_text.dart';

class PostHeader extends StatelessWidget {
  const PostHeader({Key? key, required this.posts, required this.profile})
      : super(key: key);

  final ipa.Post posts;

  final ipa.Profile profile;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.07,
        child: ListTile(
          leading: Container(
            width: 40.0,
            height: 40.0,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(115, 94, 77, 77),
                  offset: Offset(0, 2),
                  blurRadius: 6.0,
                ),
              ],
            ),
            child: CircleAvatar(
              child: ClipOval(
                child: Image(
                  height: 50.0,
                  width: 50.0,
                  image: NetworkImage(profile.profilePicUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          title: posts.location == ""
              ? Text(
                  posts.ownerUsername,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              : Text(
                  posts.ownerUsername,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
          subtitle: posts.location == ""
              ? null
              : AutoSizeText(
                  posts.location,
                  maxLines: 1,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
          trailing: IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            color: Colors.black,
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
