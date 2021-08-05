import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

List<PersistentBottomNavBarItem> makeNavbarItems() {
  return [
    PersistentBottomNavBarItem(
      icon: Icon(Icons.home),
      title: "Home",
      activeColorPrimary: Colors.cyan,
      inactiveColorPrimary: Colors.grey,
      inactiveColorSecondary: Colors.purple,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(Icons.collections),
      title: ("Albums"),
      activeColorPrimary: Colors.cyan,
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(Icons.local_offer),
      title: ("Offers"),
      activeColorPrimary: Colors.cyan,
      inactiveColorPrimary: Colors.grey,
      // routeAndNavigatorSettings: RouteAndNavigatorSettings(
      //   initialRoute: '/',
      //   routes: {
      //     '/home': (context) => MainScreen2(),
      //     '/albums': (context) => MainScreen3(),
      //   },
      // ),
    ),
  ];
}
