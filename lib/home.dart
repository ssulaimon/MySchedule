import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String tittle;
  String body;
  GlobalKey<FormState> ida = GlobalKey<FormState>();
  String name;
  String mode = "dark";

  Future<void> dialogue() async {
    return showDialog(
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: mode == "dark" ? Colors.white : Colors.white,
            content: SingleChildScrollView(
              child: Form(
                key: ida,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Your Schedule/Todo Title",
                      ),
                      onSaved: (input) {
                        setState(() {
                          tittle = input;
                        });
                      },
                      style: TextStyle(
                          color: mode == "dark"
                              ? Color(0xFF01BA76)
                              : Colors.black),
                      validator: (input) {
                        if (input.isEmpty) {
                          return "Please Provide a tittle";
                        } else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: "Body"),
                      minLines: 4,
                      maxLines: 7,
                      onSaved: (input) {
                        setState(() {
                          body = input;
                        });
                      },
                      style: TextStyle(
                          color:
                              mode == "key" ? Color(0xFF01BA76) : Colors.black),
                      validator: (input) {
                        if (input.isEmpty) {
                          return "Please provide your body";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              FlatButton(
                color: mode == "dark" ? Color(0xFF01BA76) : Colors.black,
                onPressed: () async {
                  if (ida.currentState.validate()) {
                    ida.currentState.save();
                    var user = FirebaseAuth.instance;

                    FirebaseFirestore firebaseFireStore =
                        FirebaseFirestore.instance;
                    var date = DateTime.now();
                    firebaseFireStore
                        .collection(user.currentUser.uid)
                        .document(date.toLocal().toIso8601String())
                        .setData({
                      "Tittle": tittle,
                      "Time": date.toIso8601String(),
                      "Body": body,
                      "id": date.toIso8601String()
                    }).then((value) {
                      Fluttertoast.showToast(
                          msg: "New task added",
                          toastLength: Toast.LENGTH_SHORT);
                      Navigator.of(context).pop();
                    }).catchError((e) {
                      Fluttertoast.showToast(
                          msg: e.toString(), toastLength: Toast.LENGTH_SHORT);
                    });
                  }
                },
                child: Text(
                  "Add",
                  style: TextStyle(
                    color: mode == "dark" ? Colors.white : Colors.white,
                  ),
                ),
              ),
              FlatButton(
                color: mode == "dark" ? Color(0xFF01BA76) : Colors.black,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel",
                    style: TextStyle(
                      color: mode == "dark" ? Colors.white : Colors.white,
                    )),
              )
            ],
            title: Text("Add a new Schedule",
                style: TextStyle(
                  color: mode == "dark" ? Colors.white : Colors.black,
                )),
          );
        },
        context: context,
        barrierDismissible: false);
  }

  void firecore() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    var firebase = FirebaseAuth.instance;
    name = firebase.currentUser.displayName;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firecore();
  }

  @override
  Widget build(BuildContext context) {
    var auth = FirebaseAuth.instance;
    var collectionReference = FirebaseFirestore.instance
        .collection(auth.currentUser.uid)
        .orderBy("Time");
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            dialogue();
          });
        },
        backgroundColor: mode == "dark" ? Color(0xFF01BA76) : Colors.white,
        child: Icon(Icons.add,
            color: mode == "dark" ? Colors.white : Colors.black),
      ),
      backgroundColor: mode == "dark" ? Colors.white : Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
                child: Text(
              "Welcome Back $name!!",
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  color: mode == "dark" ? Colors.black : Colors.white),
            )),
            Center(
                child: Text(
              "Your Todo list",
              style: TextStyle(
                  fontSize: 15.0,
                  letterSpacing: 2.0,
                  color: mode == "dark" ? Colors.black : Colors.white),
            )),
            StreamBuilder(
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Column(
                    children: [Text("Errror")],
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Expanded(
                      child: SpinKitCircle(
                    color: Color(0xFF01BA76),
                  ));
                }
                return new ListView(
                  children:
                      snapshot.data.documents.map((DocumentSnapshot document) {
                    return ListTile(
                      title: Text(
                        document["Tittle"].toString(),
                        style: TextStyle(
                            color: mode == "dark"
                                ? Color(0xFF01BA76)
                                : Colors.white),
                      ),
                      subtitle: Text(
                        document["Time"].toString(),
                        style: TextStyle(
                            color: mode == "dark"
                                ? Color(0xFF01BA76)
                                : Colors.white),
                      ),

                      trailing: PopupMenuButton(
                        child: Icon(Icons.more_vert,
                            color: mode == "dark" ? Colors.black : Colors.white),

                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: FlatButton.icon(
                              onPressed: () {
                                var delete = FirebaseFirestore.instance;
                                delete
                                    .collection(auth.currentUser.uid)
                                    .doc(document["id"].toString())
                                    .delete()
                                    .then((value) {
                                  setState(() {
                                    Fluttertoast.showToast(
                                        msg: "Deleted",
                                        toastLength: Toast.LENGTH_SHORT);
                                    Navigator.of(context).pop();
                                  });
                                }).catchError(
                                  (e) => Fluttertoast.showToast(
                                      msg: e.toString(),
                                      toastLength: Toast.LENGTH_SHORT),
                                );
                              },
                              icon: Icon(Icons.delete_forever),
                              label: Text("Delete"),
                            ),
                          ),
                          PopupMenuItem(
                            child: FlatButton.icon(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                showDialog(
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                          content: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                Text(
                                                  'Heading: ${document["Tittle"].toString()}',
                                                  style: TextStyle(
                                                      color: mode == "dark"
                                                          ? Color(0xFF01BA76)
                                                          : Colors.white),
                                                ),
                                                Text(
                                                    'Body: ${document["Body"].toString()}',
                                                    style: TextStyle(
                                                        color: mode == "dark"
                                                            ? Colors.black
                                                            : Colors.white)),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            FlatButton.icon(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                icon: Icon(Icons.cancel),
                                                label: Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                color: mode == "dark"
                                                    ? Color(0xFF01BA76)
                                                    : Colors.black),
                                          ],
                                          title: Text(
                                            "Your Schedule",
                                            style: TextStyle(
                                                color: mode == "dark"
                                                    ? Colors.black
                                                    : Colors.white),
                                          ));
                                    },
                                    context: context,
                                    barrierDismissible: false);
                              },
                              icon: Icon(Icons.remove_red_eye),
                              label: Text("View"),
                            ),
                          )
                        ],
                      ),
                    );
                  }).toList(),
                  shrinkWrap: true,
                );
              },
              stream: collectionReference.snapshots(),
            )
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: mode == "dark" ? Colors.white : Colors.black,
        iconTheme: IconThemeData(
          color: mode == "dark" ? Color(0xFF01BA76) : Colors.white,
        ),
        elevation: 0.0,
        actions: [
          PopupMenuButton(
            child: Icon(Icons.more_vert,
                color: mode == "dark" ? Colors.black : Colors.white),
            itemBuilder: (context) => [
              PopupMenuItem(
                  child: FlatButton.icon(
                icon: Icon(Icons.brightness_2),
                label: Text("Dark Mode"),
                onPressed: () {
                  setState(() {
                    mode = "light";
                  });
                },
              )),
              PopupMenuItem(
                  child: FlatButton.icon(
                      onPressed: () {
                        setState(() {
                          mode = "dark";
                        });
                      },
                      icon: Icon(Icons.brightness_5),
                      label: Text("Light Mode"))),
              PopupMenuItem(
                child: FlatButton.icon(
                  onPressed: () async {
                    SharedPreferences shared =
                        await SharedPreferences.getInstance();
                    shared.remove("email");
                    shared.remove("password");
                    Navigator.popAndPushNamed(context, "login");
                  },
                  icon: Icon(Icons.exit_to_app),
                  label: Text("Logout"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
