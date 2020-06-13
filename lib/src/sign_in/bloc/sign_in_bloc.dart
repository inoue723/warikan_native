import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warikan_native/src/services/auth.dart';
import 'package:warikan_native/src/sign_in/sign_in_form_type.dart';
import 'package:warikan_native/src/sign_in/validators.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthBase auth;

  SignInBloc({@required this.auth});

  @override
  SignInState get initialState => SignInDefault();

  @override
  Stream<SignInState> mapEventToState(SignInEvent event) async* {
    if (event is SignInSubmit) {
      yield* _mapSubmitEventToState(event);
    }

    if (event is SignInUpdate) {
      yield* _mapUpdateEventToState(event);
    }
  }

  Stream<SignInState> _mapSubmitEventToState(SignInSubmit event) async* {
    try {
      if (state is SignInDefault &&
          (state as SignInDefault).isValidEmail &&
          (state as SignInDefault).isValidEmail) {
        yield SignInSubmitting();

        if (event.formType == SignInFormType.signIn) {
          await auth.signInWithEmailAndPassword(
            email: event.email,
            password: event.password,
          );
        } else {
          await auth.createUserWithEmailAndPassword(
            event.email,
            event.password,
          );
        }
        yield SignInSubmitted();
      }
    } on PlatformException catch (error) {
      yield SignInError(error);
    }
  }

  Stream<SignInState> _mapUpdateEventToState(SignInUpdate event) async* {
    yield SignInDefault(
      email: event.email,
      password: event.password,
    );
  }
}
