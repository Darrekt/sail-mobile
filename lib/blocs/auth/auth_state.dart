part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  final SparkUser user = SparkUser.empty;
  final SparkUser partner = SparkUser.empty;
  const AuthState();

  @override
  List<Object> get props => [];
}

class AppLoading extends AuthState {}

class Unauthenticated extends AuthState {}

class LoginFailed extends Unauthenticated {
  final String message;
  LoginFailed(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => "LoginFailed { message: $message }";
}

class Authenticated extends AuthState {
  final SparkUser user;
  Authenticated(this.user);

  @override
  List<Object> get props => [user.id];

  @override
  String toString() => "Authenticated { user: $user }";
}

class Paired extends Authenticated {
  final SparkUser partner;
  Paired(SparkUser user, this.partner) : super(user);

  @override
  List<Object> get props => [user.id, partner.id];

  @override
  String toString() => "Paired { user: $user, partner: $partner}";
}
