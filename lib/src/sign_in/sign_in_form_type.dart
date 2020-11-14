enum SignInFormType {
  register,
  signIn,
}

extension SignInFormTypeExtension on SignInFormType {
  String get submitButtonName {
    switch (this) {
      case SignInFormType.signIn:
        return "ログイン";
      case SignInFormType.register:
        return "新規登録";
      default:
        return "";
    }
  }

  SignInFormType get anotherType {
    switch (this) {
      case SignInFormType.signIn:
        return SignInFormType.register;
      case SignInFormType.register:
        return SignInFormType.signIn;
      default:
        return null;
    }
  }
}
