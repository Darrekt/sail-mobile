import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sail/blocs/bloc_barrel.dart';
import 'package:sail/components/home/UserDisplay.dart';
import 'package:sail/models/SparkUser.dart';
import 'package:sail/util/constants.dart';

class HomeDrawer extends StatelessWidget {
  HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final Size _deviceDimensions = MediaQuery.of(context).size;
    final drawerItems = [
      ListTile(
        title: const Text('Sign out'),
        onTap: () {
          Navigator.of(context).pop();
          context.read<AuthBloc>().add(Logout());
        },
      ),
    ];

    final devDrawerItems = [
      ListTile(
        title: const Text('Go to onboarding'),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.pushNamed(context, '/onboarding');
        },
      ),
      ListTile(
        title: const Text('Clear onboarding key'),
        onTap: () {
          Navigator.of(context).pop();
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      UserDisplay(
                        state.user,
                        heroTag: HERO_TAG_DRAWER_PROFILE,
                        onTap: () => Navigator.pop(context),
                      ),
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: Placeholder(
                          fallbackHeight: 30,
                          fallbackWidth: 30,
                        ),
                      ),
                      UserDisplay(
                        SparkUser.empty,
                        onTap: () => Navigator.pop(context),
                        crossAxisAlignment: CrossAxisAlignment.end,
                      ),
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
