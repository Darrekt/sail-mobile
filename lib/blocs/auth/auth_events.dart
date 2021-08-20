import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}

class AuthStateUpdated extends AuthEvent {
  final User? payload;
  AuthStateUpdated(this.payload);

  @override
  List<Object> get props => [payload?.uid ?? ""];

  @override
  String toString() => "AuthStateUpdated { user: $payload }";
}

class TryEmailSignUp extends AuthEvent {
  final String email;
  final String password;
  TryEmailSignUp(this.email, this.password);

  @override
  List<Object> get props => [email, password];

  @override
  String toString() => "TryEmailSignIn { email: $email, password: $password }";
}

class TryEmailSignIn extends AuthEvent {
  final String email;
  final String password;
  TryEmailSignIn(this.email, this.password);

  @override
  List<Object> get props => [email, password];

  @override
  String toString() => "TryEmailSignIn { email: $email, password: $password }";
}

class TryFacebookSignIn extends AuthEvent {}

class TryGoogleSignIn extends AuthEvent {}

class TryAppleSignIn extends AuthEvent {}

class Logout extends AuthEvent {}
