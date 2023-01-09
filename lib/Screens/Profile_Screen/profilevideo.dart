import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:share_plus_dialog/share_plus_dialog.dart';
import 'package:tasali/Models/UserModels.dart';
import 'package:tasali/Screens/Profile_Screen/fullviewvideo.dart';
import 'package:tasali/Widgets/video.dart';

class profilevideo extends StatefulWidget {
  const profilevideo({
    Key? key,
  }) : super(key: key);

  @override
  State<profilevideo> createState() => _profilevideoState();
}

class _profilevideoState extends State<profilevideo> {
  User? user = FirebaseAuth.instance.currentUser;

  UserModel loggedinUser = UserModel();

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

  final CollectionReference _video =
      FirebaseFirestore.instance.collection('videos');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _video.snapshots(),
        builder: (
          context,
          AsyncSnapshot<QuerySnapshot> streamSnapshot,
        ) {
          if (streamSnapshot.hasData) {
            return Scaffold(
              body: ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  return documentSnapshot['viduid'] ==
                          "${loggedinUser.firstname}"
                      ? GestureDetector(
                          onTap: () {
                            Get.to(
                              fullpagevid(
                                vidurrl: documentSnapshot['video'],
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                SizedBox(
                                    height: 290,
                                    width: 350,
                                    child: FeedItem(
                                      url: documentSnapshot['video'],
                                    )),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        deletevidf(streamSnapshot
                                            .data!.docs[index].id);
                                      },
                                      icon: Icon(Icons.delete),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        final vidhare =
                                            documentSnapshot['video'];
                                        ShareDialog.share(context, '$vidhare',
                                            platforms: SharePlatform.defaults);
                                      },
                                      icon: Icon(Icons.share),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      : SizedBox(
                          width: 0,
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

  void deletevidf(id) {
    FirebaseFirestore.instance.collection("videos").doc(id).delete();
    Fluttertoast.showToast(msg: "Video deleted Successfully");
  }
}
