import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in with email/password
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (err) {
      log("Error: $err");
      return null;
    }
  }

// Register with email/password
  Future<User?> register(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (err) {
      log("Error: $err");
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (err) {
      log("Error: $err");
      return null;
    }
  }
}
