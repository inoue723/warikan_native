part of 'sign_in_bloc.dart';

abstract class SignInState extends Equatable {
  const SignInState();
}

class SignInInitial extends SignInState {
  @override
  List<Object> get props => [];
}

class SignInSubmitting extends SignInState {
  final String email;
  final String password;

  SignInSubmitting({this.email, this.password});

  @override
  List<Object> get props => [];
}

class SignInSubmitted extends SignInState {
  @override
  List<Object> get props => [];
}

class SignInError extends SignInState {
  @override
  List<Object> get props => [];
}
