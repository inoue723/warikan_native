part of 'sign_in_bloc.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();
}

class SignInSubmit extends SignInEvent {
  final String email;
  final String password;

  SignInSubmit({@required this.email, @required this.password});

  @override
  List<Object> get props => [];
}
