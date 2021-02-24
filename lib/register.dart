import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

String email;
String password;
String name;
String phone;
String rePassword;
bool isLoading = false;
bool viewPass = true;
GlobalKey<FormState> formstate = GlobalKey<FormState>();
SharedPreferences mode;

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFFFFFFFF),
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0.0),
      backgroundColor: Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: Form(
          key: formstate,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                "Create Account",
                style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Text(
                "Create a new account",
                style: TextStyle(fontSize: 15.0, color: Color(0xFFD2D4D3)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 2,
                  color: Colors.white,
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: "Name",
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Icon(
                          Icons.person,
                          color: Color(0xFF01BA76),
                        )),
                    style: TextStyle(
                      color: Color(0xFF01BA76),
                    ),
                    onSaved: (input) {
                      setState(() {
                        name = input;
                      });
                    },
                    validator: (input) {
                      if (input.isEmpty) {
                        return "Your Name cannot be empty";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
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
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        hintText: "Phone",
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Color(0xFF01BA76),
                        )),
                    style: TextStyle(
                      color: Color(0xFF01BA76),
                    ),
                    onSaved: (input) {
                      setState(() {
                        phone = input;
                      });
                    },
                    validator: (input) {
                      if (input.isEmpty) {
                        return "Phone number is required";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  child: TextFormField(
                    obscureText: viewPass,
                    decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          child: Icon(
                            Icons.remove_red_eye,
                            color: Color(0xFF01BA76),
                          ),
                          onTap: () {
                            setState(() {
                              if (viewPass == true) {
                                viewPass = false;
                              } else if (viewPass == false) {
                                viewPass = true;
                              }
                            });
                          },
                        ),
                        hintText: "Password",
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Color(0xFF01BA76),
                        )),
                    style: TextStyle(
                      color: Color(0xFF01BA76),
                    ),
                    onSaved: (input) {
                      setState(() {
                        password = input;
                      });
                    },
                    validator: (input) {
                      if (input.isEmpty) {
                        return "Password cannot be empty";
                      } else if (input.length < 6) {
                        return "Your pass word is less than 6";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ),
              Padding(
                child: FlatButton(
                  onPressed: () async {
                    if (formstate.currentState.validate() &&
                        password == rePassword) {
                      formstate.currentState.save();
                      var firebase = FirebaseAuth.instance;
                      firebase.createUserWithEmailAndPassword(
                          email: email, password: password);
                      User user = firebase.currentUser;
                      await user.updateProfile(displayName: name);
                      Navigator.popAndPushNamed(context, "mainPage");
                    }
                  },
                  child: Text(
                    "Create Account",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Color(0xFF01BA76),
                  padding:
                      EdgeInsets.symmetric(horizontal: 100.0, vertical: 20),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.0),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?"),
                  GestureDetector(
                    onTap: () {
                      Navigator.popAndPushNamed(context, "login");
                    },
                    child: Text(
                      "Login",
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
    );
  }
}
