import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasali/Models/UserModels.dart';
import 'package:tasali/Page/r.dart';
import 'package:tasali/Screens/Chat/chats.dart';

class HomechatScreen extends StatefulWidget {
  @override
  _HomechatScreenState createState() => _HomechatScreenState();
}

class _HomechatScreenState extends State<HomechatScreen>
    with WidgetsBindingObserver {
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  final TextEditingController _search = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedinUser = UserModel();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Timer(
      const Duration(seconds: 65),
      () => updatefeildf(loggedinUser.uid, loggedinUser.funpoints),
    );
    Timer(
      const Duration(minutes: 3),
      () => updatefeildf(loggedinUser.uid, loggedinUser.funpoints),
    );
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedinUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  void updatefeildf(id, fp) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({'funpoints': fp - 1});
  }

  void updatefeildfrr(id, fp) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({'funpoints': fp + 7});
    Get.to(reloood());

    setState(() {});
  }

  void onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    setState(() {
      isLoading = true;
    });

    await _firestore
        .collection('users')
        .where("firstName", isEqualTo: _search.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
      print(userMap);
    });
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  int rewardedadScore = 0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
            child: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: SizedBox(
                        height: 52,
                        child: Center(
                          child: Text(
                            "Upload content to increase your Fun Score.",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.orange,
            ),
          ),
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: SizedBox(
                      height: 52,
                      child: Center(
                        child: Text(
                          "Upload content to increase your Fun Score.",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.orange.shade400,
                ),
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    'Fun Score: ${loggedinUser.funpoints}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
        backgroundColor: const Color.fromARGB(255, 111, 12, 180),
        title: Image.asset(
          'assets/logo.png',
          width: 52,
        ),
        centerTitle: false,
      ),
      body: isLoading
          ? Center(
              child: Container(
                height: size.height / 20,
                width: size.height / 20,
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
              children: [
                SizedBox(
                  height: size.height / 20,
                ),
                Container(
                  height: size.height / 14,
                  width: size.width,
                  alignment: Alignment.center,
                  child: Container(
                    height: size.height / 14,
                    width: size.width / 1.15,
                    child: TextField(
                      controller: _search,
                      decoration: InputDecoration(
                        hintText: "Search",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height / 50,
                ),
                ElevatedButton(
                  onPressed: onSearch,
                  child: Text("Search by username"),
                ),
                SizedBox(
                  height: size.height / 30,
                ),
                userMap != null
                    ? ListTile(
                        onTap: () {
                          String roomId = chatRoomId(
                              loggedinUser.firstname!, userMap!['firstName']);

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ChatRoom(
                                chatRoomId: roomId,
                                userMap: userMap!['firstName'],
                              ),
                            ),
                          );
                        },
                        leading: Icon(
                          Icons.account_box,
                          color: Colors.black,
                          size: 45,
                        ),
                        title: Text(
                          userMap!['firstName'],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: Icon(Icons.chat, color: Colors.black),
                      )
                    : Container(),
              ],
            ),
    );
  }
}
