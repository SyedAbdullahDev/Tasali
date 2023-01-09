import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:share_plus_dialog/share_plus_dialog.dart';
import 'package:tasali/Models/UserModels.dart';
import 'package:tasali/Screens/Profile_Screen/fullmemepage.dart';

class profilememe extends StatefulWidget {
  const profilememe({
    Key? key,
  }) : super(key: key);

  @override
  State<profilememe> createState() => _profilememeState();
}

class _profilememeState extends State<profilememe> {
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

  final CollectionReference _memmme =
      FirebaseFirestore.instance.collection('memes');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _memmme.snapshots(),
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
                return documentSnapshot['memeuid'] == "${loggedinUser.uid}"
                    ? GestureDetector(
                        onTap: () {
                          Get.to(
                            fullpagememe(
                              memeurrl: documentSnapshot['meme'],
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      deletemf(
                                          streamSnapshot.data!.docs[index].id);
                                    },
                                    icon: Icon(Icons.delete),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      final memesh = documentSnapshot['meme'];
                                      ShareDialog.share(context, '$memesh',
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

  void deletemf(id) {
    FirebaseFirestore.instance.collection("memes").doc(id).delete();
    Fluttertoast.showToast(msg: "Meme deleted Successfully");
  }
}
