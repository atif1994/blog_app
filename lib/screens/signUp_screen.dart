import 'package:blog_app/component/rounded_button.dart';
import 'package:blog_app/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
          title: Text("Create Account"),
        ),
        body: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: Text(
                "Register",
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
                    RoundedButton(
                      onPress: () async {
                        if (_formkey.currentState!.validate()) {
                          setState(() {
                            showSpinnder=true;
                          });
                          try {
                            final user =
                                await auth.createUserWithEmailAndPassword(
                                    email: email.toString().trim(),
                                    password: password.toString().trim());
                            if (user != null) {
                              print("success");
                              toastMessage("successful Register");
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
                      text: "Register",
                    )
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
