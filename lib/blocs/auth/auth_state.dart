part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AppLoading extends AuthState {}

class Unauthenticated extends AuthState {}

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
