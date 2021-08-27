import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spark/blocs/bloc_barrel.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({Key? key, required this.radius}) : super(key: key);
  final double radius;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String? pictureURI = state is Authenticated ? state.user.photo : null;
        String fallbackString = state is Authenticated
            ? state.user.name?.substring(0, 1) ?? ""
            : "";

        return CircleAvatar(
          radius: radius,
          backgroundColor: pictureURI != null ? null : Colors.teal,
          child: pictureURI != null
              ? null
              : Text(
                  fallbackString,
                  style: TextStyle(fontSize: radius / 2),
                ),
          backgroundImage: pictureURI != null ? NetworkImage(pictureURI) : null,
        );
      },
    );
  }
}
