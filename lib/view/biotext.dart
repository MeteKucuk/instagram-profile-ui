import 'package:flutter/material.dart';
import 'package:ipa/ipa.dart' as ipa;

class BioText extends StatefulWidget {
  BioText({Key? key, required this.profile}) : super(key: key);

  final ipa.Profile profile;

  @override
  State<BioText> createState() => _BioTextState();
}

class _BioTextState extends State<BioText> {
  bool isVisible = true;

  num lines = 0;

  List<Row> rowText = [];

  List<Row> lineText() {
    lines = '\n'.allMatches(widget.profile.biography.toString()).length + 1;

    if (rowText.isEmpty) {
      // TODO: like/unlike.
      /*  ipa.IPA().media.like(postId: postId);
      ipa.IPA().media.unlike(postId: postId); */

      if (lines > 4) {
        for (int i = 0; i <= 8; i = i + 2) {
          if (i == 8) {
            rowText.add(Row(
              children: [
                Text(widget.profile.biography[i]),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        rowText.removeAt(4);
                        for (int i = 8;
                            i < widget.profile.biography.length;
                            i = i + 2) {
                          rowText.add(Row(
                            children: [
                              Text(widget.profile.biography[i]),
                            ],
                          ));
                        }
                      });
                    },
                    child: const Text("   ...more")),
              ],
            ));
          } else {
            rowText.add(Row(
              children: [
                Text(widget.profile.biography[i]),
              ],
            ));
          }
        }
      }
    }

    return rowText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: lineText());
  }
}
