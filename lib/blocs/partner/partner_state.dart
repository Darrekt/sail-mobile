part of 'partner_bloc.dart';

abstract class PartnerState extends Equatable {
  const PartnerState();

  @override
  List<Object> get props => [];
}

class Unpaired extends PartnerState {}

class PairingInProgress extends Unpaired {
  final String partnerEmail;
  PairingInProgress(this.partnerEmail);

  @override
  List<Object> get props => [partnerEmail];

  @override
  String toString() => "PairingInProgress { partnerEmail: $partnerEmail }";
}

class PairingFailed extends PartnerState {
  final String reason;
  PairingFailed(this.reason);

  @override
  List<Object> get props => [reason];

  @override
  String toString() => "PairingFailed { reason: $reason }";
}

class Paired extends PartnerState {
  final SparkUser partner;
  Paired(this.partner);

  @override
  List<Object> get props => [partner.id];

  @override
  String toString() => "Paired { partner: $partner }";
}
