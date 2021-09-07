// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
import * as functions from "firebase-functions";

// The Firebase Admin SDK to access Firestore.
import * as admin from "firebase-admin";
admin.initializeApp();

// No Typescript bindings available.
import { totp } from "otplib";

type PairingInformation = {
  requester: string;
  recipient: string;
  otpToken: string;
};

export const registerUser = functions.auth.user().onCreate(async (user, _) => {
  await admin
    .firestore()
    .collection("users")
    .doc(user.uid)
    .set(
      {
        id: user.uid,
        name: user.displayName,
        email: user.email,
        emailVerified: user.emailVerified,
        photo: user.photoURL,
      },
      { mergeFields: ["id", "name", "email", "emailVerified", "photo"] }
    );
});

export const findPartnerByEmail = functions.https.onCall(
  async (data, context) => {}
);

// TODO: Is there any best practices for initialising this?
const OTP_SECRET = "ZJ7IKB4YD5W27IS2";

export const generateOtpPair = functions.https.onCall(async (data, context) => {
  // Check that the requester is an authenticated user.
  const requesterUid = context.auth?.uid ?? null;
  const recipientUid = (data.recipient as string | undefined) ?? null;

  if (requesterUid && recipientUid) {
    //TODO: Generate with 1 minute validity
    const payload: PairingInformation = {
      requester: requesterUid,
      recipient: recipientUid,
      otpToken: totp.generate(OTP_SECRET),
    };

    const writtenDoc = await admin
      .firestore()
      .collection("pairing")
      .add(payload);

    // Send a firebase cloud message to the recipient with the OTP for confirmation.
    // await admin.messaging().sendToDevice();
  } else throw Error("Unauthenticated requester");
});
