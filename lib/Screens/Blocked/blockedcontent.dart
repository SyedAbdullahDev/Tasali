import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:tasali/Screens/Blocked/blockedjokes.dart';
import 'package:tasali/Screens/Blocked/blockedmemes.dart';
import 'package:tasali/Screens/Blocked/blockedvideo.dart';

class Blockcontent extends StatefulWidget {
  const Blockcontent({super.key});

  @override
  State<Blockcontent> createState() => _BlockcontentState();
}

class _BlockcontentState extends State<Blockcontent>
    with SingleTickerProviderStateMixin {
  int tabIndex = 0;
  late TabController tabController =
      TabController(length: 3, vsync: this, initialIndex: tabIndex);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blocked Conent'),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey.shade200,
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
        ],
        inactiveIcons: const [
          Text("Videos"),
          Text("Memes"),
          Text("Jokes"),
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
          Block_Videos(),
          Block_Memes(),
          Block_jokes(),
        ],
      ),
    );
  }
}
