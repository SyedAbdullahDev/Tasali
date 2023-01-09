// ignore_for_file: camel_case_types
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:tale_drawer/tale_drawer.dart';
import 'package:tasali/Models/UserModels.dart';
import 'package:tasali/Models/bjoke.dart';
import 'package:tasali/Page/Page.dart';
import 'package:tasali/Screens/Jokes/addjoke.dart';
import 'package:tasali/Widgets/comment.dart';

class Jokes_screen extends StatefulWidget {
  const Jokes_screen({Key? key}) : super(key: key);

  @override
  State<Jokes_screen> createState() => _Jokes_screenState();
}

class _Jokes_screenState extends State<Jokes_screen> {
  User? user = FirebaseAuth.instance.currentUser;
  void updatefeildf(id, fp) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({'funpoints': fp - 1});
  }

  final controller = TaleController();

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

  final CollectionReference _jokes =
      FirebaseFirestore.instance.collection('joke');
  TextEditingController reportcon = TextEditingController();

  int rewardedadScore = 0;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _jokes.orderBy('name', descending: true).snapshots(),
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
                            content:SizedBox(
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
                  Get.to(
                    Add_jokes(),
                  );
                },
                backgroundColor: Colors.orange,
                child: Icon(Icons.add),
              ),
              body: ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SizedBox(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: CircleAvatar(
                                          radius: 25,
                                          backgroundImage: NetworkImage(
                                            documentSnapshot['profilepic'],
                                          ),
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                ],
                              ),
                              Text(
                                documentSnapshot['joke'],
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      LikeButton(
                                        size: 40,
                                        likeBuilder: (isLiked) {
                                          return GestureDetector(
                                            onTap: () {
                                              updatefeild(
                                                documentSnapshot['joke'],
                                                loggedinUser.uid,
                                                documentSnapshot['name'],
                                                documentSnapshot['profilepic'],
                                              );
                                            },
                                            child: Icon(
                                              isLiked
                                                  ? Icons.favorite
                                                  : Icons.favorite_outline,
                                              color: isLiked
                                                  ? Colors.red
                                                  : Colors.black,
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
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
                                                        keyboardType:
                                                            TextInputType
                                                                .emailAddress,
                                                        onSaved: (value) {
                                                          reportcon.text =
                                                              value!;
                                                        },
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                        decoration: InputDecoration(
                                                            contentPadding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    20,
                                                                    15,
                                                                    20,
                                                                    15),
                                                            hintText: "Report",
                                                            border: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10))),
                                                      ),
                                                      content: ElevatedButton(
                                                        onPressed: () {
                                                          updatefeildrep(
                                                              streamSnapshot
                                                                  .data!
                                                                  .docs[index]
                                                                  .id);
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
                                                        title: new Text(
                                                            'Block Content'),
                                                        onTap: () {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Center(
                                                                  child: Text(
                                                                      'Are you sure?'),
                                                                ),
                                                                actions: [
                                                                  ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      postDetailsToFirebase(
                                                                        documentSnapshot[
                                                                            'joke'],
                                                                        documentSnapshot[
                                                                            'name'],
                                                                        documentSnapshot[
                                                                            'jokeuid'],
                                                                        documentSnapshot[
                                                                            'profilepic'],
                                                                      );
                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              "joke")
                                                                          .doc(documentSnapshot
                                                                              .id)
                                                                          .delete();
                                                                      Fluttertoast
                                                                          .showToast(
                                                                              msg: "Content has been blocked Successfully");
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: Text(
                                                                      'YES',
                                                                    ),
                                                                  ),
                                                                  ElevatedButton(
                                                                    onPressed:
                                                                        () {
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
                                                        leading: new Icon(
                                                            Icons.block),
                                                        title: new Text(
                                                            'Block User'),
                                                        onTap: () {
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Center(
                                                                  child: Text(
                                                                      'Are you sure?'),
                                                                ),
                                                                actions: [
                                                                  ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      postDetailsToFirebase(
                                                                        documentSnapshot[
                                                                            'joke'],
                                                                        documentSnapshot[
                                                                            'name'],
                                                                        documentSnapshot[
                                                                            'jokeuid'],
                                                                        documentSnapshot[
                                                                            'profilepic'],
                                                                      );
                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              "joke")
                                                                          .doc(documentSnapshot
                                                                              .id)
                                                                          .delete();
                                                                      Fluttertoast
                                                                          .showToast(
                                                                              msg: "User has been blocked Successfully");
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: Text(
                                                                      'YES',
                                                                    ),
                                                                  ),
                                                                  ElevatedButton(
                                                                    onPressed:
                                                                        () {
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
                            ],
                          ),
                        ),
                      ),
                    ),
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
    FirebaseFirestore.instance.collection('likedjokes').doc().set({
      'joke': joke,
      'uid': id,
      'name': name,
      'pic': pic,
    });
  }

  void updatefeildrep(id) {
    FirebaseFirestore.instance
        .collection('joke')
        .doc(id)
        .update({'report': true, 'reportdesc': reportcon.text});
    Fluttertoast.showToast(msg: "Content has been reported Sucessfully");
    Navigator.pop(context);
  }

  void deletevidf(id) {
    FirebaseFirestore.instance.collection("joke").doc(id).delete();
    Fluttertoast.showToast(msg: "Content has been blocked Successfully");
  }

  postDetailsToFirebase(text, name, uid, pic) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    bjokemodel jokemodelfire = bjokemodel();
    jokemodelfire.joke = text;
    jokemodelfire.islike = false;
    jokemodelfire.report = false;
    jokemodelfire.reportdesc = 'null';
    jokemodelfire.name = name;
    jokemodelfire.jokeuid = uid;
    jokemodelfire.profilepic = pic;
    jokemodelfire.buid = loggedinUser.uid;
    await firebaseFirestore
        .collection('blockjoke')
        .doc()
        .set(jokemodelfire.tomap());
  }
}
