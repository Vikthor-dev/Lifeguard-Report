import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  // Firebase instance
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Assign current user to a variable
  User? get currentUser => _firebaseAuth.currentUser;

  // Get auth state changes variable
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  //Log in with email and password
  Future<void> logInWithEmailAndPassword(
      {required String email, required String password}) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  //Sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
