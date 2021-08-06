import 'package:flutter/material.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key, required this.setOnboardingDone})
      : super(key: key);
  final VoidCallback setOnboardingDone;

  @override
  Widget build(BuildContext context) {
    return IntroViewsFlutter(
      [
        PageViewModel(
          pageColor: Colors.tealAccent,
          iconImageAssetPath: 'assets/taxi-driver.png',
          body: Text(
            "We're here to make being apart a litte less painful.",
          ),
          title: Text("Welcome!"),
          mainImage: Image.asset(
            'assets/taxi.png',
            height: 285.0,
            width: 285.0,
            alignment: Alignment.center,
          ),
          titleTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.black),
          bodyTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.black),
        ),
        PageViewModel(
          pageColor: Colors.tealAccent,
          iconImageAssetPath: 'assets/taxi-driver.png',
          body: Text(
            "We're here to make being apart a litte less painful.",
          ),
          title: Text("Welcome!"),
          mainImage: Image.asset(
            'assets/taxi.png',
            height: 285.0,
            width: 285.0,
            alignment: Alignment.center,
          ),
          titleTextStyle: TextStyle(color: Colors.black),
          bodyTextStyle: TextStyle(color: Colors.black),
        ),
        PageViewModel(
          pageColor: Colors.tealAccent,
          iconImageAssetPath: 'assets/taxi-driver.png',
          body: Text(
            "We're here to make being apart a litte less painful.",
          ),
          title: Text("Welcome!"),
          mainImage: Image.asset(
            'assets/taxi.png',
            height: 285.0,
            width: 285.0,
            alignment: Alignment.center,
          ),
          titleTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.black),
          bodyTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.black),
        )
      ],
      onTapDoneButton: setOnboardingDone,
      showSkipButton: true,
      pageButtonTextStyles: TextStyle(
        color: Colors.black,
        fontSize: 14.0,
        fontFamily: 'Regular',
      ),
    );
    ;
  }
}
