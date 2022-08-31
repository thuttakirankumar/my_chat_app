import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/Auth/login_screen.dart';
import 'package:my_chat_app/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 5),(){
      if(FirebaseAuth.instance.currentUser==null){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>LoginScreen()), (route) => false);
      }
      else{
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>HomeScreen()), (route) => false);
      }
      
    });
    
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purpleAccent,
      body:  Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("My Chat App"),
              SizedBox(height: 15,),
              Icon(Icons.chat_sharp)

            ],
          ),
        ),
      ),
    );
  }
}