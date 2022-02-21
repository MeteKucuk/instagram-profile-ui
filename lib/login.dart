import 'package:flutter/material.dart';
import 'package:instagram_profile/view/profile.dart';
import 'package:ipa/ipa.dart' as ipa;

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
        child: const Text("Login"),
        onPressed: (() async {
          await ipa.IPA.login(context: context);

          final profile = await ipa.IPA().getProfile();

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => InstaProfilePage(profile: profile),
            ),
          );
        }),
      )),
    );
  }
}
