import 'package:flutter/cupertino.dart';
import 'Screens/Login.dart';
import 'Screens/MainScreen.dart';
import 'auth.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context,snapshot){
          if(snapshot.hasData){
            return MainScreen();
          }else{
            return Login();
          }
        },
    );
  }
}
