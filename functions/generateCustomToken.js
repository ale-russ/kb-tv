const admin = required("firebase-admin");
admin.initializeApp();

exports.generateCustomToken = functions.https.onCall(async (data, context) => {
  const uid = data.uid;

  try {
    const customToken = await admin.auth().createCustomToken(uid);

    //Store the customToken in FiresStore
    await admin.firestore().collection("tv_sessions").doc(data.sessionId).set({
      customToken: customToken,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      userId: uid,
    });

    return { success: true };
  } catch (err) {
    console.log("Error generating custom token: ", err);
    return { success: false, error: err.messsage };
  }
});
