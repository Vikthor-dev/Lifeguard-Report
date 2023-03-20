import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project/Screens/ListaInt.dart';
import 'package:flutter_project/Screens/Postavke.dart';
import 'package:geolocator/geolocator.dart';
import 'Intervencija.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var lokacija_sirina, lokacija_duzina;
  late Future<bool> pageLoaded;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text("Usluge lokacije su isključene"),
            content: Text(
                "Uključite lokacijske usluge kako bi ste mogli koristiti aplikaciju."),
            actions: <Widget>[
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.redAccent),
                      padding: MaterialStateProperty.resolveWith(
                          (states) => EdgeInsets.all(20))),
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    AppSettings.openLocationSettings();
                    SystemNavigator.pop();
                  }),
            ],
          ),
        );
        return Future.error('Location services are disabled.');
      }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print(position);
      lokacija_sirina = position.latitude;
      lokacija_duzina = position.longitude;
    });
    pageLoaded = Future.delayed(Duration(seconds: 2), () => true);
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
      body: Center(
        child: FutureBuilder<bool>(
          future: pageLoaded,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a circular progress indicator while the page is loading
              return CircularProgressIndicator(
                color: Colors.redAccent,
                strokeWidth: 5.0
              );
            } else {
              // Show the page content once it's loaded
              return ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Intervencija(
                          lok_lat: lokacija_sirina,
                          lok_long: lokacija_duzina)));
                },
                child: Text("Nova Intervencija"),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => Colors.redAccent),
                    padding: MaterialStateProperty.resolveWith(
                        (states) => EdgeInsets.all(20))),
              );
            }
          },
        ),
      )
    );
  }
}
