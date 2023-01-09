import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tasali/Models/UserModels.dart';

class Likedjoke extends StatefulWidget {
  const Likedjoke({Key? key}) : super(key: key);

  @override
  State<Likedjoke> createState() => _LikedjokeState();
}

class _LikedjokeState extends State<Likedjoke> {
  final CollectionReference _jok =
      FirebaseFirestore.instance.collection('likedjokes');
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
      stream: _jok.snapshots(),
      builder: (
        context,
        AsyncSnapshot<QuerySnapshot> streamSnapshot,
      ) {
        if (streamSnapshot.hasData) {
          return ListView.builder(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return documentSnapshot['uid'] == loggedinUser.uid
                    ? Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Card(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: SizedBox(
                                  child: Text(
                                    documentSnapshot['joke'],
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
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

  void deletefield(id) {
    FirebaseFirestore.instance.collection('likedjokes').doc(id).delete();
    Fluttertoast.showToast(msg: 'Removed from liked');
  }
}
