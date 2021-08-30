import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:spark/models/SparkUser.dart';

import 'auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late StreamSubscription _userSub;
  User? _user;

  FirebaseAuthRepository() {
    _userSub = _firebaseAuth.authStateChanges().listen((user) {
      _user = user;
    });
  }

  Future<bool> isAuthenticated() async {
    return _user != null;
  }

  Future<void> refreshUser() async {
    if (_user != null) await _user!.reload();
  }

  Stream<SparkUser> getUser() async* {
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
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
      }
      throw SignUpFailure();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> authenticateEmail(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print(e.code);
      throw LogInWithEmailFailure();
    }
    return;
  }

  Future<void> authenticateEmailLink(String email) async {
    try {
      throw NotImplementedException();
    } catch (e) {
      throw LogInWithEmailFailure();
    }
  }

  Future<void> authenticateApple() async {
    throw NotImplementedException();
  }

  Future<UserCredential> authenticateFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login();

      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      if (loginResult.status == LoginStatus.success) {}
      // Once signed in, return the UserCredential
      return _firebaseAuth.signInWithCredential(facebookAuthCredential);
    } catch (e) {
      throw LogInWithFacebookFailure();
    }
  }

  Future<UserCredential> authenticateGoogle() async {
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

      // Once signed in, return the UserCredential
      return await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      print(e.code);
      throw LogInWithGoogleFailure();
    } on PlatformException catch (e) {
      print(e.code);
      throw LogInWithGoogleFailure();
    }
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

  // Not sure, searched high and low for how to cancel StreamSubscriptions in non-widget classes in Dart.
  void dispose() => _userSub.cancel();
}
