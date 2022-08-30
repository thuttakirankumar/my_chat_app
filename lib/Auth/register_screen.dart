import 'package:flutter/material.dart';

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

            ElevatedButton(onPressed: (){
              print("email is ${_emailcontroller.text}");
            }, child: Text("Register")),
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
}