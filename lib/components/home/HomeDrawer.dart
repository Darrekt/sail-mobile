import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spark/blocs/auth/auth_barrel.dart';
import 'package:spark/constants.dart';
import 'package:spark/pages/home/ProfilePicturePage.dart';

class HomeDrawer extends StatelessWidget {
  HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final Size _deviceDimensions = MediaQuery.of(context).size;

    final drawerItems = [
      ListTile(
        title: const Text('Sign out'),
        onTap: () {
          Navigator.pop(context);
          context.read<AuthBloc>().add(Logout());
        },
      ),
    ];

    final devDrawerItems = [
      ListTile(
        title: const Text('Go to onboarding'),
        onTap: () {
          Navigator.pushNamed(context, '/onboarding');
        },
      ),
      ListTile(
        title: const Text('Clear onboarding key'),
        onTap: () {
          // Update the state of the app.
          // ...
        },
      ),
    ];

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                  decoration: BoxDecoration(color: Colors.cyan),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ProfilePicturePage();
                          }));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Hero(
                              tag: HERO_TAG_DRAWER_PROFILE,
                              child: CircleAvatar(
                                  radius: 34.5,
                                  backgroundImage: NetworkImage(
                                      "https://picsum.photos/250?image=9"))),
                        ),
                      ),
                      AutoSizeText(
                        state is Authenticated
                            ? state.user.displayName!
                            : "Anonymous",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      AutoSizeText(
                        "Singapore",
                        minFontSize: 8,
                        maxFontSize: 10,
                      ),
                      AutoSizeText(
                        state is Authenticated
                            ? state.user.email!
                            : "Anonymous",
                        minFontSize: 8,
                        maxFontSize: 10,
                      )
                    ],
                  )),
              ...(kReleaseMode ? drawerItems : drawerItems + devDrawerItems),
            ],
          ),
        );
      },
    );
  }
}
