import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tasali/Models/UserModels.dart';
import 'package:tasali/Models/vidoemodel.dart';
import 'package:tasali/Page/Page.dart';
import 'package:tasali/Widgets/video.dart';

class addvideo extends StatefulWidget {
  const addvideo({Key? key}) : super(key: key);

  @override
  State<addvideo> createState() => _addvideoState();
}

class _addvideoState extends State<addvideo> {
  File? _image;
  String? downloadurl;
  final imagePicker = ImagePicker();

  Future imagePickerMethod() async {
    final pick = await imagePicker.pickVideo(source: ImageSource.gallery);

    setState(() {
      if (pick != null) {
        _image = File(pick.path);
      } else {
        showSnackbar(
          'No File Selected',
          Duration(
            milliseconds: 500,
          ),
        );
      }
    });
  }

  showSnackbar(String snackText, Duration d) {
    final snackBar = SnackBar(
      content: Text(snackText),
      backgroundColor: Colors.purple,
      duration: d,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Upload a Video'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Upload a Video",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
                height: 300,
                width: 400,
                child: _image == null
                    ? Image.network(
                        'https://firebasestorage.googleapis.com/v0/b/tasali-app.appspot.com/o/logo.png?alt=media&token=e3a44173-df54-491d-a9fb-de2f2cf943c8',
                        fit: BoxFit.contain,
                      )
                    : FeedItem(url: '$downloadurl')),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                imagePickerMethod();
              },
              child: Text(
                'Select Video',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _image == null
                    ? Fluttertoast.showToast(msg: 'No Image Selected')
                    : uploadimageMethod(
                        loggedinUser.uid, loggedinUser.funpoints);
              },
              child: Text(
                'Upload Video',
              ),
            ),
          ],
        ),
      ),
    );
  }

  uploadimageMethod(idd, fpp) async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("videos/")
        .child(DateTime.now().toString());
    await ref.putFile(_image!);
    downloadurl = await ref.getDownloadURL();
    print(downloadurl);
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    videomodel videooomoo = videomodel();
    videooomoo.video = downloadurl;
    videooomoo.name = loggedinUser.firstname;
    videooomoo.islike = false;
    videooomoo.reportdesc = 'null';
    videooomoo.report = false;
    videooomoo.profilepic = loggedinUser.pic;
    videooomoo.viduid = loggedinUser.firstname;
    await firebaseFirestore.collection('videos').doc().set(videooomoo.tomap());
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: ((context) => const MyHomePage()),
      ),
    );
    updatefeildf(idd, fpp);
  }

  void updatefeildf(id, fp) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({'funpoints': fp + 10});
  }
}
