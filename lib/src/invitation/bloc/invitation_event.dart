part of 'invitation_bloc.dart';

abstract class InvitationEvent extends Equatable {
  const InvitationEvent();
}

class InvitationInit extends InvitationEvent {
  InvitationInit();

  @override
  List<Object> get props => [];
}
