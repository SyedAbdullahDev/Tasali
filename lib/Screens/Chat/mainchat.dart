import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:tale_drawer/tale_drawer.dart';
import 'package:tasali/Models/UserModels.dart';
import 'package:tasali/Page/Page.dart';
import 'package:tasali/Screens/Chat/chats.dart';
import 'package:tasali/Screens/Chat/homechat.dart';
import '../../Page/r.dart';

class mainchat extends StatefulWidget {
  const mainchat({Key? key}) : super(key: key);

  @override
  State<mainchat> createState() => _mainchatState();
}

class _mainchatState extends State<mainchat> {
  final CollectionReference _chat =
      FirebaseFirestore.instance.collection('chatroom');

  bool isLoading = false;
  final TextEditingController _search = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;

  UserModel loggedinUser = UserModel();
  @override
  void initState() {
    super.initState();
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
        isLoading = false;
      });
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

  final controller = TaleController();

  int rewardedadScore = 0;
  @override
  Widget build(BuildContext context) {
    return TaleDrawer(
      type: TaleType.Zoom,
      drawerBackground: Colors.orange.shade400,
      drawer: ContentWidget(
        alignment: side == SideState.LEFT
            ? Alignment.centerRight
            : Alignment.centerLeft,
      ),
      sideState: side,
      controller: controller,
      body: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              controller.start();
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(
              HomechatScreen(),
            );
          },
          child: Icon(
            Icons.search,
          ),
        ),
        body: StreamBuilder(
          stream: _chat.snapshots(),
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
                  return documentSnapshot['Reciever'] ==
                              loggedinUser.firstname ||
                          documentSnapshot['Sender'] == loggedinUser.firstname
                      ? Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ListTile(
                            onLongPress: (() => showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'Cancel',
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            deletefield(
                                              documentSnapshot.id,
                                            );
                                            Navigator.pop(context);

                                          },
                                          child: Text(
                                            'Delete',
                                          ),
                                        ),
                                      ],
                                      title: SizedBox(
                                        height: 40,
                                        child: Center(
                                          child: Text(
                                            "Delete Chat",
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )),
                            onTap: (() {
                              String roomId = chatRoomId(
                                  loggedinUser.firstname!,
                                  documentSnapshot['Sender']);
                              String roommIId = chatRoomId(
                                  loggedinUser.firstname!,
                                  documentSnapshot['Reciever']);

                              documentSnapshot['Reciever'] ==
                                      loggedinUser.firstname
                                  ? Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => ChatRoom(
                                          chatRoomId: roomId,
                                          userMap: documentSnapshot['Sender'],
                                        ),
                                      ),
                                    )
                                  : Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => ChatRoom(
                                          chatRoomId: roommIId,
                                          userMap: documentSnapshot['Reciever'],
                                        ),
                                      ),
                                    );
                            }),
                            title: documentSnapshot['Reciever'] ==
                                    loggedinUser.firstname
                                ? Text(
                                    documentSnapshot['Sender'],
                                  )
                                : Text(
                                    documentSnapshot['Reciever'],
                                  ),
                            leading: Icon(
                              Icons.account_box,
                              color: Colors.black,
                              size: 45,
                            ),
                            trailing: Icon(Icons.chat, color: Colors.black),
                          ),
                        )
                      : SizedBox();
                },
              );
            }
            return Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurple,
              ),
            );
          },
        ),
      ),
    );
  }

  void deletefield(id) {
    FirebaseFirestore.instance.collection('chatroom').doc(id).delete();
    Fluttertoast.showToast(msg: 'Deleted from Chat');
  }
}
