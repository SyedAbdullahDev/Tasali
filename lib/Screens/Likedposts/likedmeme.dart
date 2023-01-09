import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tasali/Models/UserModels.dart';

class Likedmeme extends StatefulWidget {
  const Likedmeme({Key? key}) : super(key: key);

  @override
  State<Likedmeme> createState() => _LikedmemeState();
}

class _LikedmemeState extends State<Likedmeme> {
  final CollectionReference _memmme =
      FirebaseFirestore.instance.collection('likedmeme');
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
      stream: _memmme.snapshots(),
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
                              Divider(
                                thickness: 5,
                                color: Colors.grey.shade500,
                              ),
                            ],
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
    FirebaseFirestore.instance.collection('likedmeme').doc(id).delete();
    Fluttertoast.showToast(msg: 'Removed from liked');
  }
}
