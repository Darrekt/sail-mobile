// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
import * as functions from "firebase-functions";

// The Firebase Admin SDK to access Firestore.
import * as admin from "firebase-admin";
admin.initializeApp();

type PairingInformation = {
    secret: string;
    timeStamp: number;
    recipient: string;
    otpToken: string | null;
};

export const registerUser = functions.auth.user().onCreate(async (user) => {
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
    async (data, context) => {
        if (!context.auth) throw new functions.https.HttpsError('failed-precondition', 'Unauthenticated function caller');
        if (data.email == context.auth.token.email) throw new functions.https.HttpsError('invalid-argument', "Please input someone else's email")

        const partnerQss = await admin
            .firestore()
            .collection("users")
            .where("email", "==", data.email)
            .get()
            .then((snapshot) => snapshot.docs);
        const partner = partnerQss.length !== 0 ? partnerQss[0].data() : null;
        if (!partner || partner.partnerId) throw new functions.https.HttpsError('unavailable', 'Partner not found or already paired')

        // // Generate a pairing secret and store it in firestore.
        const pairing: PairingInformation = {
            secret: "TEST",
            timeStamp: new Date().valueOf(),
            recipient: partner.id,
            otpToken: null,
        };

        await admin.firestore().collection("pairing").doc(context.auth.uid).set(pairing);
        await admin.messaging().sendToDevice(
            partner.registrationToken,
            {
                data: {},
                notification: {
                    tag: "sailPairing",
                    title: "New pairing request!",
                    body: `Pairing request from ${data.name}`
                }
            }
        );
    }
);

export const acceptPairing = functions.https.onCall(async (data, context) => {
    // Check that the requester is an authenticated user.
    const requesterUid = context.auth?.uid ?? null;
    const recipientUid = (data.recipient as string | undefined) ?? null;

    if (requesterUid && recipientUid) {
        // await admin.firestore().collection("pairing").doc("TODO").update({});

        // Send a firebase cloud message to the recipient with the OTP for confirmation.
        // await admin.messaging().sendToDevice();
    } else throw Error("Unauthenticated requester");
});
