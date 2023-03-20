import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/database.dart';
import 'package:flutter_project/auth.dart';

class ListaInt extends StatefulWidget {
  const ListaInt({Key? key}) : super(key: key);

  @override
  State<ListaInt> createState() => _ListaIntState();
}

class _ListaIntState extends State<ListaInt> {
  User? user = Auth().currentUser;

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
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
          child: Column(
            children: [
              SizedBox(height: 40.0),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc("${user?.email}")
                    .collection("intervencije")
                    .orderBy("Datum", descending: false)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    final snap = snapshot.data!.docs;
                    return ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: snap.length,
                      itemBuilder: (context, index) {
                        return ListView(
                          shrinkWrap: true,
                          children: [
                            TextField(
                                readOnly: true,
                                controller: TextEditingController(
                                    text: snap[index]["Izvjesce"]),
                                cursorColor: Colors.black45,
                                cursorWidth: 0.5,
                                minLines: 1,
                                maxLines: 10,
                                textAlign: TextAlign.left,
                                textAlignVertical: TextAlignVertical.top,
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.redAccent)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.redAccent)),
                                    labelText: "Intervencija",
                                    labelStyle: TextStyle(
                                        color: Colors.black45, fontSize: 14.0),
                                    floatingLabelStyle: TextStyle(
                                        color: Colors.black45,
                                        fontSize: 18.0))),
                            SizedBox(height: 20.0)
                          ],
                        );
                      },
                    );
                  } else {
                    return SizedBox();
                  }
                },
              )
            ],
          ),
        ));
  }
}
