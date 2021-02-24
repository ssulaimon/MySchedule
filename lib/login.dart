import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

bool view = true;
bool isLoading = false;
String email;
String passWord;
GlobalKey<FormState> form = GlobalKey<FormState>();
SharedPreferences sharedPreferences;

void loginFirebase() async {}

void firebasecore() async {
  FirebaseApp firebase = await Firebase.initializeApp();
  sharedPreferences = await SharedPreferences.getInstance();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebasecore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: form,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 80.0,
                ),
                Icon(
                  Icons.person,
                  color: Colors.black,
                  size: 100.0,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Welcome Back",
                  style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Sign-in to continue",
                  style: TextStyle(
                    fontSize: 10.0,
                    color: Color(
                      0xFFD2D4D3,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: TextFormField(
                      decoration: InputDecoration(
                          hintText: "Youremail@email.com",
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: Icon(
                            Icons.email,
                            color: Color(0xFF01BA76),
                          )),
                      style: TextStyle(
                        color: Color(0xFF01BA76),
                      ),
                      onSaved: (input) {
                        setState(() {
                          email = input;
                        });
                      },
                      validator: (input) {
                        if (input.isEmpty) {
                          return "Email cannot be empty";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Your password",
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Color(0xFF01BA76),
                        ),
                        suffixIcon: GestureDetector(
                          child: Icon(
                            Icons.remove_red_eye,
                            color: Color(0xFF01BA76),
                          ),
                          onTap: () {
                            setState(() {
                              if (view == true) {
                                view = false;
                              } else if (view == false) {
                                view = true;
                              }
                            });
                          },
                        ),
                      ),
                      onSaved: (input) {
                        setState(() {
                          passWord = input;
                        });
                      },
                      validator: (input) {
                        if (input.isEmpty) {
                          return "Your Password is empty ";
                        } else if (input.length < 6) {
                          return "Your password is less than 6";
                        } else {
                          return null;
                        }
                      },
                      obscureText: view,
                      style: TextStyle(
                        color: Color(0xFF01BA76),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 210,
                    ),
                    GestureDetector(
                      child: Text(
                        "Forget Password?",
                        style: TextStyle(
                          color: Color(0xFF01BA76),
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  child: FlatButton(
                    onPressed: () async {
                      if (form.currentState.validate()) {
                        form.currentState.save();
                        var firebase = FirebaseAuth.instance;
                        isLoading = true;
                        await firebase
                            .signInWithEmailAndPassword(
                                email: email, password: passWord)
                            .then((value) {
                          Navigator.popAndPushNamed(context, "mainPage");
                          sharedPreferences.setString("email", email);
                          sharedPreferences.setString("password", passWord);
                          sharedPreferences.setString("key", "dark");
                          Fluttertoast.showToast(
                              msg: "Login Successful",
                              toastLength: Toast.LENGTH_LONG);
                        }).catchError((e) {
                          setState(() {
                            isLoading = false;
                          });
                          Fluttertoast.showToast(
                            msg: e.toString(),
                            toastLength: Toast.LENGTH_LONG,
                          );
                        });
                      }
                    },
                    child: Text(
                      "LOGIN",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Color(0xFF01BA76),
                    padding:
                        EdgeInsets.symmetric(horizontal: 130.0, vertical: 20),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have account?"),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "register");
                      },
                      child: Text(
                        "create a new account",
                        style: TextStyle(
                          color: Color(0xFF01BA76),
                        ),
                      ),
                    )
                  ],
                ),
                isLoading == true
                    ? SpinKitCircle(
                        color: Color(0xFF01BA76),
                      )
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
