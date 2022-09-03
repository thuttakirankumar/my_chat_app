import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageModel {
  String? message;
  Timestamp? timeStamp;
  String? senderId;

  MessageModel({
     this.message,
    this.timeStamp,
    this.senderId
  });

  factory MessageModel.fromMap(Map<String,dynamic> map){
    return MessageModel(
      message: map['message'], timeStamp: map['timeStamp'], senderId: map['senderId']);
  }

  Map<String,dynamic> toMap(){
    return {
      'message': message,
      'timeStamp': FieldValue.serverTimestamp(),
      'senderId': FirebaseAuth.instance.currentUser!.uid

    };
  }
}