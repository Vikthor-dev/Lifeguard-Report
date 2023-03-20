import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/Screens/Login.dart';
import 'package:flutter_project/auth.dart';
import 'package:flutter_project/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuple/tuple.dart';

class Postavke extends StatefulWidget {
  const Postavke({Key? key}) : super(key: key);

  @override
  State<Postavke> createState() => _PostavkeState();
}

class _PostavkeState extends State<Postavke> {
  DatabaseService db = DatabaseService();

  User? user = Auth().currentUser;

  var ime, prezime, dob;

  late Future<bool> pageLoaded;

  void setData() async {
    Tuple3? result = await db.getUserData();
    ime = result?.item1.toString();
    prezime = result?.item2.toString();
    dob = result?.item3.toString();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setData();
    db.getUserData();
    pageLoaded = Future.delayed(Duration(seconds: 2), () => true);
  }

  Future<void> LogOut() async {
    try {
      await Auth().signOut();
      Future.delayed(Duration(seconds: 1), () {
        // <-- Delay here
        setState(() {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Login()),
              (Route<dynamic> route) => false);
        });
      });
    } on FirebaseAuthException catch (e) {
      print("ERROR SIGNING OUT : ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        leading: Image.asset('assets/hck.png'),
        title: Text(
          'Izvještaj o Intervencijama',
          style: TextStyle(fontSize: 18.0, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 0, 30.0, 10.0),
          child: FutureBuilder<bool>(
            future: pageLoaded,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show a circular progress indicator while the page is loading
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.redAccent,
                    strokeWidth: 5.0,
                  ),
                );
              } else {
                return ListView(
                  children: [
                    SizedBox(
                      height: 40.0,
                    ),
                    TextField(
                        readOnly: true,
                        controller: TextEditingController(text: ime),
                        cursorColor: Colors.black45,
                        cursorWidth: 0.5,
                        minLines: 1,
                        maxLines: 1,
                        textAlign: TextAlign.left,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black12)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black12)),
                            labelText: "Ime",
                            labelStyle: TextStyle(
                                color: Colors.black45, fontSize: 14.0),
                            floatingLabelStyle: TextStyle(
                                color: Colors.black45, fontSize: 18.0))),
                    SizedBox(height: 20),
                    TextField(
                        readOnly: true,
                        controller: TextEditingController(text: prezime),
                        cursorColor: Colors.black45,
                        cursorWidth: 0.5,
                        minLines: 1,
                        maxLines: 1,
                        textAlign: TextAlign.left,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black12)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black12)),
                            labelText: "Prezime",
                            labelStyle: TextStyle(
                                color: Colors.black45, fontSize: 14.0),
                            floatingLabelStyle: TextStyle(
                                color: Colors.black45, fontSize: 18.0))),
                    SizedBox(height: 20),
                    TextField(
                        readOnly: true,
                        controller: TextEditingController(text: dob),
                        cursorColor: Colors.black45,
                        cursorWidth: 0.5,
                        minLines: 1,
                        maxLines: 1,
                        textAlign: TextAlign.left,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black12)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black12)),
                            labelText: "Datum rođenja",
                            labelStyle: TextStyle(
                                color: Colors.black45, fontSize: 14.0),
                            floatingLabelStyle: TextStyle(
                                color: Colors.black45, fontSize: 18.0))),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextField(
                        readOnly: true,
                        controller:
                            TextEditingController(text: '${user?.email}'),
                        cursorColor: Colors.black45,
                        cursorWidth: 0.5,
                        minLines: 1,
                        maxLines: 1,
                        textAlign: TextAlign.left,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black12)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black12)),
                            labelText: "Email",
                            labelStyle: TextStyle(
                                color: Colors.black45, fontSize: 14.0),
                            floatingLabelStyle: TextStyle(
                                color: Colors.black45, fontSize: 18.0))),
                    SizedBox(
                      height: 20.0,
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (states) => Colors.redAccent)),
                        onPressed: () {
                          LogOut();
                        },
                        child: Text("Odjava"))
                  ],
                );
              }
            },
          )),
    );
  }
}
