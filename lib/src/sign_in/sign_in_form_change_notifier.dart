import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:warikan_native/src/common_widgets/platfrom_exption_alert_dialog.dart';
import 'package:warikan_native/src/services/auth.dart';
import 'package:warikan_native/src/sign_in/sign_in_button.dart';
import 'package:warikan_native/src/sign_in/sign_in_change_model.dart';

class SignInFormChangeNotifier extends StatefulWidget {
  SignInFormChangeNotifier({@required this.model});
  final SignInChangeModel model;

  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<SignInChangeModel>(
      create: (context) => SignInChangeModel(auth: auth),
      child: Consumer<SignInChangeModel>(
        builder: (context, model, _) => SignInFormChangeNotifier(model: model),
      ),
    );
  }

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInFormChangeNotifier> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  SignInChangeModel get model => widget.model;

  Future<void> _submit() async {
    try {
      await model.submit();
    } on PlatformException catch (error) {
      PlatformExceptionAlertDialog(
        title: "ログインに失敗しました",
        exception: error,
      ).show(context);
    }
  }

  void _emailEditingComplete() {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  List<Widget> _buildChildren() {
    return [
      _buildEmailTextField(),
      _buildPasswordTextField(),
      SizedBox(
        height: 16.0,
      ),
      SignInButton(
        text: "ログイン",
        color: Colors.brown,
        onPressed: model.canSubmit ? _submit : null,
        textColor: Colors.white,
      )
    ];
  }

  TextField _buildPasswordTextField() {
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: "password",
        errorText: model.passwordErrorText,
        enabled: !model.isLoading,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onChanged: model.updatePassword,
      onEditingComplete: _submit,
    );
  }

  TextField _buildEmailTextField() {
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
          labelText: "email",
          hintText: "email@example.com",
          errorText: model.emailErrorText,
          enabled: !model.isLoading),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: model.updateEmail,
      onEditingComplete: () => _emailEditingComplete(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: _buildChildren(),
      ),
    );
  }
}
