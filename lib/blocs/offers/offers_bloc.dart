import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sail/blocs/auth/auth_bloc.dart';

part 'offers_event.dart';
part 'offers_state.dart';

class OffersBloc extends Bloc<OffersEvent, OffersState> {
  final AuthBloc _authBloc;

  OffersBloc({required AuthBloc auth})
      : _authBloc = auth,
        super(OffersInitial());
}
