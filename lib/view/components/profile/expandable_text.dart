import 'package:flutter/material.dart';
import 'package:ipa/ipa.dart' as ipa;

class ExpandableText extends StatefulWidget {
  const ExpandableText({Key? key, required this.post}) : super(key: key);
  final ipa.Profile post;
  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText>
    with TickerProviderStateMixin<ExpandableText> {
  bool isExpanded = false;
  late int numLines;

  @override
  void initState() {
    numLines = '\n'.allMatches(widget.post.biography).length + 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: Text(
            widget.post.biography,
            maxLines: isExpanded ? null : 3,
            softWrap: true,
          ),
        ),
        if (numLines > 1)
          GestureDetector(
            onTap: () => setState(() => isExpanded = !isExpanded),
            child: isExpanded
                ? Container()
                : const Text(
                    '... View more',
                    style: TextStyle(color: Colors.grey),
                  ),
          )
        else
          const SizedBox()
      ],
    );
  }
}
