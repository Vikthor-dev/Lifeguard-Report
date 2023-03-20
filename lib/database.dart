import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class DatabaseService{
  final CollectionReference users = FirebaseFirestore.instance.collection("users");

   Future<Tuple3<String, String, String>?> getUserData()async {
    final docSnapshot = await users.doc(Auth().currentUser?.email).get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data() as Map<String,dynamic>;
      String ime = data["Ime"];
      String prezime = data["Prezime"];
      String dob = data["Dob"];
      print("Podaci o korisniku : '${data}' ");
      return Tuple3(ime, prezime, dob);
    }else{
      print("ERROR getting user info!");
    }
  }
}