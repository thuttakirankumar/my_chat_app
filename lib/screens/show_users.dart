import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/models/room_model.dart';
import 'package:my_chat_app/models/user_model.dart';
import 'package:my_chat_app/screens/chat_screen.dart';

class ShowListOfUsers extends StatefulWidget {
  const ShowListOfUsers({super.key});

  @override
  State<ShowListOfUsers> createState() => _ShowListOfUsersState();
}

class _ShowListOfUsersState extends State<ShowListOfUsers> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Start Chat"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("users").get().asStream(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            if(snapshot.data!.docs.length == 0){
              return Text("No Users found");
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context,index){
                UserModel userModel = UserModel.fromMap(snapshot.data!.docs[index].data() as Map<String,dynamic>);
                if(userModel.uid ==   FirebaseAuth.instance.currentUser!.uid){
                  return Container();
                }
                return Card(
                  child: ListTile(
                    title: Text(userModel.name.toString()),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(userModel.profileImage.toString()),
                    ),
                    subtitle: Text(userModel.email.toString()),
                    trailing: InkWell(
                      onTap: () {
                        checkAndCreateRoom(userModel, context);
                       // Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatApp()) );
                      },
                      child: Icon(Icons.chat_bubble_outlined)),
                  ),
                );

              });
            

          }
          if(snapshot.hasError){
            return Text(snapshot.error.toString());

          }
          return Center(child: CircularProgressIndicator());

        } ,),
    );
  }
   String createRoomId(UserModel toChatUserModel){
    String? roomId = '';
    
    if(user!.uid.hashCode < toChatUserModel.uid.hashCode){
     roomId = user!.uid + "_" + toChatUserModel.uid.toString();
    }else if(user!.uid.hashCode > toChatUserModel.uid.hashCode){
      roomId = toChatUserModel.uid.toString() + "_" + user!.uid;
    }
    return roomId;
   }

   checkAndCreateRoom(UserModel toChatUserModel, BuildContext context) async{
    String roomId = createRoomId(toChatUserModel);

    CollectionReference collref = FirebaseFirestore.instance.collection("rooms");

    DocumentSnapshot docsnap = await collref.doc(roomId).get();
    RooomModel rm = RooomModel();
    if(docsnap.exists){
      rm = RooomModel.fromMap(docsnap.data() as Map<String,dynamic>);
    }else{
      
      rm.recieverId = toChatUserModel.uid.toString();
      rm.participantList =[];
      rm.participantList!.add(toChatUserModel.uid);
      rm.participantList!.add(user!.uid);
      rm.roomId = roomId;
      await collref.doc(roomId).set(rm.toMap());
    }
    
    if(rm!= null){
    Navigator.push(context, MaterialPageRoute(builder: (_)=> ChatScreen(rooomModel: rm,userModel: toChatUserModel,)));
    }

   }
}