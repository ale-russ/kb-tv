import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

Future<String> generateSessionId() async {
  String sessionId = Uuid().v4();

  await FirebaseFirestore.instance
      .collection('tv_sessions')
      .doc(sessionId)
      .set({
    'status': "waiting",
    "uid": null,
    "createdAt": FieldValue.serverTimestamp()
  });

  return sessionId;
}
