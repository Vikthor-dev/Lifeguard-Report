import 'package:flutter/material.dart';
import 'package:flutter_project/Screens/Home.dart';
import 'ListaInt.dart';
import 'Postavke.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int selectedIndex = 0;
  final widgetOptions = [
     HomePage(),
     ListaInt(),
     Postavke(),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widgetOptions.elementAt(selectedIndex)
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: onItemTapped,
          iconSize: 27.0,
          fixedColor: Colors.redAccent,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.list), label: "Intervencije"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "Postavke")
          ]),
    );
  }
}
