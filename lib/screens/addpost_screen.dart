import 'dart:io';

import 'package:blog_app/component/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool showSpinner = false;
  final refPost = FirebaseDatabase.instance.ref().child("post");
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  FirebaseAuth _auth =FirebaseAuth.instance;

  File? _image;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final _key = GlobalKey<FormState>();
  final imagePicker = ImagePicker();

  Future getImageCamera() async {
    final _imagepickCamere =
        await imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      if (_imagepickCamere != null) {
        _image = File(_imagepickCamere.path);
      } else {
        print("image not load");
      }
    });
  }

  Future getImageGallery() async {
    final _imagepickCamere =
        await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (_imagepickCamere != null) {
        _image = File(_imagepickCamere.path);
      } else {
        print("image not load");
      }
    });
  }
  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final s = MediaQuery.of(context).size;
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Upload blog"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 10, left: 12, right: 12),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    openAlertBox();
                  },
                  child: Center(
                    child: Container(
                        height: s.height * .2,
                        width: s.width * 0.9,
                        child: _image != null
                            ? ClipRRect(
                                child: Image.file(
                                  _image!.absolute,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.fill,
                                ),
                              )
                            : Container(
                                width: s.width,
                                height: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey.withOpacity(0.4)),
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.blue,
                                ),
                              )),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Form(
                    key: _key,
                    child: Column(
                      children: [
                        TextFormField(
                            controller: titleController,
                            validator: (value) {
                              return value!.isEmpty ? "enter your title" : null;
                            },
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                labelText: "title",
                                hintText: "Enter post title",
                                labelStyle: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400),
                                hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400),
                                border: OutlineInputBorder())),
                        SizedBox(
                          height: 12,
                        ),
                        TextFormField(
                            maxLines: 5,
                            controller: descriptionController,
                            validator: (value) {
                              return value!.isEmpty
                                  ? "enter your description"
                                  : null;
                            },
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                labelText: "description",
                                hintText: "Enter description",
                                labelStyle: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400),
                                hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400),
                                border: OutlineInputBorder())),
                        SizedBox(
                          height: 12,
                        ),
                        RoundedButton(
                          onPress: () async {
                            if (_key.currentState!.validate()) {
                              setState(() {
                                showSpinner = true;
                              });
                              try {
                                int data =
                                    DateTime.now().microsecondsSinceEpoch;

                                firebase_storage.Reference ref =
                                    await firebase_storage
                                        .FirebaseStorage.instance
                                        .ref('/blogapp$data');
                                UploadTask uploadtask =
                                    ref.putFile(_image!.absolute);
                                await Future.value(uploadtask);
                                var newurl = await ref.getDownloadURL();
                                final User? user=_auth.currentUser;
                                refPost
                                    .child('post list')
                                    .child(data.toString())
                                    .set({
                                  "pID": data.toString(),
                                  "pImge": newurl.toString(),
                                  "ptitle": titleController.text.toString(),
                                  "pDescription": descriptionController.text.toString(),
                                  "pEmail": user!.email.toString(),
                                  "pUid":user.uid.toString(),
                                }).then((value) {
                                  toastMessage("POST PUBLISH");
                                  setState(() {
                                    showSpinner = false;
                                  });
                                }).onError((error, stackTrace) {
                                  setState(() {
                                    showSpinner = false;
                                  });
                                  toastMessage(error.toString());
                                });
                              } catch (e) {
                                setState(() {
                                  showSpinner = false;
                                });
                              }
                            }
                          },
                          text: "Upload",
                        )
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  openAlertBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      getImageCamera();

                      Navigator.pop(context);
                    },
                    child: ListTile(
                      leading: Icon(Icons.camera_alt_outlined),
                      title: Text("Camera"),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      getImageGallery();
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      leading: Icon(Icons.photo_album),
                      title: Text("gallery"),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
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
