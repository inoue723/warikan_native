import 'package:flutter/material.dart';
import 'package:warikan_native/src/services/auth.dart';
import 'package:warikan_native/src/sign_in/validators.dart';

class SignInChangeModel with EmailAndPasswordValidators, ChangeNotifier {
  SignInChangeModel({
    @required this.auth,
    this.email = "",
    this.password = "",
    this.isLoading = false,
    this.submitted = false,
  });
  final AuthBase auth;
  String email;
  String password;
  bool isLoading;
  bool submitted;

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      await auth.signInWithEmailAndPassword(
        email: this.email,
        password: this.password,
      );
    } catch (error) {
      rethrow;
    } finally {
      updateWith(isLoading: false);
    }
  }

  String get passwordErrorText {
    bool showErrorText = submitted && !passwordValidator.isValid(password);
    return showErrorText ? invalidPasswordErrorText : null;
  }

  String get emailErrorText {
    bool showErrorText = submitted && !emailValidator.isValid(email);
    return showErrorText ? invalidEmailErrorText : null;
  }

  bool get canSubmit {
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        !isLoading;
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  SignInChangeModel updateWith({
    String email,
    String password,
    bool isLoading,
    bool submitted,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }
}
