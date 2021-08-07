import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key, this.error}) : super(key: key);
  final Object? error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(Icons.error),
          Text("Oops, something went wrong. See the error below:"),
          AutoSizeText(error.toString())
        ],
      ),
    );
  }
}
