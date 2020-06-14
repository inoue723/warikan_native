import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warikan_native/src/services/database.dart';

part 'invitation_event.dart';
part 'invitation_state.dart';

class InvitationBloc extends Bloc<InvitationEvent, InvitationState> {
  final Database database;

  InvitationBloc(this.database);

  @override
  InvitationState get initialState => InvitationInitial();

  @override
  Stream<InvitationState> mapEventToState(
    InvitationEvent event,
  ) async* {
    if (event is InvitationInit) {
      final user = await database.getMyUserInfo();
      if (user.partnerId == null) {
        yield InvitationNotInvited();
      } else {
        yield InvitationInvited(user.partnerId);
      }
    }
  }
}
