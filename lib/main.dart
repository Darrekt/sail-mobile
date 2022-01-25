import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sail/components/navigation/navbar.dart';
import 'package:sail/util/constants.dart';
import 'package:sail/components/home/HomeDrawer.dart';
import 'package:sail/pages/AlbumPage.dart';
import 'package:sail/pages/home/HomePage.dart';
import 'package:sail/pages/LoginPage.dart';
import 'package:sail/pages/OffersPage.dart';
import 'package:sail/pages/OnboardingPage.dart';
import 'package:sail/repositories/auth/auth_repository.dart';
import 'package:sail/repositories/auth/auth_repository_firebase.dart';
import 'package:sail/blocs/bloc_barrel.dart';
import 'package:sail/repositories/pictures/pictures_repository.dart';
import 'package:sail/repositories/pictures/pictures_repository_firebase.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final AuthRepository authRepo = FirebaseAuthRepository();
  final PicturesRepository picRepo = FirebasePicturesRepository();

  // Use emulators in debug mode
  if (kDebugMode) {
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    await FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
  }

  BlocOverrides.runZoned(
    () {
      runApp(SparkApp(
        authRepository: authRepo,
        picturesRepository: picRepo,
      ));
    },
    blocObserver: SparkBlocObserver(),
  );
}

class SparkApp extends StatelessWidget {
  final AuthRepository _authRepository;
  final PicturesRepository _picturesRepository;

  SparkApp({
    Key? key,
    required AuthRepository authRepository,
    required PicturesRepository picturesRepository,
  })  : _authRepository = authRepository,
        _picturesRepository = picturesRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _authRepository),
        // RepositoryProvider.value(value: _picturesRepository),
      ],
      child: BlocProvider(
        lazy: false,
        create: (context) => AuthBloc(auth: _authRepository)..add(AppStarted()),
        child: MultiBlocProvider(
          providers: [
            // BlocProvider<SettingsBloc>(
            //     create: (context) =>
            //         SettingsBloc(auth: context.read<AuthBloc>())),
            BlocProvider<PicturesBloc>(
              create: (context) => PicturesBloc(
                auth: context.read<AuthBloc>(),
                picturesRepository: _picturesRepository,
              ),
            ),
            // BlocProvider<OffersBloc>(
            //   create: (context) => OffersBloc(auth: context.read<AuthBloc>()),
            // ),
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
