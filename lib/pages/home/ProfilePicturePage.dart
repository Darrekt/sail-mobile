import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spark/blocs/auth/auth_barrel.dart';
import 'package:spark/components/util/SettingsGroup.dart';
import 'package:spark/constants.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePicturePage extends StatelessWidget {
  ProfilePicturePage({Key? key}) : super(key: key);
  final _storage = FirebaseStorage.instance;
  final _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    // final Size _deviceDimensions = MediaQuery.of(context).size;
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        Future<void> _uploadAndSetProfilePicture(String? filePath) async {
          if (filePath == null || !(state is Authenticated)) return;
          File file = File(filePath);

          try {
            await _storage
                .ref('profile-pictures/${state.user.uid}.png')
                .putFile(file);
            await state.user.updatePhotoURL(
                "gs://spark-69.appspot.com/profile-pictures/${state.user.uid}.png");
          } on FirebaseException catch (e) {
            // e.g, e.code == 'canceled'
            // log(e.message);
          }
        }

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: Column(
            children: [
              GestureDetector(
                onTap: () {
                  // TODO: Move photo editing and upload to a modal actions in here
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Hero(
                    tag: HERO_TAG_DRAWER_PROFILE,
                    child: Material(
                      shape: CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      elevation: 8,
                      child: CircleAvatar(
                          radius: 69,
                          backgroundImage: NetworkImage(state is Authenticated
                              ? state.user.photoURL!
                              : "")),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () async {
                          final XFile? userImage = await _picker.pickImage(
                              source: ImageSource.camera);
                          _uploadAndSetProfilePicture(userImage?.path);
                        },
                        icon: Icon(Icons.photo_camera)),
                    IconButton(
                        onPressed: () async {
                          final XFile? userImage = await _picker.pickImage(
                              source: ImageSource.gallery);
                          _uploadAndSetProfilePicture(userImage?.path);
                        },
                        icon: Icon(Icons.photo_album)),
                    IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
                  ],
                ),
              ),
              SettingsGroup(
                  title: "Name",
                  subtitle: state is Authenticated
                      ? state.user.displayName!
                      : "Anonymous",
                  onTrailingCallback: () {}),
              SettingsGroup(
                  title: "Location",
                  subtitle: "Singapore",
                  onTrailingCallback: () {}),
              SettingsGroup(
                  title: "Email",
                  subtitle: state is Authenticated ? state.user.email! : "",
                  onTrailingCallback: () {}),
            ],
          ),
        );
      },
    );
  }
}
