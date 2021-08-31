import 'package:flutter/material.dart';
import 'package:spark/models/SparkUser.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar(this.user, {Key? key, required this.radius})
      : super(key: key);
  final SparkUser user;
  final double radius;

  @override
  Widget build(BuildContext context) {
    String? pictureURI = user.photo ?? null;
    String fallbackString = user.name?.substring(0, 1) ?? "?";

    return CircleAvatar(
      radius: radius,
      backgroundColor: pictureURI != null ? null : Colors.orangeAccent,
      child: pictureURI != null
          ? null
          : Text(
              fallbackString,
              style: TextStyle(
                fontSize: radius / 1.5,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
      backgroundImage: pictureURI != null ? NetworkImage(pictureURI) : null,
    );
  }
}
