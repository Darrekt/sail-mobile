import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spark/blocs/bloc_barrel.dart';
import 'package:spark/components/home/ProfileAvatar.dart';
import 'package:spark/components/util/SettingsGroup.dart';
import 'package:spark/constants.dart';

class ProfilePicturePage extends StatelessWidget {
  ProfilePicturePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final Size _deviceDimensions = MediaQuery.of(context).size;
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: Column(
            children: [
              GestureDetector(
                onTap: () {
                  // TODO: Move photo editing and upload to a modal action in here
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Hero(
                    tag: HERO_TAG_DRAWER_PROFILE,
                    child: Material(
                      shape: CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      elevation: 8,
                      child: ProfileAvatar(
                        radius: 69,
                      ),
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
                          context
                              .read<PicturesBloc>()
                              .add(UploadProfilePicture(ImageSource.camera));
                        },
                        icon: Icon(Icons.photo_camera)),
                    IconButton(
                        onPressed: () async {
                          context
                              .read<PicturesBloc>()
                              .add(UploadProfilePicture(ImageSource.gallery));
                        },
                        icon: Icon(Icons.photo_album)),
                    IconButton(
                        onPressed: () {
                          context
                              .read<PicturesBloc>()
                              .add(ClearProfilePicture());
                        },
                        icon: Icon(Icons.delete)),
                  ],
                ),
              ),
              SettingsGroup(
                  title: "Name",
                  subtitle:
                      state is Authenticated ? state.user.name! : "Anonymous",
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
