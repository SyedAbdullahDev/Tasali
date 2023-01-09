// ignore_for_file: camel_case_types, file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tasali/Models/UserModels.dart';
import 'package:tasali/Models/vidoemodel.dart';
import 'package:tasali/Widgets/video.dart';

class Block_Videos extends StatefulWidget {
  const Block_Videos({Key? key}) : super(key: key);

  @override
  State<Block_Videos> createState() => _Block_VideosState();
}

class _Block_VideosState extends State<Block_Videos> {
  final CollectionReference _video =
      FirebaseFirestore.instance.collection('blockvideos');
  User? user = FirebaseAuth.instance.currentUser;

  UserModel loggedinUser = UserModel();
  TextEditingController reportcon = TextEditingController();
  @override
  void initState() {
    super.initState();
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
    return StreamBuilder(
        stream: _video.orderBy('name', descending: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return Scaffold(
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
                        ),
                      ),
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
                          bottom: 30,
                          right: 10,
                          child: ElevatedButton(
                              onPressed: () {
                                deletejokef(
                                    documentSnapshot.id,
                                    documentSnapshot['video'],
                                    documentSnapshot['name'],
                                    documentSnapshot['profilepic']);
                              },
                              child: Text('Unblock'))),
                    ],
                  );
                },
                scrollDirection: Axis.vertical,
              ),
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

  void deletejokef(id, video, name, pic) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    videomodel videooomoo = videomodel();
    videooomoo.video = video;
    videooomoo.name = name;
    videooomoo.islike = false;
    videooomoo.reportdesc = 'null';
    videooomoo.report = false;
    videooomoo.profilepic = pic;
    videooomoo.viduid = name;
    await firebaseFirestore.collection('videos').doc().set(videooomoo.tomap());
    FirebaseFirestore.instance.collection("blockvideos").doc(id).delete();
    Fluttertoast.showToast(msg: "Video Unblocked Successfully");
  }
}
