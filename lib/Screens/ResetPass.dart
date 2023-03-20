import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Login.dart';

class ResetPass extends StatefulWidget {
  const ResetPass({Key? key}) : super(key: key);

  @override
  State<ResetPass> createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {

  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.redAccent,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                    color: Colors.white10,
                    width: 1.5,
                  )
              ),
              width: double.infinity,
              height: 330.0,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/hck.png',
                          height: 50.0,
                          width: 60.0,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          "Izvještaj o intervencijama HCK-a",
                          style: TextStyle(
                              fontSize: 16.0,
                              fontStyle: FontStyle.italic
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    TextField(
                      controller: email,
                      cursorColor: Colors.black45,
                      cursorWidth: 0.5,
                      minLines: 1,
                      maxLines: 1,
                      textAlign: TextAlign.left,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent)),
                          label: Text("Email"),
                          labelStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 17.0
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            minimumSize: MaterialStateProperty.resolveWith((states) => Size(double.infinity, 40.0)),
                            backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.redAccent)
                        ),
                        onPressed: () async{
                          await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text("Password reset !"),
                                content: Text("Link za ponovno postavljanje lozinke poslan je na vaš email!"),
                                actions: <Widget>[
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                          Login()), (Route<dynamic> route) => false);
                                    },
                                    child: Text("OK"),
                                    style: ButtonStyle(
                                        backgroundColor:
                                        MaterialStateProperty
                                            .resolveWith((states) =>
                                        Colors.redAccent),
                                        padding: MaterialStateProperty
                                            .resolveWith((states) =>
                                            EdgeInsets.all(5.0)),
                                        alignment: Alignment.center),
                                  )
                                ],
                              ));
                        },
                        child: Text("Reset Password")
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            minimumSize: MaterialStateProperty.resolveWith((states) => Size(double.infinity, 40.0)),
                            backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.redAccent)
                        ),
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                              Login()), (Route<dynamic> route) => false);
                        },
                        child: Text("Nazad na Login!")
                    )
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}
