// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tasali/Models/UserModels.dart';
import 'package:tasali/Models/memesmodel.dart';

class Block_Memes extends StatefulWidget {
  Block_Memes({Key? key}) : super(key: key);

  @override
  State<Block_Memes> createState() => _Block_MemesState();
}

class _Block_MemesState extends State<Block_Memes> {
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

  final CollectionReference _memes =
      FirebaseFirestore.instance.collection('blockmemes');
  TextEditingController reportcon = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _memes.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          return Scaffold(
            body: ListView.builder(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return documentSnapshot['buid'] == loggedinUser.uid
                    ? Column(
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
                              GestureDetector(
                                onTap: () {
                                  deletejokef(documentSnapshot.id,documentSnapshot['meme'],documentSnapshot['name'],documentSnapshot['profilepic'],);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Unblock',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.grey),
                                  ),
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

  void deletejokef(id,meme,name,pic) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    mememodel memeMOdels = mememodel();
    memeMOdels.meme = meme;
    memeMOdels.islike = false;
    memeMOdels.memeuid =name;
    memeMOdels.report = false;
    memeMOdels.reportdesc = 'null';
    memeMOdels.name = name;
    memeMOdels.profilepic = pic;

    await firebaseFirestore.collection('memes').doc().set(memeMOdels.tomap());
    FirebaseFirestore.instance.collection("blockmemes").doc(id).delete();
    Fluttertoast.showToast(msg: "Meme Unblocked Successfully");
  }
}
