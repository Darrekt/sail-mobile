import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spark/constants.dart';
import 'package:spark/screens/home/ProfilePictureScreen.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _deviceDimensions = MediaQuery.of(context).size;

    final drawerItems = [
      ListTile(
        title: const Text('Sign out'),
        onTap: () async {
          await FirebaseAuth.instance.signOut();
          Navigator.popAndPushNamed(context, '/login');
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
                        return ProfilePictureScreen();
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
                    "Darrick Lau",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  AutoSizeText(
                    "Singapore",
                    minFontSize: 8,
                    maxFontSize: 10,
                  ),
                  AutoSizeText(
                    "jkricklau@gmail.com",
                    minFontSize: 8,
                    maxFontSize: 10,
                  )
                ],
              )),
          ...(kReleaseMode ? drawerItems : drawerItems + devDrawerItems),
        ],
      ),
    );
  }
}
