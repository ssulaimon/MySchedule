import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:my_schedule/login.dart';
import 'package:my_schedule/home.dart';
import 'package:my_schedule/register.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      routes: {
        "login": (context) => Login(),
        "register": (context) => Register(),
        "mainPage": (context) => Home()
      },
      initialRoute: sharedPreferences.get("email")  == null
          ? "login"
          : "mainPage",

    ),
  );
}
