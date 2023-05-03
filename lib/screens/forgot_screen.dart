import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../component/rounded_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
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
          title: Text("Forgot Password"),
        ),
        body: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

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


                    SizedBox(height: 10,),
                    RoundedButton(
                      onPress: () async {
                        if (_formkey.currentState!.validate()) {
                          setState(() {
                            showSpinnder=true;
                          });
                          try {
                            auth.sendPasswordResetEmail(email: emailController.text.toString()).then((value) {
                              setState(() {
                                showSpinnder=false;
                              });
                              toastMessage("check your email");
                            }).onError((error, stackTrace) {
                              setState(() {
                                showSpinnder=false;
                              });
                              toastMessage(error.toString());
                            });

                          } catch (e) {
                            toastMessage(e.toString());
                            setState(() {
                              showSpinnder=false;
                            });
                          }
                        }
                      },
                      text: "Recover Password",
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
