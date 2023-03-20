import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/Screens/ResetPass.dart';
import '../auth.dart';
import 'MainScreen.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final email = TextEditingController();
  final password = TextEditingController();

  Future<void> logInWithEmailAndPassword()async {
    try{
      await Auth().logInWithEmailAndPassword(
          email: email.text, password: password.text
      );
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          MainScreen()), (Route<dynamic> route) => false);
    }on FirebaseAuthException catch(e){
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            content: Text("${e.message}!"),
            actions: <Widget>[
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.redAccent),
                      padding: MaterialStateProperty.resolveWith((states) => EdgeInsets.all(5.0)),
                  ),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text("Izlaz")
              )
            ],
          )
      );
      print("ERROR LOGING IN : ${e.message}");
    }
  }

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
              height: 420.0,
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
                    TextField(
                      controller: password,
                      obscureText: true,
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
                        label: Text("Lozinka"),
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
                        onPressed: () {
                          logInWithEmailAndPassword();
                        },
                        child: Text("Login")
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
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ResetPass()));
                        },
                        child: Text("Zaboravili ste lozinku?")
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


