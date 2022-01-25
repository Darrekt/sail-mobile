import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:sail/components/util/ErrorToast.dart';
import 'package:sail/models/SparkUser.dart';
import 'package:sail/repositories/auth/auth_repository.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _auth;
  StreamSubscription<SparkUser>? _userSubscription;

  AuthBloc({required AuthRepository auth})
      : _auth = auth,
        super(AppLoading()) {
    on<AppStarted>((event, emit) {
      if (_userSubscription != null) _userSubscription!.cancel();
      _userSubscription = _auth.getUser().listen((SparkUser update) {
        add(AuthStateUpdated(update));
      });
    });

    on<AuthStateUpdated>((event, emit) {
      emit(event.payload.isEmpty
          ? Unauthenticated()
          : Authenticated(event.payload));
    });

    on<TryEmailSignUp>((event, emit) {
      if (state is Unauthenticated) {
        try {
          _auth.signUpEmail(event.email, event.password);
        } on SignUpFailure catch (e) {
          showErrorToast(e.message);
        }
      } else {
        _auth.linkEmail(event.email, event.password);
      }
    });

    on<TryEmailSignIn>((event, emit) {
      if (state is Unauthenticated) {
        try {
          _auth.authenticateEmail(event.email, event.password);
        } on LogInWithEmailFailure catch (e) {
          showErrorToast(e.message);
        }
      }
    });

    on<TryFacebookSignIn>((event, emit) {
      try {
        _auth.authenticateFacebook();
      } on LogInWithFacebookFailure catch (e) {
        showErrorToast(e.message);
      }
    });

    on<TryGoogleSignIn>((event, emit) {
      try {
        _auth.authenticateGoogle();
      } on LogInWithGoogleFailure catch (e) {
        showErrorToast(e.message);
      } on PlatformException catch (e) {
        showErrorToast(e.message ?? "Platform Error occurred.");
      }
    });

    on<TryAppleSignIn>((event, emit) {
      try {
        _auth.authenticateApple();
      } on LogInWithAppleFailure catch (e) {
        showErrorToast(e.message);
      }
    });

    on<UpdateDisplayName>((event, emit) => _auth.updateDisplayName(event.name));

    on<UpdateLocation>((event, emit) => _auth.updateLocation(event.location));

    on<UpdateEmail>((event, emit) => _auth.updateEmail(event.email));

    on<UpdatePassword>((event, emit) => _auth.updatePassword(event.password));

    on<UpdateProfilePictureURI>(
        (event, emit) => _auth.updateProfilePictureURI(event.payload));

    on<Logout>((event, emit) => _auth.logout());
  }

  @override
  Future<void> close() {
    // ignore_for_file: cancel_subscriptions
    if (_userSubscription != null) _userSubscription!.cancel();
    return super.close();
  }
}
