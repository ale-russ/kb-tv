import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrLoginScreen extends ConsumerStatefulWidget {
  const QrLoginScreen({super.key, String? sessionId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QrLoginScreenState();
}

class _QrLoginScreenState extends ConsumerState<QrLoginScreen> {
  String sessionId = "";

  @override
  void initState() {
    super.initState();
    // _generateSession();
  }

  // Future<void> _generateSession() async {
  //   sessionId = _generateRandomId();
  //   await FirebaseFirestore.instance
  //       .collection('tv_sessions')
  //       .doc(sessionId)
  //       .set({
  //     'userId': null,
  //     'createdAt': FieldValue.serverTimestamp(),
  //   });
  //
  //   // Listen for login changes
  //   FirebaseFirestore.instance
  //       .collection('tv_sessions')
  //       .doc(sessionId)
  //       .snapshots()
  //       .listen((snapshots) {
  //     developer.log("userId: ${snapshots.data()?['userId']}");
  //     if (snapshots.exists && snapshots.data()?['userId'] != null) {
  //       _qrCodeSignIn(snapshots.data()?['userId']);
  //     }
  //   });
  //
  //   setState(() {});
  // }
  //
  // String _generateRandomId() {
  //   final random = Random();
  //   return List.generate(6, (index) => random.nextInt(10))
  //       .join(); //generates a 6-digit random id
  // }

  Future<void> _qrCodeSignIn(String userId) async {
    developer.log('userid in _qrCodeSignIn: $userId');
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      //   If user not logged in, show Google Sign-In, or email-password authentication;
      await FirebaseAuth.instance.signInWithProvider(GoogleAuthProvider());
      user = FirebaseAuth.instance.currentUser;
    }

    //Update Firestore session with the user's UID
    await FirebaseFirestore.instance
        .collection('tv_sessions')
        .doc(sessionId)
        .update({"uid": user!.uid, "status": "logged_in"});

    // final doc = await FirebaseFirestore.instance
    //     .collection('tv_sessions')
    //     .doc(sessionId)
    //     .get();
    //
    // developer.log("Doc: ${doc.data}");
    //
    // if (doc.exists) {
    //   final customToken = doc.data()?['userId'];
    //   try {
    //     final userCredential =
    //         await FirebaseAuth.instance.signInWithCustomToken(customToken);
    //
    //     developer.log("userCredential: ${userCredential.user} ");
    //
    //     if (userCredential.user?.uid == userId) {
    //       if (mounted) {
    //         context.pushNamed("/home");
    //       }
    //     }
    //   } catch (err) {
    //     debugPrint("Login Error: $err");
    //   }
    // } else {
    //   debugPrint("No Valid Custom token Found");
    // }
  }

  @override
  Widget build(BuildContext context) {
    developer.log("sessionId: $sessionId");
    return Scaffold(
      appBar: AppBar(title: Text("Scan QR Code to Login")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              backgroundColor: Colors.white,
              data: "https://k-tv-1fdcc.web.app/auth?session=$sessionId",
              size: 200,
            ),
            const SizedBox(height: 20),
            Text(
              "Scan with your phone to login",
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
