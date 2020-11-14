part of 'sign_in_bloc.dart';

abstract class SignInState extends Equatable {
  bool get canSubmit;
  const SignInState();
}

class SignInDefault extends SignInState with EmailAndPasswordValidators {
  final String email;
  final String password;

  @override
  bool get canSubmit => isValidEmail && isValidPassword;

  bool get isValidEmail => emailValidator.isValid(email);
  bool get isValidPassword => emailValidator.isValid(password);
  String get emailErrorText => isValidEmail ? null : invalidEmailErrorText;
  String get passwordErrorText =>
      isValidPassword ? null : invalidPasswordErrorText;

  SignInDefault({
    this.email = "",
    this.password = "",
  });

  @override
  List<Object> get props => [email, password];
}

class SignInSubmitting extends SignInState {
  bool get canSubmit => false;

  @override
  List<Object> get props => [];
}

class SignInSubmitted extends SignInState {
  @override
  List<Object> get props => [];

  @override
  bool get canSubmit => false;
}

class SignInError extends SignInState {
  final Exception error;

  SignInError(this.error);

  @override
  List<Object> get props => [error];

  @override
  bool get canSubmit => false;
}
