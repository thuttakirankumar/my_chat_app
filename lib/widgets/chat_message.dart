

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/models/message_model.dart';
import 'package:my_chat_app/utilites.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage({
   required this.messageModel
  });

  //String text;
  MessageModel messageModel;
  bool left= false;
  String _name = "Kiran";

  @override
  Widget build(BuildContext context) {
    if(messageModel.senderId == FirebaseAuth.instance.currentUser!.uid){
      left =true;
    }else{
      left = false;
    }
    return Row(
      mainAxisAlignment: left? MainAxisAlignment.end: MainAxisAlignment.start,
      children: [
        Card(
          child: Container(
            //width: MediaQuery.of(context).size.width/1.5,
            padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
            decoration: BoxDecoration(
              color: left? Colors.green:Colors.red,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              crossAxisAlignment: left? CrossAxisAlignment.end: CrossAxisAlignment.start,
              children:[
                Text(messageModel.message.toString() ),
                
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    messageModel.timeStamp != null? 
                    Utilities.displayTimeAgoFromTimestamp(messageModel.timeStamp!.toDate().toString()):""
                    ))

                
              ]
              // Container(
              //   margin: EdgeInsets.symmetric(vertical: 10),
              //   child: Text("Send the message"),
              //   // child: Row(
              //   //   crossAxisAlignment: CrossAxisAlignment.start,
              //   //   children: [
              //   //     Container(
              //   //       margin: EdgeInsets.only(right: 16),
              //   //       child: CircleAvatar(
              //   //         child: Text(_name[0]),
              //   //       ),
              //   //     ),
              //   //     Column(
              //   //       crossAxisAlignment: CrossAxisAlignment.start,
              //   //       children: [
              //   //         Text(_name, style: Theme.of(context).textTheme.subtitle1,),
              //   //         Container(
              //   //           margin: EdgeInsets.only(top: 5),
              //   //           child: Text(text),
              //   //         )
            
            
              //   //       ],
              //   //     )
              //   //   ],
              //   // ),
              // ),
            ),
          ),
        ),
      ],
    );
  }
}