import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          // TODO: Replace placeholder image with user-chosen one
          "https://i.pinimg.com/originals/cb/e5/22/cbe522e7e41945d8744e7ad2b84465f5.jpg",
          fit: BoxFit.fill,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.05,
              horizontal: MediaQuery.of(context).size.width * 0.05),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Placeholder(
                  fallbackHeight: MediaQuery.of(context).size.height * 0.2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Placeholder(
                  fallbackHeight: MediaQuery.of(context).size.height * 0.6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
