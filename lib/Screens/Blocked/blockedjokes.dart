// ignore_for_file: camel_case_types
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tasali/Models/UserModels.dart';
import 'package:tasali/Models/jokemodel.dart';

class Block_jokes extends StatefulWidget {
  const Block_jokes({Key? key}) : super(key: key);

  @override
  State<Block_jokes> createState() => _Block_jokesState();
}

class _Block_jokesState extends State<Block_jokes> {
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

  final CollectionReference _jokes =
      FirebaseFirestore.instance.collection('blockjoke');
  TextEditingController reportcon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _jokes.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          return Scaffold(
            body: ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return documentSnapshot['buid'] == loggedinUser.uid
                    ? Padding(
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
                                  SizedBox(
                                    height: 5,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        deletejokef(documentSnapshot.id,documentSnapshot['joke'],documentSnapshot['name'],documentSnapshot['profilepic']);
                                      },
                                      child: Text('Unblock'))
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox();
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

  void deletejokef(id, joke, name, pic) async{
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    jokemodel jokemodelfire = jokemodel();
    jokemodelfire.joke = joke;
    jokemodelfire.islike = false;
    jokemodelfire.report = false;
    jokemodelfire.reportdesc = 'null';
    jokemodelfire.name = name;
    jokemodelfire.jokeuid = name;
    jokemodelfire.profilepic = pic;
    await firebaseFirestore.collection('joke').doc().set(jokemodelfire.tomap());
    FirebaseFirestore.instance.collection("blockjoke").doc(id).delete();
    Fluttertoast.showToast(msg: "Joke Unblocked Successfully");
  }
}
