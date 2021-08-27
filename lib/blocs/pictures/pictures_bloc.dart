import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spark/blocs/auth/auth_bloc.dart';
import 'package:spark/repositories/auth/auth_repository.dart';
import 'package:spark/repositories/pictures/pictures_repository.dart';

part 'pictures_event.dart';
part 'pictures_state.dart';

class PicturesBloc extends Bloc<PicturesEvent, PicturesState> {
  final AuthBloc _authBloc;
  final PicturesRepository _picturesRepository;

  PicturesBloc(
      {required AuthBloc auth, required PicturesRepository picturesRepository})
      : _authBloc = auth,
        _picturesRepository = picturesRepository,
        super(PicturesIdle(""));

  @override
  Stream<PicturesState> mapEventToState(
    PicturesEvent event,
  ) async* {
    if (event is FetchProfilePictureURI) {
      yield* mapFetchProfilePictureURIToState(event);
    } else if (event is UploadProfilePicture) {
      yield* mapUploadProfilePictureToState(event);
    } else if (event is ClearProfilePicture) {
      yield* mapClearProfilePictureToState();
    }
  }

  Stream<PicturesState> mapFetchProfilePictureURIToState(
      FetchProfilePictureURI event) async* {
    final AuthState authState = _authBloc.state;
    if (authState is Authenticated) {
      yield PicturesIdle(authState.user.photo ?? "");
    }
  }

  Stream<PicturesState> mapUploadProfilePictureToState(
      UploadProfilePicture event) async* {
    yield PicturesFetching();

    final AuthState authState = _authBloc.state;
    if (authState is Authenticated) {
      String resourceLocation = await _picturesRepository.uploadProfilePicture(
          authState.user, event.payload);
      _authBloc.add(UpdateProfilePictureURI(resourceLocation));
    }
  }

  Stream<PicturesState> mapClearProfilePictureToState() async* {
    final AuthState authState = _authBloc.state;
    if (authState is Authenticated) {
      try {
        _picturesRepository.clearProfilePicture(authState.user);
      } catch (e) {}
      _authBloc.add(UpdateProfilePictureURI(null));
    } else {
      throw UserNotLoggedInException();
    }
  }
}
