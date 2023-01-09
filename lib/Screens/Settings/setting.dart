import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:tasali/Models/UserModels.dart';
import 'package:tasali/Screens/Blocked/blockedcontent.dart';
import 'package:tasali/Screens/SignIn_Screen/SignIn_Screen.dart';
import 'package:url_launcher/url_launcher.dart';

class settingscreen extends StatefulWidget {
  const settingscreen({Key? key}) : super(key: key);

  @override
  State<settingscreen> createState() => _settingscreenState();
}

class _settingscreenState extends State<settingscreen> {
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

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri(scheme: "https", host: url);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw "Can not launch url";
    }
  }

  Future<void> _launchURLL(String url) async {
    final Uri uri = Uri(scheme: "https", path: url);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw "Can not launch url";
    }
  }

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedinUser = UserModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/logo.png',
          width: 52,
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 42,
          ),
          ListTile(
            onTap: () {
              _launchURL("www.tasali.app");
            },
            leading: Icon(Icons.help),
            title: Text('About App'),
            trailing: Icon(Icons.arrow_forward),
          ),
          SizedBox(
            height: 12,
          ),
          ListTile(
            onTap: () {
              _launchURLL("tasali.app/privacy/");
            },
            leading: Icon(Icons.privacy_tip),
            title: Text('Privacy Policy'),
            trailing: Icon(Icons.arrow_forward),
          ),
          SizedBox(
            height: 12,
          ),
          ListTile(
            onTap: () async {
              final Uri url =
                  Uri.parse('https://tasali.app/terms-and-conditions/');
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              } else {
                throw "Could not launch $url";
              }
            },
            leading: Icon(Icons.help_center),
            title: Text('Terms & Conditions'),
            trailing: Icon(Icons.arrow_forward),
          ),
          SizedBox(
            height: 12,
          ),
          ListTile(
            onTap: () {
              Get.to(
                Blockcontent(),
              );
            },
            leading: Icon(Icons.block),
            title: Text('Block Content'),
            trailing: Icon(Icons.arrow_forward),
          ),
          SizedBox(
            height: 12,
          ),
          ListTile(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Are you sure you want to delete you account?"),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            deletemf();
                          },
                          child: Text('Yes')),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('No'),
                      ),
                    ],
                  );
                },
              );
            },
            leading: Icon(Icons.delete),
            title: Text('Delete Account'),
            trailing: Icon(Icons.arrow_forward),
          ),
          SizedBox(
            height: 12,
          ),
          ListTile(
            onTap: () {
              loggout(context);
            },
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            trailing: Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }

  void deletemf() {
    FirebaseAuth.instance.currentUser!.delete();
    FirebaseFirestore.instance
        .collection('users')
        .doc(loggedinUser.uid)
        .delete();
    Fluttertoast.showToast(msg: 'User Deleted Sucessfully');
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Sign_In()));
  }

  Future<void> loggout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Sign_In()));
  }
}
