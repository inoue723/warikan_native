part of 'invitation_bloc.dart';

abstract class InvitationState extends Equatable {
  const InvitationState();
}

class InvitationInitial extends InvitationState {
  @override
  List<Object> get props => [];
}

class InvitationInvited extends InvitationState {
  final String partnerId;

  InvitationInvited(this.partnerId);

  @override
  List<Object> get props => [];
}

class InvitationNotInvited extends InvitationState {
  @override
  List<Object> get props => [];
}
