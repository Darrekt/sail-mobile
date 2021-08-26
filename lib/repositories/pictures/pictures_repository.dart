import 'package:image_picker/image_picker.dart';
import 'package:spark/models/SparkUser.dart';

abstract class PicturesRepository {
  /// Asynchronously fetch the URI of the user's profile image.
  Future<String> fetchProfilePictureURL(SparkUser user);

  /// Uploads the selected image from the user's phone storage to a cloud storage container.
  Future<String> uploadProfilePicture(SparkUser user, ImageSource src);

  // Future<void> fetchAlbums();

  // Future<void> fetchAlbumImages(String album);
}
