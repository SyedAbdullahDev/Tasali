// ignore_for_file: avoid_print, use_build_context_synchronously, camel_case_types, file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasali/Screens/SignIn_Screen/SignIn_Screen.dart';

class forgot_pass extends StatefulWidget {
  const forgot_pass({Key? key}) : super(key: key);

  @override
  State<forgot_pass> createState() => _forgot_passState();
}

class _forgot_passState extends State<forgot_pass> {
  final TextEditingController femailcontroller = TextEditingController();
  final GlobalKey _fform = GlobalKey();
  @override
  void dispose() {
    femailcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//--------------------------------Email
    final emailFeild = TextFormField(
      autofocus: false,
      controller: femailcontroller,
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
        femailcontroller.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
    //--------------------------------Button
    final loginbutton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blue,
      child: MaterialButton(
        splashColor: Colors.black,
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          forgetPassword();
        },
        child: const Text(
          "Send Email",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    //-------------------------------------------------
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _fform,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 200,
                  child: Image.asset(
                    "assets/logo.png",
                  ),
                ),
                const Text(
                  'Forgot Password',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                emailFeild,
                const SizedBox(
                  height: 15,
                ),
                loginbutton,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future forgetPassword() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
        ),
      ),
    );
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: femailcontroller.text.trim());

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const Sign_In(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      Navigator.pop(context);
    }
  }
}
