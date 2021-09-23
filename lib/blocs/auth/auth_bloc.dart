import 'dart:async';
import 'package:bloc/bloc.dart';
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
        super(AppLoading());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is AuthStateUpdated) {
      yield* _mapAuthStateUpdatedToState(event);
    } else if (event is TryEmailSignUp) {
      yield* _mapTryEmailSignUpToState(event);
    } else if (event is TryEmailSignIn) {
      yield* _mapTryEmailSignInToState(event);
    } else if (event is TryFacebookSignIn) {
      yield* _mapTryFacebookSignInToState();
    } else if (event is TryGoogleSignIn) {
      yield* _mapTryGoogleSignInToState();
    } else if (event is TryAppleSignIn) {
      yield* _mapTryAppleSignInToState();
    } else if (event is UpdateProfilePictureURI) {
      yield* _mapUpdateProfilePictureURIToState(event);
    } else if (event is Logout) {
      yield* _mapLogOutToState();
    } else
      throw NotImplementedException();
  }

  Stream<AuthState> _mapAppStartedToState() async* {
    if (_userSubscription != null) _userSubscription!.cancel();
    _userSubscription = _auth.getUser().listen((SparkUser update) {
      add(AuthStateUpdated(update));
    });
  }

  Stream<AuthState> _mapAuthStateUpdatedToState(AuthStateUpdated event) async* {
    yield event.payload.isEmpty
        ? Unauthenticated()
        : Authenticated(event.payload);
  }

  Stream<AuthState> _mapTryEmailSignUpToState(TryEmailSignUp event) async* {
    if (state is Unauthenticated) {
      try {
        await _auth.signUpEmail(event.email, event.password);
      } on SignUpFailure catch (e) {
        showErrorToast(e.message);
      }
    } else {
      await _auth.linkEmail(event.email, event.password);
    }
  }

  Stream<AuthState> _mapTryEmailSignInToState(TryEmailSignIn event) async* {
    if (state is Unauthenticated) {
      try {
        await _auth.authenticateEmail(event.email, event.password);
      } on LogInWithEmailFailure catch (e) {
        showErrorToast(e.message);
      }
    }
  }

  Stream<AuthState> _mapTryFacebookSignInToState() async* {
    try {
      await _auth.authenticateFacebook();
    } on LogInWithFacebookFailure catch (e) {
      showErrorToast(e.message);
    }
  }

  Stream<AuthState> _mapTryGoogleSignInToState() async* {
    try {
      await _auth.authenticateGoogle();
    } on LogInWithGoogleFailure catch (e) {
      showErrorToast(e.message);
    }
  }

  Stream<AuthState> _mapTryAppleSignInToState() async* {
    try {
      await _auth.authenticateApple();
    } on LogInWithAppleFailure catch (e) {
      showErrorToast(e.message);
    }
  }

  Stream<AuthState> _mapUpdateProfilePictureURIToState(
      UpdateProfilePictureURI event) async* {
    await _auth.updateProfilePictureURI(event.payload);
  }

  Stream<AuthState> _mapLogOutToState() async* {
    await _auth.logout();
  }

  @override
  Future<void> close() {
    // ignore_for_file: cancel_subscriptions
    if (_userSubscription != null) _userSubscription!.cancel();
    return super.close();
  }
}
