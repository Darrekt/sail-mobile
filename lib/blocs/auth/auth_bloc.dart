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
  StreamSubscription<SparkUser>? _partnerSubscription;

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
    } else if (event is PartnerUpdated) {
      yield* _mapPartnerUpdatedToState(event);
    } else if (event is TryFindPartner) {
      yield* _mapTryFindPartnerToState(event);
    } else if (event is TryLinkPartner) {
      yield* _mapTryLinkPartnerToState(event);
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
    SparkUser user = event.payload;
    if (user == SparkUser.empty)
      yield Unauthenticated();
    else {
      // if (_partnerSubscription != null) _partnerSubscription!.cancel();
      // _partnerSubscription =
      //     _auth.getPartner(user).listen((event) => add(PartnerUpdated(event)));
      yield Authenticated(user);
    }
  }

  Stream<AuthState> _mapTryEmailSignUpToState(TryEmailSignUp event) async* {
    if (state is Unauthenticated) {
      try {
        await _auth.signUpEmail(event.email, event.password);
      } catch (e) {
        showErrorToast("Failed to sign up user");
      }
    }
    throw NotImplementedException();
  }

  Stream<AuthState> _mapTryEmailSignInToState(TryEmailSignIn event) async* {
    if (state is Unauthenticated) {
      try {
        await _auth.authenticateEmail(event.email, event.password);
      } on LogInWithEmailFailure catch (e) {
        // TODO: Make prettyPrintFirebaseAuthException to translate these
        showErrorToast(e.code);
      } catch (e) {
        showErrorToast("An unknown error occurred.");
      }
    } else if (state is Authenticated) {
      await _auth.linkEmail(event.email, event.password);
    }
  }

  Stream<AuthState> _mapTryFacebookSignInToState() async* {
    try {
      await _auth.authenticateFacebook();
    } catch (e) {
      showErrorToast(e.toString());
    }
  }

  Stream<AuthState> _mapTryGoogleSignInToState() async* {
    try {
      await _auth.authenticateGoogle();
    } catch (e) {
      showErrorToast(e.toString());
    }
  }

  Stream<AuthState> _mapTryAppleSignInToState() async* {
    try {
      await _auth.authenticateApple();
    } catch (e) {
      showErrorToast(e.toString());
    }
  }

  Stream<AuthState> _mapPartnerUpdatedToState(PartnerUpdated event) async* {
    final SparkUser partner = event.payload;
    AuthState currentState = state;

    if (partner != SparkUser.empty && currentState is Authenticated)
      yield Paired(currentState.user, partner);
  }

  Stream<AuthState> _mapTryFindPartnerToState(TryFindPartner event) async* {
    if (state is Authenticated) {
      _auth.findPartnerByEmail(event.email);
    } else
      throw UserNotLoggedInException();
  }

  // Stream<AuthState> _mapSetupPairingToState(SetupPairing event) async* {
  //   if (state is PairingInProgress) _auth.setupPairing(event.email);
  // }

  Stream<AuthState> _mapTryLinkPartnerToState(TryLinkPartner event) async* {
    if (state is PairingInProgress) _auth.tryPairingOTP(event.email, event.otp);
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
    if (_partnerSubscription != null) _partnerSubscription!.cancel();
    return super.close();
  }
}
