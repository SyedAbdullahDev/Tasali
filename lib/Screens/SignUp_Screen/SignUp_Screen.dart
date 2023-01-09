// ignore_for_file: camel_case_types, file_names, use_build_context_synchronously

import 'package:checkbox_formfield/checkbox_list_tile_formfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tasali/Models/UserModels.dart';
import 'package:tasali/Screens/Conditions/Terms.dart';
import 'package:url_launcher/url_launcher.dart';

import '../SignIn_Screen/SignIn_Screen.dart';

class Sign_Up extends StatefulWidget {
  const Sign_Up({Key? key}) : super(key: key);

  @override
  State<Sign_Up> createState() => _Sign_UpState();
}

class _Sign_UpState extends State<Sign_Up> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    //--------------------------------First Name
    final firstnamefeild = TextFormField(
      autofocus: false,
      controller: firstnameController,
      onSaved: (value) {
        firstnameController.text = value!;
      },
      validator: (value) {
        RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Please Enter First Name");
        }
        if (!regex.hasMatch(value)) {
          return ("Please Enter Valid Name name");
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.person),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "First Name",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
    //--------------------------------Last Name
    final lastnamefeild = TextFormField(
      autofocus: false,
      controller: lastnameController,
      onSaved: (value) {
        lastnameController.text = value!;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter last Name");
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.person),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Last Name",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
    //--------------------------------Email
    final emailfeild = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) {
        emailController.text = value!;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter Email");
        }
        String pattern = r'\w+@\w+\.\w+';
        if (!RegExp(pattern).hasMatch(value)) {
          return 'Invalid Email format';
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "E mail",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );
    //--------------------------------Password
    final passwordfeild = TextFormField(
      autofocus: false,
      obscureText: true,
      controller: passwordController,
      onSaved: (value) {
        passwordController.text = value!;
      },
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Please Enter Password");
        }
        if (!regex.hasMatch(value)) {
          return ("Please Enter Valid Password(Min 6 character)");
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.vpn_key),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
    //--------------------------------Confirm Password
    final confirmpassword = TextFormField(
      autofocus: false,
      obscureText: true,
      controller: confirmpasswordController,
      onSaved: (value) {
        confirmpasswordController.text = value!;
      },
      validator: (value) {
        if (confirmpasswordController.text != passwordController.text) {
          return "Password dont Match";
        }
        return null;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Confirm Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
    //--------------------------------Button
    final loginbutton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: const Color.fromARGB(255, 111, 12, 180),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signUp(emailController.text, passwordController.text);
        },
        child: const Text(
          "Sign Up",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 150,
                      child: Image.asset(
                        "assets/logo.png",
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    firstnamefeild,
                    const SizedBox(
                      height: 20,
                    ),
                    lastnamefeild,
                    const SizedBox(
                      height: 20,
                    ),
                    emailfeild,
                    const SizedBox(
                      height: 20,
                    ),
                    passwordfeild,
                    const SizedBox(
                      height: 20,
                    ),
                    confirmpassword,
                    const SizedBox(
                      height: 16,
                    ),
                    InkWell(
                      onTap: () async {
                        final Uri url = Uri.parse(
                            'https://tasali.app/terms-and-conditions/');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          throw "Could not launch $url";
                        }
                      },
                      child: Text(
                        'Click here to read terms & conditions',
                        style: TextStyle(
                          color: Color.fromARGB(255, 111, 12, 180),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    CheckboxListTileFormField(
                      initialValue: false,
                      controlAffinity: ListTileControlAffinity.leading,
                      onSaved: (bool? value) {
                        print(value);
                      },
                      validator: (bool? value) {
                        if (value!) {
                          return null;
                        } else {
                          return 'Please Check the Box';
                        }
                      },
                      onChanged: (value) {
                        if (value) {
                          print("ListTile Checked :)");
                        } else {
                          print("ListTile Not Checked :(");
                        }
                      },
                      autovalidateMode: AutovalidateMode.always,
                      title: Text('I agree all the terms & conditons'),
                      activeColor: Color.fromARGB(255, 111, 12, 180),
                      checkColor: Colors.white,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    loginbutton,
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account?'),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const Sign_In(),
                              ),
                            );
                          },
                          child: const Text(
                            " Login",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 111, 12, 180),
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool isClick = false;
  signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((uid) => {postDetailsToFirebase()})
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  //postDetailsToFirebase
  postDetailsToFirebase() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    UserModel userModel = UserModel();
    userModel.email = user!.email;
    userModel.pic =
        'https://firebasestorage.googleapis.com/v0/b/tasali-app.appspot.com/o/logo.png?alt=media&token=e3a44173-df54-491d-a9fb-de2f2cf943c8';
    userModel.uid = user.uid;
    userModel.firstname = firstnameController.text;
    userModel.lastname = lastnameController.text;
    userModel.bio = 'I am new user';
    userModel.follower = 1;
    userModel.username = '@newusser76';
    userModel.funpoints = 60;

    await firebaseFirestore
        .collection('users')
        .doc(user.uid)
        .set(userModel.tomap());
    Fluttertoast.showToast(msg: "Account created successfully");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const TermConditonsScreen(),
      ),
    );
  }
}
