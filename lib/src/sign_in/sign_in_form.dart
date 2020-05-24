import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:warikan_native/src/common_widgets/platfrom_exption_alert_dialog.dart';
import 'package:warikan_native/src/services/auth.dart';
import 'package:warikan_native/src/sign_in/bloc/sign_in_bloc.dart';
import 'package:warikan_native/src/sign_in/sign_in_button.dart';
import 'package:warikan_native/src/sign_in/sign_in_model.dart';

class SignInForm extends StatefulWidget {
  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context);
    return BlocProvider<SignInBloc>(
      create: (context) => SignInBloc(auth: auth),
      child: SignInForm(),
    );
  }

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  Future<void> _submit() async {
    try {
      await widget.bloc.submit();
    } on PlatformException catch (error) {
      PlatformExceptionAlertDialog(
        title: "ログインに失敗しました",
        exception: error,
      ).show(context);
    }
  }

  void _emailEditingComplete(SignInModel model) {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  List<Widget> _buildChildren(SignInModel model) {
    return [
      _buildEmailTextField(model),
      _buildPasswordTextField(model),
      SizedBox(
        height: 16.0,
      ),
      SignInButton(
        text: "ログイン",
        color: Theme.of(context).primaryColor,
        onPressed: model.canSubmit ? _submit : null,
        textColor: Colors.white,
      ),
      SizedBox(height: 16.0),
      Text(
        "新規登録",
        style: TextStyle(
          color: Colors.lightBlue,
        ),
      ),
    ];
  }

  TextField _buildPasswordTextField(SignInModel model) {
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
      onChanged: widget.bloc.updatePassword,
      onEditingComplete: _submit,
    );
  }

  TextField _buildEmailTextField(SignInModel model) {
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        labelText: "email",
        hintText: "email@example.com",
        errorText: model.emailErrorText,
        enabled: !model.isLoading,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: widget.bloc.updateEmail,
      onEditingComplete: () => _emailEditingComplete(model),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SignInModel>(
      stream: widget.bloc.modelStream,
      initialData: SignInModel(),
      builder: (context, snapshot) {
        final SignInModel model = snapshot.data;
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: _buildChildren(model),
          ),
        );
      },
    );
  }
}
