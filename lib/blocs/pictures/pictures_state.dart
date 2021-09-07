part of 'pictures_bloc.dart';

abstract class PicturesState extends Equatable {
  const PicturesState();

  @override
  List<Object> get props => [];
}

class PicturesIdle extends PicturesState {
  final String profilePictureURI;
  PicturesIdle(this.profilePictureURI);

  @override
  List<Object> get props => [profilePictureURI];

  @override
  String toString() {
    return "PicturesIdle: { profilePictureURI: $profilePictureURI }";
  }
}

class PicturesFetching extends PicturesState {}
