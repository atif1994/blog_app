import 'package:blog_app/component/rounded_button.dart';
import 'package:blog_app/screens/login_screen.dart';
import 'package:blog_app/screens/signUp_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OptionalScreen extends StatelessWidget {
  const OptionalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(image:AssetImage("images/pakimg.jpg")),
              SizedBox(height: 20,),
              RoundedButton(
                  text: "Login",
                  onPress: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                  }),
              SizedBox(height: 20,),
              RoundedButton(
                  text: "Register",
                  onPress: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpScreen()));
                  })
            ],
          ),
        ),
      ),
    );
  }
}
