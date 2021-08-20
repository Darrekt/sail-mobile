import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:spark/components/navigation/navbar.dart';
import 'package:spark/constants.dart';
import 'package:spark/components/home/HomeDrawer.dart';
import 'package:spark/pages/AlbumPage.dart';
import 'package:spark/pages/HomePage.dart';
import 'package:spark/pages/LoginPage.dart';
import 'package:spark/pages/OffersPage.dart';
import 'package:spark/pages/OnboardingPage.dart';
import 'package:spark/repositories/auth/auth_repository.dart';
import 'package:spark/repositories/auth/auth_repository_firebase.dart';
import 'package:spark/blocs/bloc_barrel.dart';

Future<void> main() async {
  // TODO: Add an observer for debugging
  Bloc.observer = SparkBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final AuthRepository authRepo = FirebaseAuthRepository();
  runApp(SparkApp(
    authRepository: authRepo,
  ));
}

class SparkApp extends StatelessWidget {
  SparkApp({Key? key, required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(key: key);
  final AuthRepository _authRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            lazy: false,
            create: (_) => AuthBloc(auth: _authRepository)..add(AppStarted()),
          ),
        ],
        child: MaterialApp(
          title: 'Spark',
          theme: ThemeData(
            primarySwatch: Colors.cyan,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => SparkHome(),
            '/login': (context) => LoginPage(),
            '/signup': (context) => LoginPage(),
            '/onboarding': (context) => OnboardingPage(),
          },
        ),
      ),
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) Navigator.pushNamed(context, '/login');
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        // appBar: ,
        drawer: HomeDrawer(),
        body: PersistentTabView(
          context,
          controller: _controller,
          screens: [
            HomePage(),
            AlbumPage(),
            OffersPage(),
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
      ),
    );
  }
}
