import 'package:flutter/material.dart';

class PartnerStatusHero extends StatelessWidget {
  const PartnerStatusHero({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _deviceDimensions = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: _deviceDimensions.height * 0.05,
        horizontal: _deviceDimensions.width * 0.1,
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Placeholder(
            fallbackHeight: _deviceDimensions.height * 0.2,
          ),
        ),
      ),
    );
  }
}
