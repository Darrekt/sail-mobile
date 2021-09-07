import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// {@template user}
/// SparkUser model
///
/// [SparkUser.empty] represents an unauthenticated user.
/// {@endtemplate}
class SparkUser extends Equatable {
  /// {@macro user}
  const SparkUser.fromScratch({
    required this.id,
    this.registrationToken,
    this.partnerId,
    this.email,
    this.emailVerified = false,
    this.name,
    this.photo,
  });

  factory SparkUser({User? firebaseUser}) {
    return firebaseUser != null
        ? SparkUser.fromScratch(
            id: firebaseUser.uid,
            registrationToken: null,
            partnerId: null,
            email: firebaseUser.email,
            emailVerified: firebaseUser.emailVerified,
            name: firebaseUser.displayName,
            photo: firebaseUser.photoURL,
          )
        : SparkUser.empty;
  }

  SparkUser.fromJson(Map<String, Object?> json)
      : id = json['id'] as String,
        registrationToken = json['registrationToken'] as String?,
        email = json['email'] as String?,
        emailVerified = json['emailVerified'] as bool,
        partnerId = json['partnerId'] as String?,
        name = json['name'] as String?,
        photo = json['photo'] as String?;

  SparkUser copyWith(
          {String? registrationToken,
          String? partnerId,
          String? email,
          bool? emailVerified,
          String? name,
          String? photo}) =>
      SparkUser.fromScratch(
        id: this.id,
        registrationToken: registrationToken ?? this.registrationToken,
        partnerId: partnerId ?? this.partnerId,
        email: email ?? this.email,
        emailVerified: emailVerified ?? this.emailVerified,
        name: name ?? this.name,
        photo: this.photo,
      );

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'registrationToken': registrationToken,
      'partnerId': partnerId,
      'email': email,
      'emailVerified': emailVerified,
      'name': name,
      'photo': photo,
    };
  }

  /// The current user's id.
  final String id;

  /// The registration token for the current app instance. Regenerated on every app restart.
  final String? registrationToken;

  /// The current user's id.
  final String? partnerId;

  /// The current user's email address.
  final String? email;

  /// The current user's email address.
  final bool emailVerified;

  /// The current user's name (display name).
  final String? name;

  /// Url for the current user's photo.
  final String? photo;

  /// Empty user which represents an unauthenticated user.
  static const empty = SparkUser.fromScratch(id: '');

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == SparkUser.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != SparkUser.empty;

  @override
  List<Object?> get props => [id, partnerId, email, name, photo];
}
