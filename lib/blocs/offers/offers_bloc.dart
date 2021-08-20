import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'offers_event.dart';
part 'offers_state.dart';

class OffersBloc extends Bloc<OffersEvent, OffersState> {
  OffersBloc() : super(OffersInitial());

  @override
  Stream<OffersState> mapEventToState(
    OffersEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
