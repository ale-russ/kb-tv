import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class WebLoginPage extends ConsumerStatefulWidget {
  final String? sessionId;

  WebLoginPage({this.sessionId, super.key});

  @override
  ConsumerState<WebLoginPage> createState() => _WebLoginPageState();
}

class _WebLoginPageState extends ConsumerState<WebLoginPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: "QR");

  QRViewController? controller;

  bool isPorcessing = false;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

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
                setState(() {
                  isPorcessing = true;
                });
                User? user = FirebaseAuth.instance.currentUser;
                GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
                UserCredential userCredential = await FirebaseAuth.instance
                    .signInWithPopup(googleAuthProvider);

                user = userCredential.user;

                if (user != null) {
                  // String? idToken = await userCredential.user?.getIdToken();

                  await FirebaseFirestore.instance
                      .collection('tv_sessions')
                      .doc(widget.sessionId)
                      .update({
                    'uid': user.uid,
                    'status': 'logged_in'
                  }); // Store ID token

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "Successfully Logged in. You can now return to your TV")));
                }

                setState(() {
                  isPorcessing = false;
                });
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
