import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spark/repositories/pictures/pictures_repository.dart';

class FirebasePicturesRepository implements PicturesRepository {
  final _storage = FirebaseStorage.instance;
  final _picker = ImagePicker();

  /// Asynchronously fetch the URI of the user's profile image.
  Future<String> fetchProfilePictureURL(User user) async {
    return await _storage
        .ref('profile-pictures/${user.uid}.png')
        .getDownloadURL();
  }

  /// Uploads the selected image from the user's phone storage to a cloud storage container.
  Future<void> uploadProfilePicture(user, src) async {
    final XFile? imgPath = await _picker.pickImage(source: src);
    final String? filePath = imgPath?.path;
    Reference storageRef = _storage.ref('profile-pictures/${user.uid}.png');

    if (filePath == null) return;
    File file = File(filePath);

// TODO: Compress to a maximum file size
// TODO: Implement cropping and preview of photo
// TODO: Write our own User model and push the update to the AuthBloc instead
    try {
      await storageRef.putFile(file);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      log(e.message!);
    }

    // TODO: Create our own user model and delegate this to the AuthBloc
    await user.updatePhotoURL(await storageRef.getDownloadURL());
  }
}
