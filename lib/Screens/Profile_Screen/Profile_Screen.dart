// ignore_for_file: camel_case_types, file_names

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasali/Models/UserModels.dart';
import 'package:tasali/Screens/Profile_Screen/profilejoke.dart';
import 'package:tasali/Screens/Profile_Screen/profilememe.dart';
import 'package:tasali/Screens/Profile_Screen/profilevideo.dart';

class Profile_Screen extends StatefulWidget {
  const Profile_Screen({Key? key}) : super(key: key);

  @override
  State<Profile_Screen> createState() => _Profile_ScreenState();
}

class _Profile_ScreenState extends State<Profile_Screen> {
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
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            actions: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.orange.shade400,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      'Fun Score: ${loggedinUser.funpoints}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            ],
            backgroundColor: const Color.fromARGB(255, 111, 12, 180),
            title: Image.asset(
              'assets/logo.png',
              width: 52,
            ),
            centerTitle: false,
            bottom: TabBar(
              tabs: [
                Tab(text: "Memes"),
                Tab(text: "jokes"),
                Tab(text: "Videos"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              profilememe(),
              profilejoke(),
              profilevideo(),
            ],
          ),
        ),
      ),
    );
  }
}
