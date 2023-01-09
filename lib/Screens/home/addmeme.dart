import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tasali/Models/UserModels.dart';
import 'package:tasali/Models/memesmodel.dart';
import 'package:tasali/Page/Page.dart';

class Addmemes extends StatefulWidget {
  const Addmemes({Key? key}) : super(key: key);

  @override
  State<Addmemes> createState() => _AddmemesState();
}

class _AddmemesState extends State<Addmemes> {
  File? _image;
  String? downloadurl;
  final imagePicker = ImagePicker();

  Future imagePickerMethod() async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);

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
        title: Text('Upload a Meme'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Upload a Meme",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 200,
              width: 300,
              child: _image == null
                  ? Image.network(
                      'https://firebasestorage.googleapis.com/v0/b/tasali-app.appspot.com/o/logo.png?alt=media&token=e3a44173-df54-491d-a9fb-de2f2cf943c8',
                      fit: BoxFit.contain,
                    )
                  : Image.file(
                      _image!,
                      fit: BoxFit.contain,
                    ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                imagePickerMethod();
              },
              child: Text(
                'Select Image',
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
                'Upload Image',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updatefeildf(id, fp) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({'funpoints': fp + 10});
  }

  uploadimageMethod(idd, fpp) async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("memes/")
        .child(DateTime.now().toString());
    await ref.putFile(_image!);
    downloadurl = await ref.getDownloadURL();
    print(downloadurl);
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    mememodel memeMOdels = mememodel();
    memeMOdels.meme = downloadurl;
    memeMOdels.islike = false;
    memeMOdels.memeuid = loggedinUser.uid;
    memeMOdels.report = false;
    memeMOdels.reportdesc = 'null';
    memeMOdels.name = loggedinUser.firstname;
    memeMOdels.profilepic = loggedinUser.pic;

    await firebaseFirestore.collection('memes').doc().set(memeMOdels.tomap());
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: ((context) => const MyHomePage()),
      ),
    );
    updatefeildf(idd, fpp);
  }
}
