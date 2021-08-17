import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spark/components/util/SettingsGroup.dart';
import 'package:spark/constants.dart';

class ProfilePictureScreen extends StatelessWidget {
  ProfilePictureScreen({Key? key}) : super(key: key);
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final Size _deviceDimensions = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Hero(
                tag: HERO_TAG_DRAWER_PROFILE,
                child: Material(
                  shape: CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  elevation: 8,
                  child: CircleAvatar(
                      radius: 100,
                      backgroundImage:
                          NetworkImage("https://picsum.photos/250?image=9")),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                  IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
                ],
              ),
            ),
            SettingsGroup(
                title: "Name",
                subtitle: _auth.currentUser?.displayName ?? "Anonymous",
                onTrailingCallback: () {}),
            SettingsGroup(
                title: "Location",
                subtitle: "Singapore",
                onTrailingCallback: () {}),
            SettingsGroup(
                title: "Email",
                subtitle: _auth.currentUser?.email ?? "",
                onTrailingCallback: () {}),
          ],
        ),
      ),
    );
  }
}
