import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:spark/components/navigation/navbar.dart';
import 'package:spark/screens/AlbumScreen.dart';
import 'package:spark/screens/ErrorScreen.dart';
import 'package:spark/screens/HomeScreen.dart';
import 'package:spark/screens/LoadingScreen.dart';
import 'package:spark/screens/OffersScreen.dart';
import 'package:spark/screens/OnboardingScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final Future<FirebaseApp> _initialisation = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialisation,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorScreen();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return MyApp();
          }
          return LoadingScreen();
        });
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spark',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _hideNavBar = false;
  bool _onboardingDone = false;
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [
      HomeScreen(),
      AlbumScreen(),
      OffersScreen(),
    ];
  }

  void _setOnboardingDone() => {
        setState(() {
          _onboardingDone = true;
        })
      };

  @override
  Widget build(BuildContext context) {
    return _onboardingDone
        ? Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              title: Text("Todo: scrolling"),
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            body: PersistentTabView(
              context,
              controller: _controller,
              screens: _buildScreens(),
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
              hideNavigationBar: _hideNavBar,
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
          )
        : OnboardingScreen(
            setOnboardingDone: _setOnboardingDone,
          );
  }
}
