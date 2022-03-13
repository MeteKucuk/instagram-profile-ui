import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_profile/login.dart';
import 'package:ipa/ipa.dart' as ipa;

import 'view/controller/controller.dart';
import 'view/profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ipa.IPA.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Controller());
    return Scaffold(
      body: Builder(
        builder: (context) {
          if (ipa.IPA.isAuthorized) {
            return FutureBuilder<ipa.Profile>(
              future: ipa.IPA().getProfile(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Profile(profile: snapshot.data!);
                }

                return const CircularProgressIndicator();
              },
            );
          }

          return const Login();
        },
      ),
    );
  }
}
