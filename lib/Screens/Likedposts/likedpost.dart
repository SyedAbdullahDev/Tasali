import 'package:flutter/material.dart';
import 'package:tasali/Screens/Likedposts/likedjokes.dart';
import 'package:tasali/Screens/Likedposts/likedmeme.dart';
import 'package:tasali/Screens/Likedposts/likevideos.dart';

class likedposts extends StatefulWidget {
  const likedposts({Key? key}) : super(key: key);

  @override
  State<likedposts> createState() => _likedpostsState();
}

class _likedpostsState extends State<likedposts> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Image.asset(
            'assets/logo.png',
            width: 52,
          ),
          backgroundColor: const Color.fromARGB(255, 111, 12, 180),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: "Jokes"),
              Tab(text: "Memes"),
              Tab(text: "Videos"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Likedjoke(),
            Likedmeme(),
            Likedvideos(),
          ],
        ),
      ),
    );
  }
}
