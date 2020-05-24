import 'package:warikan_native/src/sign_in/validators.dart';

enum SignInFormType {
  signIn,
  register,
}

class SignInModel with EmailAndPasswordValidators {
  SignInModel({
    this.email = "",
    this.password = "",
    this.isLoading = false,
    this.submitted = false,
    this.formType = SignInFormType.signIn,
  });
  final String email;
  final String password;
  final bool isLoading;
  final bool submitted;
  final SignInFormType formType;

  String get primaryButtonText {
    return formType == SignInFormType.signIn ? 'ログイン' : '登録';
  }

  String get secondaryButtonText {
    return formType == SignInFormType.signIn ? '新規登録はこちら' : 'ログインはこちら';
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

  SignInModel copyWith({
    String email,
    String password,
    bool isLoading,
    bool submitted,
  }) {
    return SignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted,
      formType: formType ?? this.formType,
    );
  }
}
