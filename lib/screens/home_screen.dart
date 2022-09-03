import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/models/room_model.dart';
import 'package:my_chat_app/models/user_model.dart';
import 'package:my_chat_app/screens/edit_screen.dart';
import 'package:my_chat_app/screens/show_users.dart';
import 'package:my_chat_app/screens/splash_screen.dart';
import 'package:my_chat_app/utilites.dart';

import 'chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  UserModel? loginuserModel;

  getData() async{
   await FirebaseFirestore.instance.collection("users").doc(user!.uid).get().then((value) {
      this.loginuserModel = UserModel.fromMap(value.data() as Map<String,dynamic>);
      setState(() {
        
      });
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          loginuserModel!.name==null?"Chat":
          "logged as${loginuserModel!.name}"),
        actions: [
          IconButton(onPressed: () async{
            await FirebaseAuth.instance.signOut();
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>SplashScreen()), (route) => false);
          }, icon: Icon(Icons.logout) ),
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>EditScreen()) );
          }, icon: Icon(Icons.edit))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
        .collection("rooms")
        .where("participantList",arrayContains: user!.uid).orderBy("timeStamp",descending: true).snapshots(),
        builder: (context,snapshot){
          if(snapshot.hasData){
              if(snapshot.data!.docs.length == 0){
                return Center(child: Text("No chat started"),);
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context,index){
                  RooomModel rooomModel = RooomModel.fromMap(snapshot.data!.docs[index].data() as Map<String,dynamic>);
                    return StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("users").doc(
                      rooomModel.senderId == user!.uid ? rooomModel.recieverId:rooomModel.senderId
                      ).get().asStream(),
                    builder: (context,snapshot){
                      if(snapshot.hasData){
                        UserModel userModel = UserModel.fromMap(snapshot.data!.data() as Map<String,dynamic> );
                        return Card(
                          child: ListTile(
                                            title: Text(userModel.name.toString()),
                                            onTap: () {
                                                  Navigator.push(context, MaterialPageRoute(builder: (_)=> ChatScreen(rooomModel: rooomModel,userModel: userModel,)));
                                            },
                                            leading: CircleAvatar(
                                              radius: 30,
                                              backgroundImage: NetworkImage(userModel.profileImage.toString()),
                                            ),
                                            subtitle: Text(rooomModel.lastMessage != null? rooomModel.lastMessage as String: "" ),
                                            trailing: Text(rooomModel.timeStamp != null? Utilities.displayTimeAgoFromTimestamp(rooomModel.timeStamp!.toDate().toString()) : "")
                                            
                                          ),
                        );

                      }
                      return Container();

                    });

              });
             }
          if(snapshot.hasError){
            return Text(snapshot.error.toString());

          }
          return Center(child: CircularProgressIndicator());


        } ),
      floatingActionButton: IconButton(onPressed:(){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ShowListOfUsers()) );
      } ,icon: Icon(Icons.add) ,),
    );
  }
}