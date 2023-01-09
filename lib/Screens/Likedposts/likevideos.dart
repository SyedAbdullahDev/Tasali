import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tasali/Models/UserModels.dart';
import 'package:tasali/Widgets/video.dart';

class Likedvideos extends StatefulWidget {
  const Likedvideos({Key? key}) : super(key: key);

  @override
  State<Likedvideos> createState() => _LikedvideosState();
}

class _LikedvideosState extends State<Likedvideos> {
  final CollectionReference _video =
      FirebaseFirestore.instance.collection('likedvideo');
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _video.snapshots(),
        builder: (
          context,
          AsyncSnapshot<QuerySnapshot> streamSnapshot,
        ) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return documentSnapshot['uid'] == loggedinUser.uid
                    ? Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox(
                                height: 300,
                                width: MediaQuery.of(context).size.width-10,
                                child: FeedItem(
                                  url: documentSnapshot['joke'],
                                )),
                          ),
                          Positioned(
                            bottom: 8,
                            right: 6,
                            child: IconButton(
                              onPressed: () {
                                deletefield(
                                  documentSnapshot.id,
                                );
                              },
                              icon: Icon(
                                Icons.remove_circle,
                                color: Colors.red,
                                size: 28,
                              ),
                            ),
                          ),
                        ],
                      )
                    : SizedBox(
                        width: 0,
                      );
              },
              scrollDirection: Axis.vertical,
            );
          }
          return Center(
            child: CircularProgressIndicator(
              color: Colors.deepPurple,
            ),
          );
        });
  }

  void deletefield(id) {
    FirebaseFirestore.instance.collection('likedvideo').doc(id).delete();
    Fluttertoast.showToast(msg: 'Removed from liked');
  }
}
