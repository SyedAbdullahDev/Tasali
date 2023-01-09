import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tasali/Page/Page.dart';
import 'package:tasali/Screens/Splash_Screen/Splash_Screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? user;
  onRefresh(usercred) {
    setState(() {
      user = usercred;
    });
  }

  final Future<FirebaseApp> _initialiazaton = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: _initialiazaton,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return GetMaterialApp(
              title: 'TASALI',
              theme: ThemeData(
                primarySwatch: Colors.deepPurple,
              ),
              home: FirebaseAuth.instance.currentUser == null
                  ? Splash_Screen()
                  : MyHomePage(),
              debugShowCheckedModeBanner: false,
            );
          }
          return CircularProgressIndicator();
        },
      );
}