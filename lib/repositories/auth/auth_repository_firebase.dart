import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sail/components/util/ErrorToast.dart';
import 'package:sail/models/SparkUser.dart';
import 'package:sail/util/exceptions/prettyPrintExceptions.dart';
import 'auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final CollectionReference<SparkUser> usersRef = FirebaseFirestore.instance
      .collection('users')
      .withConverter<SparkUser>(
          fromFirestore: (doc, _) => SparkUser.fromJson(doc.data()!),
          toFirestore: (user, _) => user.toJson());

  late StreamSubscription _userSub;
  User? _user;

  FirebaseAuthRepository() {
    _userSub = _firebaseAuth.userChanges().listen((user) async {
      _user = user;
      if (user != null) {
        // partnerId and location are not managed by auth, so we shall not set them.
        await usersRef.doc(user.uid).set(
            SparkUser(firebaseUser: user)
                .copyWith(registrationToken: await messaging.getToken()),
            SetOptions(mergeFields: [
              'email',
              'emailVerified',
              'id',
              'name',
              'photo',
              'registrationToken'
            ]));
      }
    });
  }

  Future<bool> isAuthenticated() async {
    return _user != null;
  }

  Future<void> refreshUser() async {
    if (_user != null) await _user!.reload();
  }

  Stream<SparkUser> getUser() async* {
    // TODO: modify this stream to also add events for the firestore changes
    yield* _firebaseAuth
        .userChanges()
        .map((event) => SparkUser(firebaseUser: event));
  }

  Stream<SparkUser> getPartner(SparkUser user) async* {
    // bool loggedIn = await isAuthenticated();
    // if (loggedIn) {
    //   _firestore
    //       .collection('users')
    //       .doc(_firebaseAuth.currentUser!.uid)
    //       .snapshots()
    //       .listen((event) async* {
    //     yield event.data()?['partner'];
    //   });
    // } else
    //   yield null;
    throw NotImplementedException();
  }

  Future<void> signUpEmail(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw SignUpFailure(prettyPrintFirebaseAuthExceptions(e));
    } catch (e) {
      throw SignUpFailure("An unknown error occurred: ${e.toString()}");
    }
  }

  Future<void> authenticateEmail(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw LogInWithEmailFailure(prettyPrintFirebaseAuthExceptions(e));
    } catch (e) {
      showErrorToast(e.toString());
    }
  }

  Future<void> authenticateEmailLink(String email) async {
    try {
      throw NotImplementedException();
    } on FirebaseAuthException catch (e) {
      throw LogInWithEmailFailure(prettyPrintFirebaseAuthExceptions(e));
    } catch (e) {
      showErrorToast(e.toString());
    }
  }

  Future<void> authenticateApple() async {
    try {
      throw NotImplementedException();
    } on FirebaseAuthException catch (e) {
      throw LogInWithAppleFailure(prettyPrintFirebaseAuthExceptions(e));
    } catch (e) {
      showErrorToast(e.toString());
    }
  }

  Future<void> authenticateFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login();

      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      if (loginResult.status == LoginStatus.success)
        await _firebaseAuth.signInWithCredential(facebookAuthCredential);
    } on FirebaseAuthException catch (e) {
      throw LogInWithFacebookFailure(prettyPrintFirebaseAuthExceptions(e));
    } catch (e) {
      showErrorToast(e.toString());
    }
  }

  Future<void> authenticateGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw LogInWithGoogleFailure(prettyPrintFirebaseAuthExceptions(e));
    } on PlatformException catch (e) {
      throw LogInWithGoogleFailure(e.toString());
    }
  }

  Future<void> updateDisplayName(String name) async {
    if (_user != null)
      await _user!.updateDisplayName(name);
    else
      throw UserNotLoggedInException();
  }

  Future<void> updateLocation(String? location) async {
    if (_user != null) {
      await usersRef.doc(_user?.uid).set(
          SparkUser(firebaseUser: _user).copyWith(location: location),
          SetOptions(mergeFields: ['location']));
    } else
      throw UserNotLoggedInException();
  }

  Future<void> updateEmail(String email) async {
    if (_user != null)
      await _user!.updateEmail(email);
    else
      throw UserNotLoggedInException();
  }

  Future<void> updatePassword(String password) async {
    if (_user != null)
      await _user!.updatePassword(password);
    else
      throw UserNotLoggedInException();
  }

  Future<void> updateProfilePictureURI(String? uri) async {
    if (_user != null)
      await _user!.updatePhotoURL(uri);
    else
      throw UserNotLoggedInException();
  }

  Future<void> logout() async {
    return await _firebaseAuth.signOut();
  }

  Future<void> linkEmail(String email, String password) async {
    final eCred =
        EmailAuthProvider.credential(email: email, password: password);
    await _firebaseAuth.currentUser?.linkWithCredential(eCred);
    return;
  }

// TODO: Extract out into another bloc
  Future<void> findPartnerByEmail(String email) async {
    print("Starting function");
    HttpsCallable promptPartner =
        FirebaseFunctions.instance.httpsCallable('findPartnerByEmail');
    var result = await promptPartner.call(<String, dynamic>{
      'email': email,
      'name': _user?.displayName ?? "Anon",
    });
    print(result.toString());
  }

  // Not sure, searched high and low for how to cancel StreamSubscriptions in non-widget classes in Dart.
  void dispose() => _userSub.cancel();
}
