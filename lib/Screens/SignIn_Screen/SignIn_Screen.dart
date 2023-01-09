// ignore_for_file: camel_case_types, file_names, avoid_print, unused_local_variable, use_rethrow_when_possible, prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:tasali/Models/UserModels.dart';
import 'package:tasali/Page/Page.dart';
import 'package:tasali/Screens/ForgotPass_Screen/ForgotPass_Screen.dart';
import 'package:tasali/Screens/SignUp_Screen/SignUp_Screen.dart';

class Sign_In extends StatefulWidget {
  const Sign_In({Key? key}) : super(key: key);

  @override
  State<Sign_In> createState() => _Sign_InState();
}

class _Sign_InState extends State<Sign_In> {
  final _auth = FirebaseAuth.instance;

  appleAuth() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    try {
      // var result = await _googlesigninn.signIn();
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      User? user = _auth.currentUser;
      UserModel userModel = UserModel();
      userModel.email = credential.email;
      // userModel.pic = result.photoUrl;
      // userModel.uid = result.serverAuthCode;
      userModel.firstname = credential.givenName;
      userModel.lastname = credential.familyName;
      userModel.bio = 'I am new user';
      userModel.follower = 1;
      userModel.username = '@newusser76';
      userModel.funpoints = 60;

      await firebaseFirestore
          .collection('users')
          .doc(user!.uid)
          .set(userModel.tomap());

      print(credential);
    } catch (error) {
      print(error);
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MyHomePage(),
      ),
    );
    print(credential);
  }

  googlesigninlogin() async {
    print("Google sign in is working");
    GoogleSignIn _googlesigninn = GoogleSignIn();

    try {
            FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      User? user = _auth.currentUser;
      UserModel userModel = UserModel();
      userModel.email = 'user@gmail.com';
      userModel.pic = 'https://firebasestorage.googleapis.com/v0/b/tasali-app.appspot.com/o/logo.png?alt=media&token=e3a44173-df54-491d-a9fb-de2f2cf943c8';
      userModel.uid = 'https://firebasestorage.googleapis.com/v0/b/tasali-app.appspot.com/o/logo.png?alt=media&token=e3a44173-df54-491d-a9fb-de2f2cf943c8';
      userModel.firstname = 'user';
      userModel.lastname = 'google';
      userModel.bio = 'I am new user';
      userModel.follower = 1;
      userModel.username = '@newusser76';
      userModel.funpoints = 60;

      await firebaseFirestore
          .collection('users')
          .doc(user!.uid)
          .set(userModel.tomap());

      var result = await _googlesigninn.signIn();

      print(result);
    } catch (error) {
      print(error);
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MyHomePage(),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();
  var email = "";
  var password = "";
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    //--------------------------------Email
    final emailFeild = TextFormField(
      autofocus: false,
      controller: emailcontroller,
      keyboardType: TextInputType.emailAddress,
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
      onSaved: (value) {
        emailcontroller.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
    //------------------------------Password
    final passwordFeild = TextFormField(
      autofocus: false,
      obscureText: true,
      controller: passwordcontroller,
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
      onSaved: (value) {
        passwordcontroller.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.vpn_key),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
    //--------------------------------Button
    final loginbutton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Color.fromARGB(255, 111, 12, 180),
      child: MaterialButton(
        splashColor: Colors.black,
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          if (emailcontroller.text.contains('admin@gmail.com') &&
              passwordcontroller.text.contains('iamadmin')) {
            print('Admin');
          }
          if (_formKey.currentState!.validate()) {
            setState(() {
              email = emailcontroller.text;
              password = passwordcontroller.text;
            });
            userLogin();
          }
        },
        child: const Text(
          "Login",
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
                      height: 200,
                      child: Image.asset(
                        "assets/logo.png",
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    emailFeild,
                    const SizedBox(
                      height: 30,
                    ),
                    passwordFeild,
                    const SizedBox(
                      height: 35,
                    ),
                    loginbutton,
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Don\'t have an account?'),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const Sign_Up(),
                              ),
                            );
                          },
                          child: const Text(
                            " Sign up",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color.fromARGB(255, 111, 12, 180),
                                fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => forgot_pass(),
                          ),
                        );
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 111, 12, 180),
                            fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      height: 28,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            googlesigninlogin();
                          },
                          child: Card(
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 20,
                              child: Image.asset(
                                'assets/3.png',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Card(
                          color: Colors.white,
                          child: GestureDetector(
                            onTap: () {
                              appleAuth();
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 20,
                              child: Image.asset(
                                'assets/7.png',
                              ),
                            ),
                          ),
                        ),
                      ],
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

  userLogin() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print("No User Found for that Email");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "No User Found for that Email",
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
          ),
        );
      } else if (e.code == 'wrong-password') {
        print("Wrong Password Provided by User");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "Wrong Password Provided by User",
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
          ),
        );
      }
    }
  }
}
