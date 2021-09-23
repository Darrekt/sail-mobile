import 'package:firebase_auth/firebase_auth.dart';

String prettyPrintFirebaseAuthExceptions(FirebaseAuthException e) {
  switch (e.code) {
    // FirebaseAuth.createUserWithEmailAndPassword
    case 'email-already-in-use':
      return "That email has been taken.";
    case 'invalid-email':
      return "Please input a valid email";
    case 'operation-not-allowed':
      return 'Email sign-ups have been disabled';
    case 'weak-password':
      return "Please use a stronger password.";

    // FirebaseAuth.signInWithEmailAndPassword
    case 'user-disabled':
      return "This account is disabled. Contact support for more details.";
    case 'user-not-found':
    case 'wrong-password':
      return "Invalid combination of credentials.";

    // FirebaseAuth.signInWithEmailLink
    case 'expired-action-code':
      return "OTP Expired. Please try again.";

    // FirebaseAuth.signInWithCredential
    case 'account-exists-with-different-credential':
    case 'invalid-credential':
      return "Invalid credentials. Please try again, or ensure that the account is correct.";

    default:
      print("WARNING: Add this exception: ${e.code}");
      return "An unknown error occurred.";
  }
}
