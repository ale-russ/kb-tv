import 'dart:math';
import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
    _generateSession();
  }

  Future<void> _generateSession() async {
    sessionId = _generateRandomId();
    await FirebaseFirestore.instance
        .collection('tv_sessions')
        .doc(sessionId)
        .set({
      'userId': null,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Listen for login changes
    FirebaseFirestore.instance
        .collection('tv_sessions')
        .doc(sessionId)
        .snapshots()
        .listen((snapshots) {
      developer.log("userId: ${snapshots.data()?['userId']}");
      if (snapshots.exists && snapshots.data()?['userId'] != null) {
        _qrCodeSignIn(snapshots.data()?['userId']);
      }
    });

    setState(() {});
  }

  String _generateRandomId() {
    final random = Random();
    return List.generate(6, (index) => random.nextInt(10))
        .join(); //generates a 6-digit random id
  }

  Future<void> _qrCodeSignIn(String userId) async {
    developer.log('userid in _qrCodeSignIn: $userId');
    final auth = FirebaseAuth.instance;
    // final userCredential = await auth.signInWithCustomToken(userId);
    final userCredential = await auth.signInWithCredential(
      GoogleAuthProvider.credential(
        idToken: userId, // Ensure sessionId stores a valid ID token, not UID
      ),
    );

    developer.log("Signed in as :${userCredential.user!}");
    if (mounted) {
      // Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(builder: (context) => HomeScreen()));
      context.go('/home');
    }
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
