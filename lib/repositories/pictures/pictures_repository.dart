import 'package:image_picker/image_picker.dart';
import 'package:sail/models/SparkUser.dart';

abstract class PicturesRepository {
  /// Asynchronously fetch the URI of the user's profile image.
  Future<String> fetchProfilePictureURL(SparkUser user);

  /// Uploads the selected image from the user's phone storage to a cloud storage container.
  Future<String> uploadProfilePicture(SparkUser user, ImageSource src);

  /// Clears the cloud storage container and sets the user's profile picture from cloud storage.
  Future<void> clearProfilePicture(SparkUser user);

  // Future<void> fetchAlbums();

  // Future<void> fetchAlbumImages(String album);
}
