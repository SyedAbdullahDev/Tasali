// ignore_for_file: camel_case_types, file_names

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:tale_drawer/tale_drawer.dart';
import 'package:tasali/Models/UserModels.dart';
import 'package:tasali/Models/bvid.dart';
import 'package:tasali/Page/Page.dart';
import 'package:tasali/Page/r.dart';
import 'package:tasali/Screens/Videos/addvideo.dart';
import 'package:tasali/Widgets/comment.dart';
import 'package:tasali/Widgets/video.dart';

class Video_Screen extends StatefulWidget {
  const Video_Screen({Key? key}) : super(key: key);

  @override
  State<Video_Screen> createState() => _Video_ScreenState();
}

class _Video_ScreenState extends State<Video_Screen> {
  final CollectionReference _video =
      FirebaseFirestore.instance.collection('videos');
  User? user = FirebaseAuth.instance.currentUser;
  final controller = TaleController();

  int rewardedadScore = 0;
  UserModel loggedinUser = UserModel();
  TextEditingController reportcon = TextEditingController();
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 65),
      () => updatefeildf(loggedinUser.uid, loggedinUser.funpoints),
    );
    Timer(
      const Duration(minutes: 3),
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

  void updatefeildf(id, fp) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({'funpoints': fp - 1});
  }

  void updatefeildfrr(id, fp) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({'funpoints': fp + 7});
    Get.to(reloood());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _video.orderBy('name', descending: false).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return TaleDrawer(
              type: TaleType.Zoom,
              drawerBackground: Colors.orange.shade400,
              drawer: ContentWidget(
                alignment: side == SideState.LEFT
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
              ),
              sideState: side,
              controller: controller,
              body: Scaffold(
                  appBar: AppBar(
                    leading: IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        controller.start();
                      },
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 0),
                        child: FloatingActionButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: SizedBox(
                                    height: 52,
                                    child: Center(
                                      child: Text(
                                        "Upload content to increase your Fun Score.",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Icon(Icons.add),
                          backgroundColor: Colors.orange,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: SizedBox(
                                  height: 52,
                                  child: Center(
                                    child: Text(
                                      "Upload content to increase your Fun Score.",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Padding(
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
                        ),
                      )
                    ],
                    backgroundColor: const Color.fromARGB(255, 111, 12, 180),
                    title: Image.asset(
                      'assets/logo.png',
                      width: 52,
                    ),
                    centerTitle: false,
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => addvideo(),
                        ),
                      );
                    },
                    backgroundColor: Colors.orange.shade400,
                    child: Icon(Icons.add),
                  ),
                  body: PageView.builder(
                    itemCount: streamSnapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot =
                          streamSnapshot.data!.docs[index];
                      return Stack(
                        children: [
                          SizedBox(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child: FeedItem(
                                url: documentSnapshot['video'],
                              )),
                          Positioned(
                            bottom: 25,
                            left: 10,
                            child: Image.asset(
                              'assets/tlogo.png',
                              colorBlendMode: BlendMode.modulate,
                              width: 50,
                            ),
                          ),
                          Positioned(
                            bottom: 130,
                            right: 20,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(
                                    documentSnapshot['profilepic'],
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                GestureDetector(
                                  child: LikeButton(
                                    size: 40,
                                    likeBuilder: (isLiked) {
                                      return GestureDetector(
                                        onTap: () {
                                          updatefeild(
                                            documentSnapshot['video'],
                                            loggedinUser.uid,
                                            documentSnapshot['name'],
                                            documentSnapshot['profilepic'],
                                          );
                                          setState(() {
                                            isLiked = true;
                                          });
                                        },
                                        child: Icon(
                                          Icons.favorite,
                                          color: isLiked
                                              ? Colors.red
                                              : Colors.white,
                                          size: 40,
                                        ),
                                      );
                                    },
                                    countPostion: CountPostion.bottom,
                                    likeCount: 1,
                                    animationDuration: Duration(
                                      milliseconds: 1000,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 35,
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.to(cTestMe());
                                  },
                                  child: Icon(
                                    Icons.comment,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            AlertDialog(
                                              title: TextFormField(
                                                autofocus: false,
                                                controller: reportcon,
                                                maxLines: 5,
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                onSaved: (value) {
                                                  reportcon.text = value!;
                                                },
                                                textInputAction:
                                                    TextInputAction.next,
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .fromLTRB(
                                                            20, 15, 20, 15),
                                                    hintText: "Report",
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10))),
                                              ),
                                              content: ElevatedButton(
                                                onPressed: () {
                                                  updatefeildvidreport(
                                                      streamSnapshot.data!
                                                          .docs[index].id);
                                                },
                                                child: Text(
                                                  'Report',
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Icon(
                                    Icons.report,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 35,
                                ),
                                InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext bc) {
                                        return Container(
                                          child: new Wrap(
                                            children: <Widget>[
                                              new ListTile(
                                                leading: new Icon(Icons
                                                    .app_blocking_outlined),
                                                title:
                                                    new Text('Block Content'),
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Center(
                                                          child: Text(
                                                              'Are you sure?'),
                                                        ),
                                                        actions: [
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              uploadimageMethod(
                                                                documentSnapshot[
                                                                    'video'],
                                                                documentSnapshot[
                                                                    'name'],
                                                                documentSnapshot[
                                                                    'profilepic'],
                                                              );
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "videos")
                                                                  .doc(
                                                                      documentSnapshot
                                                                          .id)
                                                                  .delete();
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          "Content has been blocked Successfully");
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text(
                                                              'YES',
                                                            ),
                                                          ),
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text(
                                                              'NO',
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                              new ListTile(
                                                leading: new Icon(Icons.block),
                                                title: new Text('Block User'),
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Center(
                                                          child: Text(
                                                              'Are you sure?'),
                                                        ),
                                                        actions: [
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              uploadimageMethod(
                                                                documentSnapshot[
                                                                    'video'],
                                                                documentSnapshot[
                                                                    'name'],
                                                                documentSnapshot[
                                                                    'profilepic'],
                                                              );
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "videos")
                                                                  .doc(
                                                                      documentSnapshot
                                                                          .id)
                                                                  .delete();
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          "User has been blocked Successfully");
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text(
                                                              'YES',
                                                            ),
                                                          ),
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text(
                                                              'NO',
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Icon(
                                    Icons.more_vert,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                    scrollDirection: Axis.vertical,
                  )),
            );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurple,
              ),
            ),
          );
        });
  }

  void updatefeild(
    joke,
    id,
    name,
    pic,
  ) {
    FirebaseFirestore.instance.collection('likedvideo').doc().set({
      'joke': joke,
      'uid': id,
      'name': name,
      'pic': pic,
    });
  }

  void updatefeildvidreport(id) {
    FirebaseFirestore.instance.collection('videos').doc(id).update({
      'report': true,
      'reportdesc': reportcon.text,
    });
    Fluttertoast.showToast(msg: "Content has been reported Sucessfully");
    Navigator.pop(context);
  }

  uploadimageMethod(video, name, profilepic) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    bvideomodel videooomoo = bvideomodel();
    videooomoo.video = video;
    videooomoo.name = name;
    videooomoo.islike = false;
    videooomoo.reportdesc = 'null';
    videooomoo.report = false;
    videooomoo.profilepic = profilepic;
    videooomoo.viduid = name;
    videooomoo.buid = loggedinUser.uid;
    await firebaseFirestore
        .collection('blockvideos')
        .doc()
        .set(videooomoo.tomap());
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: ((context) => const MyHomePage()),
      ),
    );
  }
}
