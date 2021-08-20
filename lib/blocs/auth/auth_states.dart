import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthState {}

class Unauthenticated extends AuthState {}

class LoginFailed extends AuthState {}

class Authenticated extends AuthState {
  final User user;
  Authenticated(this.user);

  @override
  List<Object> get props => [user.uid];

  @override
  String toString() => "Authenticated { user: $user }";
}
