import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // Suitable for most situations
import 'package:flutter_map/plugin_api.dart'; // Only import if required functionality is not exposed by default
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_project/Screens/MainScreen.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';
import '../auth.dart';
import '../database.dart';

class Intervencija extends StatefulWidget {
  var lok_lat, lok_long;

  Intervencija({this.lok_lat, this.lok_long});

  @override
  State<Intervencija> createState() => _IntervencijaState(lok_lat, lok_long);
}

class _IntervencijaState extends State<Intervencija> {
  DatabaseService db = DatabaseService();
  User? user = Auth().currentUser;

  var lok_lat, lok_long;
  String grad = '';
  String zupanija = '';
  String ulica = '';
  String date = DateFormat('dd/MM/yyyy').format(DateTime.now());
  String time = DateFormat('jm').format(DateTime.now());
  bool ambulance = false;

  _IntervencijaState(this.lok_lat, this.lok_long);

  var ime, prezime;

  TextEditingController izvjesce = TextEditingController();

  late Future<bool> pageLoaded;

  final CollectionReference intervencije = FirebaseFirestore.instance.collection("intervencije");

  void setData() async {
    Tuple3? result = await db.getUserData();
    ime = result?.item1.toString();
    prezime = result?.item2.toString();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(lok_lat, lok_long);
      print(placemarks);
      Placemark place = placemarks[0];
      grad = '${place.locality}';
      zupanija = '${place.administrativeArea}';
      ulica = '${place.thoroughfare}';
      setState(() {});
    });
    setData();
    pageLoaded = Future.delayed(Duration(seconds: 2), () => true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
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
                      SizedBox(height: 40.0),
                      TextField(
                          readOnly: true,
                          controller:
                              TextEditingController(text: '${ime} ${prezime}'),
                          cursorColor: Colors.black45,
                          cursorWidth: 0.5,
                          minLines: 1,
                          maxLines: 1,
                          textAlign: TextAlign.left,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black12)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black12)),
                              labelText: "Spasilac",
                              labelStyle: TextStyle(
                                  color: Colors.black45, fontSize: 14.0),
                              floatingLabelStyle: TextStyle(
                                  color: Colors.black45, fontSize: 18.0))),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: izvjesce,
                        cursorColor: Colors.black45,
                        cursorWidth: 0.5,
                        minLines: 4,
                        maxLines: 10,
                        textAlign: TextAlign.left,
                        textAlignVertical: TextAlignVertical.top,
                        autocorrect: true,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black12)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black12)),
                            labelText: "Izvještaj o intervenciji",
                            labelStyle: TextStyle(
                                color: Colors.black45, fontSize: 14.0),
                            floatingLabelStyle: TextStyle(
                                color: Colors.black45, fontSize: 18.0)),
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        children: [
                          Text(
                            "Pozvana hitna služba ?",
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          Checkbox(
                              activeColor: Colors.redAccent,
                              value: ambulance,
                              onChanged: (new_bool) {
                                setState(() {
                                  ambulance = new_bool!;
                                });
                              }),
                          Text(
                            "Ako nije pusti prazno !",
                            style: TextStyle(
                                color: Colors.redAccent, fontSize: 12.0),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12)),
                        height: 300.0,
                        child: FlutterMap(
                            options: MapOptions(
                                keepAlive: true,
                                zoom: 18,
                                maxZoom: 18,
                                center: LatLng(lok_lat, lok_long)),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                                userAgentPackageName:
                                    'dev.fleaflet.flutter_map.example',
                              ),
                              CurrentLocationLayer(),
                            ]),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                          readOnly: true,
                          controller:
                              TextEditingController(text: '${zupanija}'),
                          cursorColor: Colors.black45,
                          cursorWidth: 0.5,
                          minLines: 1,
                          maxLines: 1,
                          textAlign: TextAlign.left,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black12)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black12)),
                              labelText: "Zupanija",
                              labelStyle: TextStyle(
                                  color: Colors.black45, fontSize: 14.0),
                              floatingLabelStyle: TextStyle(
                                  color: Colors.black45, fontSize: 18.0))),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                          readOnly: true,
                          controller: TextEditingController(text: '${grad}'),
                          cursorColor: Colors.black45,
                          cursorWidth: 0.5,
                          minLines: 1,
                          maxLines: 1,
                          textAlign: TextAlign.left,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black12)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black12)),
                              labelText: "Grad",
                              labelStyle: TextStyle(
                                  color: Colors.black45, fontSize: 14.0),
                              floatingLabelStyle: TextStyle(
                                  color: Colors.black45, fontSize: 18.0))),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                          readOnly: true,
                          controller: TextEditingController(text: '${ulica}'),
                          cursorColor: Colors.black45,
                          cursorWidth: 0.5,
                          minLines: 1,
                          maxLines: 1,
                          textAlign: TextAlign.left,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black12)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black12)),
                              labelText: "Ulica",
                              labelStyle: TextStyle(
                                  color: Colors.black45, fontSize: 14.0),
                              floatingLabelStyle: TextStyle(
                                  color: Colors.black45, fontSize: 18.0))),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                          readOnly: true,
                          controller:
                              TextEditingController(text: '${date} - ${time}'),
                          cursorColor: Colors.black45,
                          cursorWidth: 0.5,
                          minLines: 1,
                          maxLines: 1,
                          textAlign: TextAlign.left,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black12)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black12)),
                              labelText: "Datum i vrijeme",
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
                                (states) => Colors.redAccent),
                          ),
                          onPressed: () async {
                            Map<String,dynamic> data = {
                              "Ime":ime,
                              "Prezime":prezime,
                              "Izvjesce":izvjesce.text,
                              "Koordinatna sirina":lok_lat,
                              "Koordinatna duzina":lok_long,
                              "Pozvana HMS":ambulance,
                              "Zupanija":zupanija,
                              "Grad":grad,
                              "Ulica":ulica,
                              "Datum":date,
                              "Vrijeme":time,
                            };
                            await FirebaseFirestore.instance.collection("users").doc("${user?.email}").collection("intervencije").add(data);
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: Text("Izvješće predano !"),
                                      content: Text("Keep up the good work!"),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MainScreen()),
                                                    (Route<dynamic> route) =>
                                                        false);
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
                          child: Text("Predaj izvješće"))
                    ],
                  );
                }
              },
            )));
  }
}
