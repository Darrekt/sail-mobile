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

class PairingInProgress extends Authenticated {
  final String partnerEmail;
  PairingInProgress(SparkUser user, this.partnerEmail) : super(user);

  @override
  List<Object> get props => [user.id, partnerEmail];

  @override
  String toString() =>
      "PairingInProgress { user: $user, partnerEmail: $partnerEmail}";
}

class PairingFailed extends Authenticated {
  final String reason;
  PairingFailed(SparkUser user, this.reason) : super(user);

  @override
  List<Object> get props => [user.id, reason];

  @override
  String toString() => "PairingFailed { user: $user, reason: $reason }";
}

class Paired extends Authenticated {
  final SparkUser partner;
  Paired(SparkUser user, this.partner) : super(user);

  @override
  List<Object> get props => [user.id, partner.id];

  @override
  String toString() => "Paired { user: $user, partner: $partner}";
}
