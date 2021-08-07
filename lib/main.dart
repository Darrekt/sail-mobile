import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:spark/components/navigation/navbar.dart';
import 'package:spark/constants.dart';
import 'package:spark/screens/AlbumScreen.dart';
import 'package:spark/screens/ErrorScreen.dart';
import 'package:spark/screens/HomeScreen.dart';
import 'package:spark/screens/LoadingScreen.dart';
import 'package:spark/screens/OffersScreen.dart';
import 'package:spark/screens/OnboardingScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(SparkApp());
}

class SparkApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spark',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: OnboardingCheck(),
    );
  }
}

class OnboardingCheck extends StatefulWidget {
  OnboardingCheck({Key? key}) : super(key: key);

  @override
  _OnboardingCheckState createState() => _OnboardingCheckState();
}

class _OnboardingCheckState extends State<OnboardingCheck> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<bool> _onboardingDone;

  @override
  void initState() {
    super.initState();
    _onboardingDone = _prefs.then((SharedPreferences prefs) {
      return (prefs.getBool(SHARED_PREFS_ONBOARDING_STATUS_KEY) ?? false);
    });
  }

  void _setOnboardingDone() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      _onboardingDone = prefs
          .setBool(SHARED_PREFS_ONBOARDING_STATUS_KEY, true)
          .then((bool success) {
        log("Completed onboarding!");
        return success;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _onboardingDone,
        builder: (context, AsyncSnapshot<bool> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const CircularProgressIndicator();
            default:
              if (snapshot.hasError) {
                return ErrorScreen(error: snapshot.error);
              } else {
                return snapshot.data ?? false
                    ? SparkHome()
                    : OnboardingScreen(setOnboardingDone: _setOnboardingDone);
              }
          }
        });
  }
}

class SparkHome extends StatefulWidget {
  SparkHome({Key? key}) : super(key: key);

  @override
  _SparkHomeState createState() => _SparkHomeState();
}

class _SparkHomeState extends State<SparkHome> {
  final Future<FirebaseApp> _initialisation = Firebase.initializeApp();
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialisation,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorScreen(error: snapshot.error);
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                title: Text("Todo: scrolling"),
                elevation: 0,
                backgroundColor: Colors.transparent,
              ),
              body: PersistentTabView(
                context,
                controller: _controller,
                screens: [
                  HomeScreen(),
                  AlbumScreen(),
                  OffersScreen(),
                ],
                items: makeNavbarItems(),
                confineInSafeArea: true,
                backgroundColor: Colors.white,
                handleAndroidBackButtonPress: true,
                resizeToAvoidBottomInset: true,
                stateManagement: true,
                navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0
                    ? 0.0
                    : kBottomNavigationBarHeight,
                hideNavigationBarWhenKeyboardShows: true,
                margin: EdgeInsets.all(0.0),
                popActionScreens: PopActionScreensType.all,
                bottomScreenMargin: 0.0,
                // selectedTabScreenContext: (context) {
                //   testContext = context;
                // },
                decoration: NavBarDecoration(
                    colorBehindNavBar: Colors.indigo,
                    borderRadius: BorderRadius.circular(20.0)),
                popAllScreensOnTapOfSelectedTab: true,
                itemAnimationProperties: ItemAnimationProperties(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.ease,
                ),
                screenTransitionAnimation: ScreenTransitionAnimation(
                  animateTabTransition: true,
                  curve: Curves.ease,
                  duration: Duration(milliseconds: 200),
                ),
                navBarStyle: NavBarStyle
                    .style12, // Choose the nav bar style with this property
              ),
            );
          }
          return LoadingScreen();
        });
  }
}
