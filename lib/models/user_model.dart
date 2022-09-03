import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  String? uid;
  String? name;
  String? email;
  String? profileImage;
  var timeStamp;

  UserModel({
    this.uid,
    this.email,
    this.name,
    this.profileImage,
    this.timeStamp
  });

  // data from server parsing
  factory UserModel.fromMap(Map<String,dynamic> map){
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      profileImage: map['profileImage'],
      timeStamp: map['timeStamp'],
    );
  }

  // send data to server
  Map<String,dynamic> toMap(){
    return{
      'uid': uid,
      'email': email,
      'name': name,
      'profileImage': profileImage,
      'timeStamp': FieldValue.serverTimestamp(),


    };
  }


}