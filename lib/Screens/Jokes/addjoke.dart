import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasali/Models/UserModels.dart';
import 'package:tasali/Models/jokemodel.dart';
import 'package:tasali/Page/Page.dart';

class Add_jokes extends StatefulWidget {
  const Add_jokes({Key? key}) : super(key: key);

  @override
  State<Add_jokes> createState() => _Add_jokesState();
}

class _Add_jokesState extends State<Add_jokes> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController jokecontroller = TextEditingController();
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
        title: Text('Upload a joke'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: SizedBox(
                  height: 120,
                  child: Image.asset(
                    'assets/logo.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  maxLines: 5,
                  controller: jokecontroller,
                  autofocus: false,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Please Enter Joke");
                    }
                    return null;
                  },
                  onSaved: (value) {
                    jokecontroller.text = value!;
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                      hintText: "Upload Jokes in your own language",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(30),
                  color: Color.fromARGB(255, 111, 12, 180),
                  child: MaterialButton(
                    splashColor: Colors.black,
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    minWidth: MediaQuery.of(context).size.width,
                    onPressed: () {
                      updatefeildf(loggedinUser.uid, loggedinUser.funpoints);
                      print('object');
                      jokeaddfire();
                    },
                    child: const Text(
                      "Upload",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
  jokeaddfire() {
    if (_formKey.currentState!.validate()) {
      postDetailsToFirebase();
    }
  }

  postDetailsToFirebase() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    jokemodel jokemodelfire = jokemodel();
    jokemodelfire.joke = jokecontroller.text;
    jokemodelfire.islike = false;
    jokemodelfire.report = false;
    jokemodelfire.reportdesc = 'null';
    jokemodelfire.name = loggedinUser.firstname;
    jokemodelfire.jokeuid = loggedinUser.uid;
    jokemodelfire.profilepic = loggedinUser.pic;
    await firebaseFirestore.collection('joke').doc().set(jokemodelfire.tomap());
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: ((context) => const MyHomePage()),
      ),
    );
  }
}