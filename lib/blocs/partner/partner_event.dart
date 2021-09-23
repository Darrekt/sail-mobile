part of 'partner_bloc.dart';

abstract class PartnerEvent extends Equatable {
  final SparkUser partner = SparkUser.empty;
  const PartnerEvent();

  @override
  List<Object> get props => [];
}

class PartnerUpdated extends PartnerEvent {
  final SparkUser payload;
  PartnerUpdated(this.payload);

  @override
  List<Object> get props => [payload.id];

  @override
  String toString() => "PartnerUpdated { partner: $payload }";
}

class FindPartner extends PartnerEvent {
  final String email;
  FindPartner(this.email);

  @override
  List<Object> get props => [email];

  @override
  String toString() => "TryFindPartner { email: $email }";
}

class LinkPartner extends PartnerEvent {
  final String email, otp;
  LinkPartner(this.email, this.otp);

  @override
  List<Object> get props => [email, otp];

  @override
  String toString() => "TryLinkPartner { email: $email, otp: $otp }";
}
