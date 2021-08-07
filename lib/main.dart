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
      initialRoute: '/',
      routes: {
        '/': (context) => SparkHome(),
        '/onboarding': (context) => OnboardingScreen(),
      },
    );
  }
}

class SparkHome extends StatefulWidget {
  SparkHome({Key? key}) : super(key: key);

  @override
  _SparkHomeState createState() => _SparkHomeState();
}

class _SparkHomeState extends State<SparkHome> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final Future<FirebaseApp> _initialisation = Firebase.initializeApp();
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  @override
  void initState() {
    super.initState();
    _prefs.then((SharedPreferences prefs) {
      if (!(prefs.getBool(SHARED_PREFS_ONBOARDING_STATUS_KEY) ?? false))
        Navigator.pushNamed(context, '/onboarding');
    });
  }

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
              drawer: Drawer(
                child: ListView(
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.zero,
                  children: [
                    const DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      ),
                      child: Text('Drawer Header'),
                    ),
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
                  ],
                ),
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
