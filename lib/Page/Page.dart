// ignore_for_file: file_names, library_private_types_in_public_api, import_of_legacy_library_into_null_safe
import 'dart:async';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rate/rate.dart';
import 'package:tale_drawer/tale_drawer.dart';
import 'package:tasali/Screens/Chat/mainchat.dart';
import 'package:tasali/Screens/Edits/Edit_profile.dart';
import 'package:tasali/Screens/Jokes/jokes_screen.dart';
import 'package:tasali/Screens/Likedposts/likedpost.dart';
import 'package:tasali/Screens/Profile_Screen/Profile_Screen.dart';
import 'package:tasali/Screens/Settings/setting.dart';
import 'package:tasali/Screens/SignIn_Screen/SignIn_Screen.dart';
import 'package:tasali/Screens/Videos/Videos_screen.dart';
import 'package:tasali/Screens/home/home.dart';
import '../Models/UserModels.dart';

const side = SideState.RIGHT;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int tabIndex = 0;
  late TabController tabController =
      TabController(length: 4, vsync: this, initialIndex: tabIndex);
  User? user = FirebaseAuth.instance.currentUser;

  UserModel loggedinUser = UserModel();

  void updatefeildf(id, fp) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({'funpoints': fp - 1});
  }

  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(minutes: 1),
      () => updatefeildf(loggedinUser.uid, loggedinUser.funpoints),
    );

    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedinUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CircleNavBar(
        activeIcons: [
          Icon(
            Icons.video_camera_back,
            color: Colors.purple,
            size: 35,
          ),
          Image.asset(
            'assets/1.png',
            width: 30,
          ),
          Image.asset(
            'assets/2.png',
            width: 30,
          ),
          Icon(
            Icons.message,
            size: 35,
            color: Colors.blue,
          ),
        ],
        inactiveIcons: const [
          Text("Videos"),
          Text("Memes"),
          Text("Jokes"),
          Text("Chat"),
        ],
        color: Colors.white,
        height: 60,
        circleWidth: 60,
        initIndex: tabIndex,
        onChanged: (v) {
          tabIndex = v;
          tabController.animateTo(v);
          setState(() {});
        },
        // tabCurve: ,
        cornerRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
        shadowColor: Colors.deepPurple,
        elevation: 10,
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          const Video_Screen(),
          home_Screen(),
          const Jokes_screen(),
          mainchat(),
        ],
      ),
    );
  }
}

class ContentWidget extends StatelessWidget {
  const ContentWidget({Key? key, this.alignment = Alignment.center})
      : super(key: key);

  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: SizedBox(
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              Center(
                child: ListTile(
                  onTap: () {
                    Get.to(
                      const Profile_Screen(),
                    );
                  },
                  leading: const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Get.to(settingscreen());
                },
                leading: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                title: Text(
                  'Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                onTap: (() => Get.to(
                      likedposts(),
                    )),
                leading: Icon(
                  Icons.thumb_up,
                  color: Colors.white,
                ),
                title: Text(
                  'Liked',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Rate Us'),
                        titlePadding: EdgeInsets.only(top: 5, left: 110),
                        content: Rate(
                          allowHalf: true,
                          iconSize: 30,
                          color: Colors.purple,
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Done'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          ),
                        ],
                      );
                    },
                  );
                },
                leading: Icon(
                  Icons.star,
                  color: Colors.white,
                ),
                title: Text(
                  'Reviews',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Get.to(
                    Edit_Profile(),
                  );
                },
                leading: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                title: Text(
                  'Edit Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 45),
              ListTile(
                onTap: () {
                  loggout(context);
                },
                leading: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                title: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loggout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Sign_In()));
  }
}
