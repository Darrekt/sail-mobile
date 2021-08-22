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
    this.email,
    this.partnerId,
    this.name,
    this.photo,
  });

  factory SparkUser({User? firebaseUser}) {
    return firebaseUser != null
        ? SparkUser.fromScratch(
            id: firebaseUser.uid,
            email: firebaseUser.email,
            name: firebaseUser.displayName,
            photo: firebaseUser.photoURL,
          )
        : SparkUser.empty;
  }

  /// The current user's id.
  final String id;

  /// The current user's id.
  final String? partnerId;

  /// The current user's email address.
  final String? email;

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
