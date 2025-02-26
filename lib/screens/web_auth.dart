import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WebLoginPage extends StatelessWidget {
  final String? sessionId;
  const WebLoginPage({this.sessionId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Web Login")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () async {
                // await FirebaseAuth.instance
                //     .signInWithPopup(GoogleAuthProvider());
                // // After login, update Firestore with the userId
                // await FirebaseFirestore.instance
                //     .collection("tv_sessions")
                //     .doc(sessionId!)
                //     .update({
                //   "userId": FirebaseAuth.instance.currentUser?.uid,
                // });
                // Navigator.of(context).pop(); // Close the web login page
                UserCredential userCredential = await FirebaseAuth.instance
                    .signInWithPopup(GoogleAuthProvider());

                if (userCredential.user != null) {
                  String? idToken = await userCredential.user?.getIdToken();

                  await FirebaseFirestore.instance
                      .collection('tv_sessions')
                      .doc(sessionId)
                      .update({'userId': idToken}); // Store ID token, not UID

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "Successfully Logged in. You can now return to your TV")));
                }
              },
              child: Text(
                "Login with Google",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
