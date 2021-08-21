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
  Future<String> fetchProfilePictureURL() async {
    return "a";
  }

  /// Uploads the selected image from the user's phone storage to a cloud storage container.
  Future<void> uploadProfilePicture(user, src) async {
    final XFile? imgPath = await _picker.pickImage(source: src);
    final String? filePath = imgPath?.path;

    if (filePath == null) return;
    File file = File(filePath);

    try {
      await _storage.ref('profile-pictures/${user.uid}.png').putFile(file);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      log(e.message!);
    }

    // TODO: Create our own user model and delegate this to the AuthBloc
    await user.updatePhotoURL(
        "https://spark-69.appspot.com/profile-pictures/${user.uid}.png");
  }
}
