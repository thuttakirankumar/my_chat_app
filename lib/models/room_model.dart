import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class RooomModel{
  String? roomId;
  String? senderId;
  String? recieverId;
  Timestamp? timeStamp;
  String? lastMessage;
  List? participantList =[];

  Timestamp? groupCreatedAt;

  RooomModel({
    this.roomId,
    this.senderId,
   this.recieverId,
    this.timeStamp,
    this.participantList,
    this.lastMessage,
    this.groupCreatedAt
  });

 factory RooomModel.fromMap(Map<String,dynamic> map){
    return RooomModel
    (
      groupCreatedAt: map['groupCreatedAt'],
      roomId: map['roomId'],
      senderId: map['senderId'],
       recieverId: map['recieverId'], 
       timeStamp: map['timeStamp'],
        participantList: map['participantList'],
         lastMessage: map['lastMessage']
         ) ;
  }

  Map<String,dynamic> toMap(){
    return{
      'roomId' : roomId,
      'senderId':FirebaseAuth.instance.currentUser!.uid,
      'recieverId': recieverId,
      'timeStamp': FieldValue.serverTimestamp(),
      'participantList': participantList,
      'lastMessage': lastMessage

    };
  }
}