import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sail/models/SparkUser.dart';

part 'partner_event.dart';
part 'partner_state.dart';

class PartnerBloc extends Bloc<PartnerEvent, PartnerState> {
  PartnerBloc() : super(Unpaired()) {
    on<PartnerUpdated>((event, emit) {});
    on<FindPartner>((event, emit) {});
    on<LinkPartner>((event, emit) {});
  }
}
