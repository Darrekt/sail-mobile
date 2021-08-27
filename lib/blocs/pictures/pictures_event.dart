part of 'pictures_bloc.dart';

abstract class PicturesEvent extends Equatable {
  const PicturesEvent();

  @override
  List<Object> get props => [];
}

class FetchProfilePictureURI extends PicturesEvent {}

class UploadProfilePicture extends PicturesEvent {
  final ImageSource payload;
  UploadProfilePicture(this.payload);

  @override
  List<Object> get props => [payload];

  @override
  String toString() {
    return "UploadProfilePicture: { payload: $payload }";
  }
}

class ClearProfilePicture extends PicturesEvent {}
