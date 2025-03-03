const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

// Cloud Function to generate a custom token
exports.generateCustomToken = functions.https.onCall(async (data, context) => {
  const uid = data.uid; // The user ID for whom we generate the token

  if (!uid) {
    throw new functions.https.HttpsError("invalid-argument", "UID is required");
  }

  try {
    // Generate a custom token
    const customToken = await admin.auth().createCustomToken(uid);
    // eslint-disable-next-line object-curly-spacing
    return { customToken };
  } catch (error) {
    console.error("Error creating custom token:", error);
    // eslint-disable-next-line max-len
    throw new functions.https.HttpsError(
      // eslint-disable-next-line indent
      // eslint-disable-next-line indent
      "internal",
      // eslint-disable-next-line comma-dangle, indent
      "Failed to generate custom token"
    );
  }
});
