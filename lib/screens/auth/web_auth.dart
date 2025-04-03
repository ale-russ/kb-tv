// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class WebLoginPage extends StatelessWidget {
//   final String? sessionId;

//   const WebLoginPage({this.sessionId, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Web Login")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//               onPressed: () async {
//                 // await FirebaseAuth.instance
//                 //     .signInWithPopup(GoogleAuthProvider());
//                 // // After login, update Firestore with the userId
//                 // await FirebaseFirestore.instance
//                 //     .collection("tv_sessions")
//                 //     .doc(sessionId!)
//                 //     .update({
//                 //   "userId": FirebaseAuth.instance.currentUser?.uid,
//                 // });
//                 // Navigator.of(context).pop(); // Close the web login page
//                 UserCredential userCredential = await FirebaseAuth.instance
//                     .signInWithPopup(GoogleAuthProvider());

//                 if (userCredential.user != null) {
//                   String? idToken = await userCredential.user?.getIdToken();

//                   await FirebaseFirestore.instance
//                       .collection('tv_sessions')
//                       .doc(sessionId)
//                       .update({'userId': idToken}); // Store ID token

//                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                       content: Text(
//                           "Successfully Logged in. You can now return to your TV")));
//                 }
//               },
//               child: Text(
//                 "Login with Google",
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
