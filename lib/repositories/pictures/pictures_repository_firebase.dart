import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sail/models/SparkUser.dart';
import 'package:sail/repositories/pictures/pictures_repository.dart';

class FirebasePicturesRepository implements PicturesRepository {
  final _storage = FirebaseStorage.instance;
  final _picker = ImagePicker();

  /// Asynchronously fetch the URI of the user's profile image.
  Future<String> fetchProfilePictureURL(SparkUser user) async {
    return await _storage
        .ref('profile-pictures/${user.id}.png')
        .getDownloadURL();
  }

  /// Uploads the selected image from the user's phone storage to a cloud storage container.
  Future<String> uploadProfilePicture(user, src) async {
    final XFile? imgPath = await _picker.pickImage(source: src);
    final String? filePath = imgPath?.path;
    Reference storageRef = _storage.ref('profile-pictures/${user.id}.png');

    if (filePath == null) return "";
    File file = File(filePath);

// TODO: Compress to a maximum file size
// TODO: Implement cropping and preview of photo
    try {
      await storageRef.putFile(file);
      return await storageRef.getDownloadURL();
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      log(e.message!);
      return "";
    }
  }

  Future<void> clearProfilePicture(user) async {
    await _storage.ref('profile-pictures/${user.id}.png').delete();
  }
}
