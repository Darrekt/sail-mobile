import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.cyan,
            ),
            child: Text(''),
          ),
          ...(kReleaseMode ? drawerItems : drawerItems + devDrawerItems),
        ],
      ),
    );
  }
}
