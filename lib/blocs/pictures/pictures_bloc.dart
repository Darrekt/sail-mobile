import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sail/blocs/auth/auth_bloc.dart';
import 'package:sail/repositories/auth/auth_repository.dart';
import 'package:sail/repositories/pictures/pictures_repository.dart';

part 'pictures_event.dart';
part 'pictures_state.dart';

class PicturesBloc extends Bloc<PicturesEvent, PicturesState> {
  final AuthBloc _authBloc;
  final PicturesRepository _picturesRepository;

  PicturesBloc(
      {required AuthBloc auth, required PicturesRepository picturesRepository})
      : _authBloc = auth,
        _picturesRepository = picturesRepository,
        super(PicturesIdle("")) {
    on<FetchProfilePictureURI>((event, emit) {
      final AuthState authState = _authBloc.state;
      if (authState is Authenticated) {
        emit(PicturesIdle(authState.user.photo ?? ""));
      }
    });

    on<UploadProfilePicture>((event, emit) async {
      emit(PicturesFetching());
      final AuthState authState = _authBloc.state;
      if (authState is Authenticated) {
        String resourceLocation = await _picturesRepository
            .uploadProfilePicture(authState.user, event.payload);
        _authBloc.add(UpdateProfilePictureURI(resourceLocation));
      }
    });

    on<ClearProfilePicture>((event, emit) {
      final AuthState authState = _authBloc.state;
      if (authState is Authenticated) {
        try {
          _picturesRepository.clearProfilePicture(authState.user);
        } catch (e) {}
        _authBloc.add(UpdateProfilePictureURI(null));
      } else {
        throw UserNotLoggedInException();
      }
    });
  }
}
