import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WebLoginPage extends ConsumerStatefulWidget {
  const WebLoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WebLoginPageState();
}

class _WebLoginPageState extends ConsumerState<WebLoginPage> {
  String? sessionId;

  @override
  void initState() {
    super.initState();
    getSessionId();
  }

  void getSessionId() {
    Uri uri = Uri.base;
    String? session = uri.queryParameters['session'];

    if (session != null) {
      setState(() {
        sessionId = session;
      });
    }
  }

  Future<void> loginUser() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithPopup(googleAuthProvider);
      user = userCredential.user;
    }

    if (sessionId != null) {
      await FirebaseFirestore.instance.collection('sessions').doc(sessionId).update(
        {'uid': user!.uid, 'status': "logged_in"},
      );

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Log In To Your Accound")),
      body: Center(
          child: sessionId == null
              ? Text("Invalid Session")
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Log In To Continue"),
                    const SizedBox(height: 20),
                    ElevatedButton(onPressed: loginUser, child: Text("Sign in with Goolge"))
                  ],
                )),
    );
  }
}
