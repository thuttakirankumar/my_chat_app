
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/models/message_model.dart';
import 'package:my_chat_app/models/room_model.dart';
import 'package:my_chat_app/models/user_model.dart';

import '../widgets/chat_message.dart';



class ChatScreen extends StatefulWidget {
  RooomModel rooomModel;
  UserModel? userModel;
   ChatScreen({super.key,required this.rooomModel, this.userModel});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //List<ChatMessage> messages = [];
  CollectionReference? collref;
  TextEditingController _controller = TextEditingController();
    

  // void submited( String text ){
  //   _controller.clear();
  //   ChatMessage message = ChatMessage(text: text);
  //   setState(() {
  //     messages.insert(0, message);
  //   });
    
  // }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    collref = FirebaseFirestore.instance.collection("chats").doc(widget.rooomModel.roomId).collection("messages");
  

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userModel!.name.toString() ),
      ),
      body:  Column(
      children: [
        Flexible
        (
          child: StreamBuilder<QuerySnapshot>(
            stream: collref!.orderBy("timeStamp").snapshots(),
            builder: (context, snapshot) {
              if(snapshot.hasError){
            return Text(snapshot.error.toString());
             }
             
             if(snapshot.hasData){
              if(snapshot.data!.docs.length == 0){
                return Center(child: Text("No chat started"),);
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context,index){
                  MessageModel msgmd = MessageModel.fromMap(snapshot.data!.docs[index].data() as Map<String,dynamic>);
                  return ChatMessage(messageModel: msgmd);

              });
             }
             return Center(child: CircularProgressIndicator());
            
          },)
        ),
        Divider(

        ),
        _textcomposurewidget()

      ],
    ),
    );
   
  }

  Widget _textcomposurewidget(){
    return IconTheme(
      data: IconThemeData(color: Colors.blue),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
              Flexible(
               child: TextField(
                maxLines: 5,
                minLines: 1,
                     decoration: InputDecoration.collapsed(
                       hintText: "Send a message",
                       
                     ),
                     controller: _controller,
                     //onSubmitted: submited
                   ),
             ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          child: IconButton(
            onPressed: (){
              //submited(_controller.text);
              sendMessage();
            },
             icon: Icon(Icons.send)),
        )
          ],
        )
       
      ),
    );

  }
  sendMessage() async{
    if(_controller.text.length == 0){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter message")));
      return;
    }
    String message = _controller.text;
    

    MessageModel md = MessageModel();
    md.message = message;
    await collref!.add(md.toMap());
    

    Map<String,dynamic> roomMap =Map<String,dynamic>();
    roomMap['lastMessage'] = message;
    roomMap['timeStamp'] = FieldValue.serverTimestamp();

    FirebaseFirestore.instance.collection("rooms").doc(widget.rooomModel.roomId).update(roomMap);

    _controller.clear();
  }


}