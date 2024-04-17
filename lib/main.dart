import 'package:counter_test/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyBO8GBPuXUO4rIcc9yw5YSywL6alvBdRSk',
    appId: '1:271144720487:android:03233cd1799688d4a91cc2',
    messagingSenderId: '271144720487',
    projectId: 'face-login-8fb47',
    authDomain: 'com.test.login',
    storageBucket: 'face-login-8fb47.appspot.com',
  ));

  if (kIsWeb) {
    await FacebookAuth.i.webAndDesktopInitialize(
      appId: "941702434015984",
      cookie: true,
      xfbml: true,
      version: "v15.0",
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: LoginPage(),
    );
  }
}
