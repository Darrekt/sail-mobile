import 'package:sail/blocs/auth/auth_bloc.dart';
import 'package:sail/models/SparkUser.dart';
import 'package:sail/util/exceptions/SailException.dart';

// Thrown if the function is not implemented.
class NotImplementedException extends SailException {
  NotImplementedException() : super("Not implemented");
}

// Thrown if some sensitive action was attempted, but no user was found logged in.
class UserNotLoggedInException extends SailException {
  UserNotLoggedInException()
      : super("You have to be logged in to perform this action.");
}

// Thrown if during the sign up process if a failure occurs.
class SignUpFailure extends SailException {
  SignUpFailure(String message) : super(message);
}

/// Thrown during the login process if a failure occurs.
class LogInWithEmailFailure extends SailException {
  LogInWithEmailFailure(String message) : super(message);
}

/// Thrown during the sign in with Google process if a failure occurs.
class LogInWithGoogleFailure extends SailException {
  LogInWithGoogleFailure(String message) : super(message);
}

/// Thrown during the sign in with Facebook process if a failure occurs.
class LogInWithFacebookFailure extends SailException {
  LogInWithFacebookFailure(String message) : super(message);
}

/// Thrown during the sign in with Apple process if a failure occurs.
class LogInWithAppleFailure extends SailException {
  LogInWithAppleFailure(String message) : super(message);
}

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

  Future<void> linkEmail(String email, String password) {
    throw NotImplementedException();
  }

  Future<void> findPartnerByEmail(String email) {
    throw NotImplementedException();
  }

  Future<void> updateDisplayName(String name) async {
    throw NotImplementedException();
  }

  Future<void> updateLocation(String? location) async {
    throw NotImplementedException();
  }

  Future<void> updateEmail(String email) async {
    throw NotImplementedException();
  }

  Future<void> updatePassword(String password) async {
    throw NotImplementedException();
  }

  Future<void> updateProfilePictureURI(String? uri) {
    throw NotImplementedException();
  }

  /// Sign out.
  Future<void> logout() {
    throw NotImplementedException();
  }
}
