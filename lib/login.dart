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
          onPressed: () async {
            await ipa.IPA.login(context: context);

            final profile = await ipa.IPA().getProfile();

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Profile(profile: profile),
              ),
            );
          },
          child: const Text("Login"),
        ),
      ),
    );
  }
}
