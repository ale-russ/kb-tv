import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrLoginScreen extends StatefulWidget {
  @override
  _QrLoginScreenState createState() => _QrLoginScreenState();
}

class _QrLoginScreenState extends State<QrLoginScreen> {
  String? sessionId;

  @override
  void initState() {
    super.initState();
    generateSessionId();
  }

  Future<void> generateSessionId() async {
    sessionId = Uuid().v4(); // Generate unique session ID
    setState(() {});
    await FirebaseFirestore.instance.collection('tv_sessions').doc(sessionId).set({
      'status': 'waiting',
      'uid': null,
      'createdAt': FieldValue.serverTimestamp(),
    });

    listenForLogin(sessionId!);
  }

  void listenForLogin(String sessionId) async {
    log("listening for tv_sessions");
    FirebaseFirestore.instance
        .collection('tv_sessions')
        .doc(sessionId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists && snapshot.data()?['uid'] != null) {
        String uid = snapshot.data()?['uid'];

        // Log the TV app in
        log("TV logged in with UID: $uid");

        context.pushReplacement("/home");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String webLoginUrl =
        sessionId == null ? "" : "https://k-tv-e03dc.web.app/login?session=$sessionId";

    return Scaffold(
      appBar: AppBar(title: Text("TV Login")),
      body: Center(
        child: sessionId == null
            ? CircularProgressIndicator()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Scan this QR Code to log in"),
                  QrImageView(
                    data: webLoginUrl,
                    size: 200,
                    backgroundColor: Colors.white,
                  ),
                ],
              ),
      ),
    );
  }
}
