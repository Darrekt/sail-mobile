import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sail/blocs/bloc_barrel.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:sail/models/SparkUser.dart';
import 'package:sail/pages/home/PartnerPairingPage.dart';
import 'package:sail/pages/home/ProfilePicturePage.dart';
import 'ProfileAvatar.dart';

class UserDisplay extends StatelessWidget {
  const UserDisplay(
    this.user, {
    Key? key,
    this.heroTag,
    this.onTap,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  }) : super(key: key);
  final String? heroTag;
  final SparkUser user;
  final CrossAxisAlignment crossAxisAlignment;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: crossAxisAlignment,
          children: [
            GestureDetector(
              onTap: () {
                if (onTap != null) onTap!();
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return user == SparkUser.empty
                      ? PartnerPairingPage()
                      : ProfilePicturePage();
                }));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: heroTag != null
                    ? Hero(
                        tag: heroTag!,
                        child: ProfileAvatar(user, radius: 34.5),
                      )
                    : ProfileAvatar(user, radius: 34.5),
              ),
            ),
            AutoSizeText(
              user == SparkUser.empty ? "No partner" : user.name ?? "Anonymous",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            AutoSizeText(
              user == SparkUser.empty ? "Click to pair!" : "Singapore",
              minFontSize: 8,
              maxFontSize: 10,
            ),
          ],
        );
      },
    );
  }
}
