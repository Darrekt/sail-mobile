import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  /// Checks whether a user is signed in.
  Future<bool> isAuthenticated();

  /// Fetches the user object.
  Stream<User?> getUser();

  /// Attempts to sign up a user in with an email and password combination.
  Future<void> signUpEmail(String email, String password);

  /// Attempts to sign a user in with an email and password combination.
  Future<void> authenticateEmail(String email, String password);

  /// Attempts to sign a user in with an email and password combination.
  Future<void> authenticateEmailLink(String email, String password);

  /// Attempts to sign a user in with Apple sign in.
  Future<void> authenticateApple();

  /// Attempts to sign a user in with Google.
  Future<void> authenticateGoogle();

  /// Attempts to sign a user in with Facebook.
  Future<void> authenticateFacebook();

  /// TODO: Links the current session to an existing user profile via an alternate sign-in.
  Future<void> linkEmail(String email, String password);

  /// Sign out.
  Future<void> logout();
}
