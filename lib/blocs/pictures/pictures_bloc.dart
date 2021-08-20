import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'pictures_event.dart';
part 'pictures_state.dart';

class PicturesBloc extends Bloc<PicturesEvent, PicturesState> {
  PicturesBloc() : super(PicturesInitial());

  @override
  Stream<PicturesState> mapEventToState(
    PicturesEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
