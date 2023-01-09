import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tasali/Models/UserModels.dart';

class Edit_Profile extends StatefulWidget {
  const Edit_Profile({Key? key}) : super(key: key);

  @override
  State<Edit_Profile> createState() => _Edit_ProfileState();
}

class _Edit_ProfileState extends State<Edit_Profile> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController namecontroller = TextEditingController();
  File? _image;
  String? downloadurl;

  User? user = FirebaseAuth.instance.currentUser;

  UserModel loggedinUser = UserModel();
  final imagePicker = ImagePicker();
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

  final TextEditingController usernamecontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 111, 12, 180),
        title: Image.asset(
          'assets/logo.png',
          width: 52,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              UpdateprofileEdit();
            },
            icon: Icon(Icons.done),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        imagePickerMethod();
                      },
                      child: CircleAvatar(
                        radius: 50,
                        child: _image == null
                            ? Image.network(
                                'https://firebasestorage.googleapis.com/v0/b/tasali-app.appspot.com/o/logo.png?alt=media&token=e3a44173-df54-491d-a9fb-de2f2cf943c8',
                                fit: BoxFit.contain,
                              )
                            : Image.file(
                                _image!,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30),
                child: TextFormField(
                  autofocus: false,
                  controller: namecontroller,
                  onSaved: (value) {
                    namecontroller.text = value!;
                  },
                  validator: (value) {
                    RegExp regex = RegExp(r'^.{3,}$');
                    if (value!.isEmpty) {
                      return ("Please Enter  Name");
                    }
                    if (!regex.hasMatch(value)) {
                      return ("Please Enter Valid name");
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    hintText: " Name",
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30),
                child: TextFormField(
                  autofocus: false,
                  controller: usernamecontroller,
                  onSaved: (value) {
                    usernamecontroller.text = value!;
                  },
                  validator: (value) {
                    RegExp regex = RegExp(r'^.{3,}$');
                    if (value!.isEmpty) {
                      return ("Please Enter Username");
                    }
                    if (!regex.hasMatch(value)) {
                      return ("Please Enter Valid username");
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.alternate_email),
                    contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    hintText: "Username",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  UpdateprofileEdit() async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("profilepic/")
        .child(DateTime.now().toString());
    await ref.putFile(_image!);
    downloadurl = await ref.getDownloadURL();
    print(downloadurl);
    FirebaseFirestore.instance
        .collection('users')
        .doc(loggedinUser.uid)
        .update({
      'pic': downloadurl,
      'firstName': namecontroller.text,
      'username': '@${usernamecontroller.text}',
    });
    Fluttertoast.showToast(msg: "Content has been reported Sucessfully");
    Navigator.pop(context);
  }
}
