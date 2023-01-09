import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus_dialog/share_plus_dialog.dart';
import 'package:tasali/Models/UserModels.dart';

class profilejoke extends StatefulWidget {
  const profilejoke({Key? key}) : super(key: key);

  @override
  State<profilejoke> createState() => _profilejokeState();
}

class _profilejokeState extends State<profilejoke> {
  final CollectionReference _jok =
      FirebaseFirestore.instance.collection('joke');
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
          return Scaffold(
            body: ListView.builder(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return documentSnapshot['jokeuid'] == "${loggedinUser.uid}"
                    ? Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Card(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                SizedBox(
                                  child: Text(
                                    documentSnapshot['joke'],
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        deletejokef(streamSnapshot
                                            .data!.docs[index].id);
                                      },
                                      icon: Icon(Icons.delete),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        final jokeshare =
                                            documentSnapshot['joke'];
                                        ShareDialog.share(context, '$jokeshare',
                                            platforms: SharePlatform.defaults);
                                      },
                                      icon: Icon(Icons.share),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : SizedBox(
                        width: 0,
                      );
              },
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

  void deletejokef(id) {
    FirebaseFirestore.instance.collection("joke").doc(id).delete();
    Fluttertoast.showToast(msg: "Joke deleted Successfully");
  }
}
