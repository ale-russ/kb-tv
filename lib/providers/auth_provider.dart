import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return AuthNotifier(firebaseAuth);
});

class AuthNotifier extends StateNotifier<User?> {
  final FirebaseAuth _auth;
  AuthNotifier(this._auth) : super(_auth.currentUser);

  Future<void> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      state = userCredential.user;
    } catch (err) {
      log("Error: $err");
    }
  }

  Future<void> signInWithGoogle() async {
    log('in signin method');
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      state = userCredential.user;
    } catch (err) {
      log("Error: $err");
    }
  }

  Future<void> signIn(String email, String password) async {
    log("email: $email, password: $password");
    try {
      UserCredential _userCredentials = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      state = _userCredentials.user;
    } catch (err) {
      log("Error: $err");
    }
  }

  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();
    state = null;
    context.pushReplacement("/");
  }
}
