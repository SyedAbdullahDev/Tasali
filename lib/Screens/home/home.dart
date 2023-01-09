// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, camel_case_types

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:tale_drawer/tale_drawer.dart';
import 'package:tasali/Models/UserModels.dart';
import 'package:tasali/Models/bmeme.dart';
import 'package:tasali/Page/Page.dart';
import 'package:tasali/Page/r.dart';
import 'package:tasali/Screens/home/addmeme.dart';
import 'package:tasali/Widgets/comment.dart';

class home_Screen extends StatefulWidget {
  home_Screen({Key? key}) : super(key: key);

  @override
  State<home_Screen> createState() => _home_ScreenState();
}

class _home_ScreenState extends State<home_Screen> {
  User? user = FirebaseAuth.instance.currentUser;

  UserModel loggedinUser = UserModel();
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

  final controller = TaleController();

  int rewardedadScore = 0;
  final CollectionReference _memes =
      FirebaseFirestore.instance.collection('memes');
  TextEditingController reportcon = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _memes.orderBy('name', descending: true).snapshots(),
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
                  Get.to(Addmemes());
                },
                backgroundColor: Colors.orange.shade400,
                child: Icon(Icons.add),
              ),
              body: ListView.builder(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(
                                      documentSnapshot['profilepic']),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    documentSnapshot['name'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '1d',
                              style:
                                  TextStyle(fontSize: 17, color: Colors.grey),
                            ),
                          )
                        ],
                      ),
                      Stack(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: FancyShimmerImage(
                              boxFit: BoxFit.fill,
                              errorWidget: Image.network(
                                  'https://i0.wp.com/www.dobitaobyte.com.br/wp-content/uploads/2016/02/no_image.png?ssl=1'),
                              imageUrl: documentSnapshot['meme'],
                            ),
                          ),
                          Positioned(
                            bottom: 18,
                            right: 10,
                            child: Image.asset(
                              'assets/tlogo.png',
                              colorBlendMode: BlendMode.modulate,
                              width: 50,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                LikeButton(
                                  size: 40,
                                  likeBuilder: (isLiked) {
                                    return GestureDetector(
                                      onTap: () {
                                        updatefeild(
                                          documentSnapshot['meme'],
                                          loggedinUser.uid,
                                          documentSnapshot['name'],
                                          documentSnapshot['profilepic'],
                                        );
                                      },
                                      child: Icon(
                                        isLiked
                                            ? Icons.favorite
                                            : Icons.favorite_outline,
                                        color:
                                            isLiked ? Colors.red : Colors.black,
                                        size: 28,
                                      ),
                                    );
                                  },
                                  countPostion: CountPostion.right,
                                  likeCount: 1,
                                  animationDuration: Duration(
                                    milliseconds: 1000,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Get.to(cTestMe());
                                  },
                                  icon: Icon(Icons.comment_outlined),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
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
                                                  keyboardType: TextInputType
                                                      .emailAddress,
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
                                                      border:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10))),
                                                ),
                                                content: ElevatedButton(
                                                  onPressed: () {
                                                    updatefeildmreport(
                                                      streamSnapshot
                                                          .data!.docs[index].id,
                                                    );
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
                                    icon: Icon(
                                      Icons.report,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 7,
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
                                                      builder: (BuildContext
                                                          context) {
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
                                                                        'meme'],
                                                                    documentSnapshot[
                                                                        'name'],
                                                                    documentSnapshot[
                                                                        'profilepic']);
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        "memes")
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
                                                  leading:
                                                      new Icon(Icons.block),
                                                  title: new Text('Block User'),
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
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
                                                                        'meme'],
                                                                    documentSnapshot[
                                                                        'name'],
                                                                    documentSnapshot[
                                                                        'profilepic']);
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        "memes")
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
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 8,
                        thickness: 3,
                        color: Colors.grey.shade300,
                      ),
                      Divider(
                        height: 8,
                        thickness: 9,
                        color: Colors.grey.shade500,
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(
            color: Colors.deepPurple,
          ),
        );
      },
    );
  }

  void updatefeild(
    joke,
    id,
    name,
    pic,
  ) {
    FirebaseFirestore.instance.collection('likedmeme').doc().set({
      'meme': joke,
      'uid': id,
      'name': name,
      'pic': pic,
    });
  }

  void deletevidf(id) {
    FirebaseFirestore.instance.collection("memes").doc(id).delete();
    Fluttertoast.showToast(msg: "Content has been blocked Successfully");
  }

  void updatefeildmreport(id) {
    FirebaseFirestore.instance
        .collection('memes')
        .doc(id)
        .update({'report': true, 'reportdesc': reportcon.text});
    Fluttertoast.showToast(msg: "Content has been reported Sucessfully");
    Navigator.pop(context);
  }

  uploadimageMethod(meme, uid, pic) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    bmememodel memeMOdels = bmememodel();
    memeMOdels.meme = meme;
    memeMOdels.islike = false;
    memeMOdels.memeuid = uid;
    memeMOdels.report = false;
    memeMOdels.reportdesc = 'null';
    memeMOdels.name = uid;
    memeMOdels.buid = loggedinUser.uid;

    memeMOdels.profilepic = pic;

    await firebaseFirestore
        .collection('blockmemes')
        .doc()
        .set(memeMOdels.tomap());
  }
}
