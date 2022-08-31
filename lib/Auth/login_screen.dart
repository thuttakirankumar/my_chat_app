import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/Auth/register_screen.dart';
import 'package:my_chat_app/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailcontroller = TextEditingController();
   TextEditingController _passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.pink[100],
      appBar: AppBar(
        title: Center(child: Text("Login")),
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

            ElevatedButton(onPressed: login, child: Text("Login")),
            SizedBox(
              height: 5,
            ),
            TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen(),));
            }, child: Text("Create an account"))


          ],
        ),
      ),
    );
  }
  login(){
     String email = _emailcontroller.text;
    String password = _passwordcontroller.text;
    FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email, password: password)
      .then((value) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("logged in successfully")));
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomeScreen()), (route) => false);

      }).catchError((e){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("log in failed "+e.toString())));

      });
  }
}