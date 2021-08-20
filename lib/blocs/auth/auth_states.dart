import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AppLoading extends AuthState {}

class Unauthenticated extends AuthState {}

class Authenticated extends AuthState {
  final User user;
  Authenticated(this.user);

  @override
  List<Object> get props => [user.uid];

  @override
  String toString() => "Authenticated { user: $user }";
}
