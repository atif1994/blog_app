import 'package:blog_app/screens/home_screen.dart';
import 'package:blog_app/screens/signUp_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../component/rounded_button.dart';
import 'forgot_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  String email = '', password = '';
  bool showSpinnder = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinnder,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Login  Account"),
        ),
        body: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: Text(
                    "Login",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  )),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    TextFormField(
                        controller: emailController,
                        onChanged: (value) {
                          email = value;
                        },
                        validator: (value) {
                          return value!.isEmpty ? "enter your email" : null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: "email",
                            hintText: "email",
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder())),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                        obscureText: true,
                        controller: passwordController,
                        onChanged: (value) {
                          password = value;
                        },
                        validator: (value) {
                          return value!.isEmpty ? "enter your password" : null;
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: "password",
                            hintText: "password",
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder())),
                    SizedBox(
                      height: 15,
                    ),
                    InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPasswordScreen()));
                        },
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Text("Forgot Password"))),
                    SizedBox(height: 10,),
                    RoundedButton(
                      onPress: () async {
                        if (_formkey.currentState!.validate()) {
                          setState(() {
                            showSpinnder=true;
                          });
                          try {
                            final user =
                            await auth.signInWithEmailAndPassword(
                                email: email.toString().trim(),
                                password: password.toString().trim());
                            if (user != null) {
                              print("success");
                              toastMessage("successful login");
                              setState(() {
                                showSpinnder=false;
                              });
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                            }
                          } catch (e) {
                            toastMessage(e.toString());
                            setState(() {
                              showSpinnder=false;
                            });
                          }
                        }
                      },
                      text: "Login",
                    ),
                    SizedBox(height: 10,),
                    InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpScreen()));
                        },
                        child: Text("NewUser Create Account")),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  void toastMessage(e) {
    Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
