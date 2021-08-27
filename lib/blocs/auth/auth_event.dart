part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}

class AuthStateUpdated extends AuthEvent {
  final SparkUser payload;
  AuthStateUpdated(this.payload);

  @override
  List<Object> get props => [payload.id];

  @override
  String toString() => "AuthStateUpdated { user: $payload }";
}

class PartnerUpdated extends AuthEvent {
  final SparkUser payload;
  PartnerUpdated(this.payload);

  @override
  List<Object> get props => [payload.id];

  @override
  String toString() => "PartnerUpdated { partner: $payload }";
}

class TryLinkPartner extends AuthEvent {
  final SparkUser payload;
  TryLinkPartner(this.payload);

  @override
  List<Object> get props => [payload.id];

  @override
  String toString() => "AuthStateUpdated { partner: $payload }";
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

class UpdateProfilePictureURI extends AuthEvent {
  final String? payload;
  UpdateProfilePictureURI(this.payload);

  @override
  List<Object> get props => [payload ?? ""];

  @override
  String toString() => "UpdateProfilePictureURI { payload: $payload }";
}

class Logout extends AuthEvent {}
