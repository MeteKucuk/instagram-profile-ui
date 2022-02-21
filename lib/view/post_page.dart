import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:instagram_profile/view/video_mete.dart';
import 'package:intl/intl.dart';
import 'package:ipa/ipa.dart' as ipa;
import 'package:transparent_image/transparent_image.dart';

import 'components/pageview_mete.dart';

const double _height = 1200.0;

class PostPage extends StatefulWidget {
  const PostPage({
    Key? key,
    required this.post,
    required this.index,
    required this.profile,
    required this.height,
  }) : super(key: key);

  final List<ipa.Post> post;

  final int index;
  final ipa.Profile profile;
  final double height;

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage>
    with AutomaticKeepAliveClientMixin {
  final _controller = ScrollController();
  final _appBarController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (_controller.hasClients) {
        _controller.jumpTo(widget.height * widget.index);

        _controller.addListener(() {
          if (_controller.position.userScrollDirection ==
              ScrollDirection.forward) {
            _appBarController.animateTo(0.0,
                curve: Curves.bounceIn,
                duration: const Duration(milliseconds: 50));
          } else {
            _appBarController.animateTo(_controller.position.maxScrollExtent,
                curve: Curves.bounceIn,
                duration: const Duration(milliseconds: 50));
          }
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _appBarController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: NestedScrollView(
      controller: _appBarController,
      floatHeaderSlivers: true,
      body: ListView.builder(
          scrollDirection: Axis.vertical,
          controller: _controller,
          itemCount: widget.post.length,
          itemBuilder: (context, index) {
            return _buildPostFeed(context, index, widget.post, widget.profile);
          }),
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverAppBar(
          backgroundColor: Colors.white,
          floating: true,
          snap: true,
          title: const Text(
            'Posts',
            style: TextStyle(color: Colors.black),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        )
      ],
    ));
  }

  @override
  bool get wantKeepAlive => true;
}

Widget _buildPostFeed(BuildContext context, int index, List<ipa.Post> posts,
    ipa.Profile profile) {
  DateTime date =
      DateTime.fromMillisecondsSinceEpoch(posts[index].takenAtTimestamp * 1000);

  return Padding(
    padding: const EdgeInsets.only(bottom: 15.0),
    child: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
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
            title: posts[index].location == ""
                ? Text(
                    posts[index].ownerUsername,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Text(
                    posts[index].ownerUsername,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            subtitle: posts[index].location == ""
                ? null
                : Text(
                    posts[index].location,
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
        _buildPost(
            context: context,
            typeName: posts[index].typename,
            post: posts[index]),
        posts[index].typename == "GraphSidecar"
            ? Container()
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.favorite_border),
                              iconSize: 30.0,
                              onPressed: () => {},
                            ),
                            posts[index].likeCount == -1
                                ? const Text("User likes are hidden")
                                : Text(posts[index].likeCount.toString()),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.downloading_outlined),
                          iconSize: 30.0,
                          onPressed: () => {},
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        posts[index].caption == ""
                            ? Text(pastDate(date))
                            : Text(posts[index].ownerUsername,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                )),
                        const SizedBox(
                          width: 10,
                        ),
                        posts[index].caption == ""
                            ? Container()
                            : Text(
                                posts[index].caption,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                      ],
                    ),
                  ),
                  posts[index].caption == ""
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(pastDate(date)),
                        )
                ],
              ),
      ],
    ),
  );
}

Widget _buildPost(
    {required BuildContext context,
    required String typeName,
    required ipa.Post post}) {
  switch (typeName) {
    case 'GraphImage':
      return _buildImagePost(context, post);
    case 'GraphVideo':
      return _buildVideoPost(context, post);
    case 'GraphSidecar':
      return _buildCarousel(context, post);
    default:
      return Container();
  }
}

Widget _buildCarousel(BuildContext context, ipa.Post post) {
  final carouselPost = post as ipa.Carousel;
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.75,
    width: double.infinity,
    child:
        PageCareousel(post: post, itemCount: carouselPost.carouselMedia.length),
  );
}

Widget _buildVideoPost(BuildContext context, ipa.Post post) {
  final videoPost = post as ipa.Video;

  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.65,
    width: double.infinity,
    child: VideoApp(url: videoPost.videoUrl),
  );
}

Widget _buildImagePost(BuildContext context, ipa.Post post) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.5,
    width: double.infinity,
    child: FadeInImage.memoryNetwork(
      placeholder: kTransparentImage,
      image: post.displayUrl,
      fit: BoxFit.cover,
    ),
  );
}

int dateCalculate(int day) {
  var date = DateTime.now();

  return date.day - day;
}

String pastDate(DateTime date) {
  String formattedDate = DateFormat('yyyy MMMM dd').format(date);
  return formattedDate;
}
