import 'package:auto_size_text/auto_size_text.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sail/blocs/bloc_barrel.dart';
import 'package:sail/components/home/ProfileAvatar.dart';
import 'package:sail/components/util/SettingsGroup.dart';
import 'package:sail/util/constants.dart';

part 'EditParticularsPage.dart';

enum ProfileParticulars { Name, Password, Location, Email }

class ProfilePicturePage extends StatelessWidget {
  ProfilePicturePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final Size _deviceDimensions = MediaQuery.of(context).size;

    final Function(ProfileParticulars) editProfileField =
        (ProfileParticulars field) => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditParticularsPage(field)),
            );

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: SingleChildScrollView(
            child: Column(
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
                        child: ProfileAvatar(state.user, radius: 69),
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
                  subtitle: state.user.name ?? "Anonymous",
                  onTrailingCallback: () =>
                      editProfileField(ProfileParticulars.Name),
                ),
                SettingsGroup(
                  title: "Location",
                  subtitle: state.user.location ?? "Set your location!",
                  onTrailingCallback: () =>
                      editProfileField(ProfileParticulars.Location),
                ),
                SettingsGroup(
                  title: "Email",
                  subtitle: state.user.email ?? "No registered email",
                  onTrailingCallback: () =>
                      editProfileField(ProfileParticulars.Email),
                ),
                SettingsGroup(
                  title: "Password",
                  subtitle: "Change your password here",
                  onTrailingCallback: () =>
                      editProfileField(ProfileParticulars.Password),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    child: const Text('Sign out'),
                    onPressed: () {
                      Navigator.pop(context);
                      context.read<AuthBloc>().add(Logout());
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
