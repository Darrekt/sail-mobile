import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key, required this.setOnboardingDone})
      : super(key: key);
  final VoidCallback setOnboardingDone;

  @override
  Widget build(BuildContext context) {
    PageViewModel makePVM(
        Color? color, String assetPath, String title, String body) {
      return PageViewModel(
          pageColor: color,
          mainImage: SvgPicture.asset(
            assetPath,
            height: MediaQuery.of(context).size.width * 0.5,
            width: MediaQuery.of(context).size.width * 0.5,
          ),
          title: AutoSizeText(title),
          body: AutoSizeText(body),
          titleTextStyle: TextStyle(fontSize: 30, color: Colors.black),
          bodyTextStyle: TextStyle(fontSize: 18, color: Colors.black));
    }

    return IntroViewsFlutter(
      [
        makePVM(
          Colors.teal,
          'assets/hearts.svg',
          'Welcome!',
          "We're here to make being apart a little less painful.",
        ),
        makePVM(
          Colors.tealAccent[400],
          'assets/love.svg',
          'Share important moments!',
          "Use our timeline feature to never forget a special moment again, or use Google photos to create shared albums!",
        ),
        makePVM(
          Colors.tealAccent,
          'assets/love-letter.svg',
          'See each other sooner!',
          "Our reunion feature uses robots to bring you discounts on tickets to each others' cities!",
        ),
        makePVM(
          Colors.tealAccent,
          'assets/love-letter.svg',
          'Get started!',
          "We'll need you to sign in and then follow the instructions to pair with your partner.",
        ),
      ],
      onTapDoneButton: setOnboardingDone,
      showSkipButton: true,
      pageButtonTextStyles: TextStyle(
        color: Colors.black,
        fontSize: 14.0,
        fontFamily: 'Regular',
      ),
    );
  }
}
