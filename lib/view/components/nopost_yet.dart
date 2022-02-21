import 'package:flutter/material.dart';

class NoPostYet extends StatelessWidget {
  const NoPostYet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: const Icon(
            Icons.photo_camera_outlined,
            color: Colors.black,
            size: 60,
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        const Text("No Post Yet",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
      ]),
    );
  }
}
