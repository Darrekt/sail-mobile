import 'package:spark/models/SparkUser.dart';

// Thrown if the function is not implemented.
class NotImplementedException implements Exception {}

// Thrown if during the sign up process if a failure occurs.
class SignUpFailure implements Exception {}

/// Thrown during the login process if a failure occurs.
class LogInWithEmailFailure implements Exception {}

/// Thrown during the sign in with Google process if a failure occurs.
class LogInWithGoogleFailure implements Exception {}

/// Thrown during the sign in with Facebook process if a failure occurs.
class LogInWithFacebookFailure implements Exception {}

/// Thrown during the sign in with Apple process if a failure occurs.
class LogInWithAppleFailure implements Exception {}

/// Thrown during the logout process if a failure occurs.
class LogOutFailure implements Exception {}

/// {@template authentication_repository}
/// Repository which manages user authentication.
/// {@endtemplate}
abstract class AuthRepository {
  /// Checks whether a user is signed in.
  Future<bool> isAuthenticated() {
    throw NotImplementedException();
  }

  /// Fetches the user object.
  Stream<SparkUser> getPartner(SparkUser user) {
    throw NotImplementedException();
  }

  /// Fetches the user object.
  Stream<SparkUser> getUser() {
    throw NotImplementedException();
  }

  /// Attempts to sign up a user in with an email and password combination.
  Future<void> signUpEmail(String email, String password) {
    throw NotImplementedException();
  }

  /// Attempts to sign a user in with an email and password combination.
  Future<void> authenticateEmail(String email, String password) {
    throw NotImplementedException();
  }

  /// Attempts to sign a user in with an email and password combination.
  Future<void> authenticateEmailLink(String email) {
    throw NotImplementedException();
  }

  /// Attempts to sign a user in with Apple sign in.
  Future<void> authenticateApple() {
    throw NotImplementedException();
  }

  /// Attempts to sign a user in with Google. Throws a LogInWithGoogleFailure if a failure occurs.
  Future<void> authenticateGoogle() {
    throw NotImplementedException();
  }

  /// Attempts to sign a user in with Facebook. Throws a LogInWithFacebookFailure if a failure occurs.
  Future<void> authenticateFacebook() {
    throw NotImplementedException();
  }

  /// TODO: Links the current session to an existing user profile via an alternate sign-in.
  Future<void> linkEmail(String email, String password) {
    throw NotImplementedException();
  }

  /// Sign out.
  Future<void> logout() {
    throw NotImplementedException();
  }
}
