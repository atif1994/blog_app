import 'dart:async';

import 'package:blog_app/screens/home_screen.dart';
import 'package:blog_app/screens/optional_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplachScreen extends StatefulWidget {
  const SplachScreen({Key? key}) : super(key: key);

  @override
  State<SplachScreen> createState() => _SplachScreenState();
}

class _SplachScreenState extends State<SplachScreen> {
  final auth =FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState


    super.initState();
    final user=auth.currentUser;
    if(
    user!=null
    ){
      Timer(Duration(seconds: 3), () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
      });

    }else{
      Timer(Duration(seconds: 3), () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>OptionalScreen()));
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child:      Image(image:AssetImage("images/pakimg.jpg")),
          ),
          Text("Blog about ",style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold),)
        ],
      ),
    );
  }
}
