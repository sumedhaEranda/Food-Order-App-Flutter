import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'login.dart';


class MyRegister extends StatefulWidget {
  const MyRegister({Key? key}) : super(key: key);

  @override
  State<MyRegister> createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
//form key
  final _formKey = GlobalKey<FormState>();

  //edit controller
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorMessage = '';
  File? imagefile, defulfile;
  String? imageUri;
  String base64Image = '';

  //firebase
  final AuthResult = FirebaseAuth.instance;
  late UserCredential userCred;

  @override
  Widget build(BuildContext context) {
    final nameField = TextFormField(
      autofocus: false,
      controller: nameController,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.person_add),
          fillColor: Colors.white,
          filled: true,
          hintText: 'User Name',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please enter your User Name");
        }
        return null;
      },
      onSaved: (value) {
        nameController.text = value!;
      },
      textInputAction: TextInputAction.next,
    );

    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.mail),
          fillColor: Colors.white,
          filled: true,
          hintText: 'Email',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please enter your Email");
        }
        //reg expression for email validation
        else if (!RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value)) {
          return ("Please enter valid Email");
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
    );

    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.vpn_key),
          fillColor: Colors.white,
          filled: true,
          hintText: 'Password',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
      validator: (value) {
        RegExp regExp = new RegExp(r'^.{6,}');
        if (value!.isEmpty) {
          return ("Please enter your Password");
        }
        if (!regExp.hasMatch(value)) {
          return ("Please Enter Valid Password(min 6 character)");
        }
        return null;
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.next,
    );

    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/Login.jpg'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 35, top: 130),
              child: const Text(
                'Create\nAccount',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
                child: Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.3,
                  right: 35,
                  left: 35),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        getImage();
                      },
                      child: CircleAvatar(
                        radius: 90,
                        backgroundImage: imagefile == null
                            ? const AssetImage('assets/user.png')
                            : Image.file(imagefile!).image,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    nameField,
                    const SizedBox(
                      height: 20,
                    ),
                    emailField,
                    const SizedBox(
                      height: 20,
                    ),
                    passwordField,
                    const SizedBox(
                      height: 40,
                    ),
                    (errorMessage != ''
                        ? Text(
                            errorMessage,
                            style: const TextStyle(color: Colors.red),
                          )
                        : Container()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'Register',
                          style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: IconButton(
                              color: Colors.black,
                              iconSize: 40,
                              icon: const Icon(Icons.arrow_forward),
                              onPressed: () {
                                signUp(
                                    nameController.text,
                                    emailController.text,
                                    passwordController.text);
                              }),
                        ),
                        const SizedBox(
                          height: 70,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  late final pickedFile;

  Future getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 20,
        maxHeight: 300,
        maxWidth: 300);
    setState(() {
      imagefile = File(pickedFile!.path);
    });
  }

  void signUp(username, email, password) async {
    setState(() {
      errorMessage = '';
    });

    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCred =
            await AuthResult.createUserWithEmailAndPassword(
                email: email, password: password);
        try {
          // Save username name
          await userCred.user!.updateDisplayName(username);
          final bytes = imagefile!.readAsBytesSync();
          base64Image = base64Encode(bytes);

          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCred.user!.uid)
              .set(
            {
              'username': nameController.text,
              'imageurl': base64Image,
              'email': emailController.text,
              'password': passwordController.text,
            },
          );
        } catch (e) {
          handleError();
        }
        Fluttertoast.showToast(msg: "User Create Successfully");
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MyLogin()));
      } catch (e) {
        e.toString();
        Fluttertoast.showToast(msg: "Email Id already Exist!!!");
      }
    }
  }

  void handleError() {
    setState(() {
      errorMessage = 'Email Id already Exist!!!';
    });
  }
}
