import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

abstract class PicturesRepository {
  /// Asynchronously fetch the URI of the user's profile image.
  Future<String> fetchProfilePictureURL(User user);

  /// Uploads the selected image from the user's phone storage to a cloud storage container.
  Future<void> uploadProfilePicture(User user, ImageSource src);

  // Future<void> fetchAlbums();

  // Future<void> fetchAlbumImages(String album);
}
