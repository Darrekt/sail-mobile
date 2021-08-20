import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spark/blocs/auth/auth_barrel.dart';
import 'package:spark/blocs/auth/auth_states.dart';
import 'package:spark/repositories/settings/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _auth;
  StreamSubscription<User?>? _userSubscription;

  AuthBloc({required AuthRepository auth})
      : _auth = auth,
        super(Unauthenticated());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is AuthStateUpdated) {
      yield* _mapAuthStateUpdatedToState(event);
    } else if (event is TryEmailSignIn) {
      yield* _mapTryEmailSignInToState(event);
    } else if (event is TryFacebookSignIn) {
      yield* _mapTryFacebookSignInToState();
    } else if (event is TryGoogleSignIn) {
      yield* _mapTryGoogleSignInToState();
    } else if (event is TryAppleSignIn) {
      yield* _mapTryAppleSignInToState();
    } else if (event is Logout) {
      yield* _mapLogOutToState();
    }
  }

  Stream<AuthState> _mapAppStartedToState() async* {
    if (_userSubscription != null) _userSubscription!.cancel();
    _userSubscription =
        _auth.getUser().listen((update) => add(AuthStateUpdated(update)));
    yield Unauthenticated();
  }

  Stream<AuthState> _mapAuthStateUpdatedToState(AuthStateUpdated event) async* {
    final User? user = event.payload;
    yield user == null ? Unauthenticated() : Authenticated(user);
    // : event.user.displayName == null || event.user.email == null
    //     ? Onboarding(event.user)
    //     : Authenticated(event.user);
  }

  Stream<AuthState> _mapTryEmailSignInToState(TryEmailSignIn event) async* {
    if (state is Unauthenticated) {
      try {
        await _auth.authenticateEmail(event.email, event.password);
      } catch (e) {}
    } else if (state is Authenticated) {
      await _auth.linkEmail(event.email, event.password);
    }
  }

  Stream<AuthState> _mapTryFacebookSignInToState() async* {
    await _auth.authenticateFacebook();
  }

  Stream<AuthState> _mapTryGoogleSignInToState() async* {
    await _auth.authenticateGoogle();
  }

  Stream<AuthState> _mapTryAppleSignInToState() async* {
    await _auth.authenticateApple();
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
