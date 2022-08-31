import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/models/user_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _emailcontroller = TextEditingController();
   TextEditingController _passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.pink[100],
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(

              margin: EdgeInsets.all(10),
              child: TextField(
                controller: _emailcontroller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Email"),hintText: "Enter email address"
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),

            Container(
              margin:  EdgeInsets.all(10),
              child: TextField(
                obscureText: true,
                controller: _passwordcontroller,
                decoration: InputDecoration(
                   border: OutlineInputBorder(),
                  label: Text("Password"),hintText: "Enter Password"
                ),
                keyboardType: TextInputType.visiblePassword,
              ),
            ),
            SizedBox(
              height: 5,
            ),

            ElevatedButton(onPressed: register, child: Text("Register")),
            SizedBox(
              height: 5,
            ),
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text("Continue to sign in"))


          ],
        ),
      ),
    );
  }
  register(){
    String email = _emailcontroller.text;
    String password = _passwordcontroller.text;
    FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email, password: password)
      .then((value) {
        postDetailsToFireStore();
        

      }).catchError((e){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User creation failed "+e.toString())));

      });
  }
  postDetailsToFireStore() async{
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    User? user = FirebaseAuth.instance.currentUser;
    UserModel userModel = UserModel();

    userModel.uid = user!.uid;
    userModel.email = user.email;
    userModel.name = user.email!.split('@')[0];

   await firebaseFirestore.collection("users").doc(user.uid).set(userModel.toMap());
   
   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("New User created")));
  }
}