// ignore_for_file: file_names

class UserModel {
  String? uid;
  String? email;
  String? firstname;
  String? pic;
  String? bio;
  String? username;
  int? follower;
  int? funpoints;
  String? lastname;

  UserModel({
    this.uid,
    this.bio,
    this.username,
    this.follower,
    this.funpoints,
    this.pic,
    this.email,
    this.firstname,
    this.lastname,
  });

  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      pic: map['pic'],
      email: map['email'],
      firstname: map['firstName'],
      lastname: map['lastname'],
      bio: map['bio'],
      username: map['username'],
      follower: map['follower'],
      funpoints: map['funpoints'],
    );
  }

//sending
  Map<String, dynamic> tomap() {
    return {
      'uid': uid,
      'pic': pic,
      'email': email,
      'firstName': firstname,
      'lastName': lastname,
      'bio': bio,
      'username': username,
      'follower': follower,
      'funpoints': funpoints,
    };
  }
}
