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

class UpdateDisplayName extends AuthEvent {
  final String name;
  UpdateDisplayName(this.name);

  @override
  List<Object> get props => [this.name];

  @override
  String toString() => "UpdateDisplayName { name: $name }";
}

class UpdateLocation extends AuthEvent {
  final String location;
  UpdateLocation(this.location);

  @override
  List<Object> get props => [this.location];

  @override
  String toString() => "UpdateLocation { location: $location }";
}

class UpdateEmail extends AuthEvent {
  final String email;
  UpdateEmail(this.email);

  @override
  List<Object> get props => [this.email];

  @override
  String toString() => "UpdateEmail { email: $email }";
}

class UpdatePassword extends AuthEvent {
  final String password;
  UpdatePassword(this.password);

  @override
  List<Object> get props => [this.password];

  @override
  String toString() => "UpdatePassword { password: $password }";
}

class Logout extends AuthEvent {}
