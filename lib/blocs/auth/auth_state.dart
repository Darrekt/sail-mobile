part of 'auth_bloc.dart';

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

class Paired extends Authenticated {
  final User partner;
  Paired(User user, this.partner) : super(user);

  @override
  List<Object> get props => [user.uid, partner.uid];

  @override
  String toString() => "Paired { user: $user, partner: $partner}";
}
