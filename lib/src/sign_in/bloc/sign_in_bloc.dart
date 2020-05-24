import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warikan_native/src/services/auth.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthBase auth;

  SignInBloc({@required this.auth});

  @override
  SignInState get initialState => SignInInitial();

  @override
  Stream<SignInState> mapEventToState(SignInEvent event) async* {
    if (event is SignInSubmit) {
      yield* _mapSubmitEventToState(event);
    }
  }

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      await auth.signInWithEmailAndPassword(
        email: _model.email,
        password: _model.password,
      );
    } catch (error) {
      rethrow;
    } finally {
      updateWith(isLoading: false);
    }
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void updateWith({
    String email,
    String password,
    bool isLoading,
    bool submitted,
  }) {
    _model = _model.copyWith(
      email: email,
      password: password,
      isLoading: isLoading,
      submitted: submitted,
    );

    _modelController.add(_model);
  }

  Stream<SignInState> _mapSubmitEventToState(SignInSubmit event) async* {
    updateWith(submitted: true, isLoading: true);
    try {
      await auth.signInWithEmailAndPassword(
        email: _model.email,
        password: _model.password,
      );
    } catch (error) {
      rethrow;
    }
  }
}
