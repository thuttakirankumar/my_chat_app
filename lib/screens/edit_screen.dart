import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {

  TextEditingController _controller = TextEditingController();
  File? file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
         file==null? InkWell(
            onTap: chooseimage,
            child: Icon(Icons.image,size: 50,)): Container(
              height: 150,
              width:  150,
              child: Image.file(file!)),
          
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: "Name",hintText: "Enter name",border: OutlineInputBorder()),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(onPressed: (){
            updateProfile(context);
          }, child: Text("Update Profile"))

        ],
      ),
    );
  }

  chooseimage() async{
  XFile? xfile = await ImagePicker().pickImage(source: ImageSource.gallery );
  file = File(xfile!.path);
  setState(() { }); 
  }

  Future updateProfile(BuildContext context) async{
    Map<String,dynamic> map =Map<String,dynamic>();
    if(file != null){
      String url = await uploadImage();
      map['profileImage'] = url;
    }
    map['name'] = _controller.text;
   await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update(map);
    Navigator.pop(context);

  }

 Future<String> uploadImage()async{
 TaskSnapshot taskSnapshot = await FirebaseStorage.instance.ref().child("profile")
    .child(
      FirebaseAuth.instance.currentUser!.uid + "_" 
      +basename(file!.path))
      .putFile(file!);

      return taskSnapshot.ref.getDownloadURL();
  }

}