part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  final SparkUser user = SparkUser.empty;
  const AuthState();

  @override
  List<Object> get props => [];
}

class AppLoading extends AuthState {}

class Unauthenticated extends AuthState {
  final String? reason;
  Unauthenticated([this.reason]);

  @override
  List<Object> get props => [reason ?? ""];

  @override
  String toString() => "Unauthenticated { reason: $reason }";
}

class Authenticated extends AuthState {
  final SparkUser user;
  Authenticated(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => "Authenticated { user: $user }";
}
