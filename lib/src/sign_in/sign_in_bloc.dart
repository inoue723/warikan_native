import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:warikan_native/src/services/auth.dart';
import 'package:warikan_native/src/sign_in/sign_in_model.dart';

class SignInBloc {
  SignInBloc({ @required this.auth});
  final AuthBase auth;
  final StreamController<SignInModel> _modelController = StreamController<SignInModel>();

  Stream<SignInModel> get modelStream => _modelController.stream;
  SignInModel _model = SignInModel();

  void dispose() {
    _modelController.close();
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
}