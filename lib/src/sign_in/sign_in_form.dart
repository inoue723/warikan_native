import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warikan_native/src/common_widgets/loading_button.dart';
import 'package:warikan_native/src/common_widgets/platfrom_exption_alert_dialog.dart';
import 'package:warikan_native/src/sign_in/bloc/sign_in_bloc.dart';
import 'package:warikan_native/src/sign_in/sign_in_button.dart';
import 'package:warikan_native/src/sign_in/sign_in_form_type.dart';

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  SignInFormType _formType;

  @override
  void initState() {
    super.initState();
    _formType = SignInFormType.signIn;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state is SignInError) {
          PlatformExceptionAlertDialog(
            title: "${_formType.submitButtonName}に失敗しました",
            exception: state.error,
          ).show(context);
        }
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildEmailTextField(state),
              _buildPasswordTextField(state),
              SizedBox(
                height: 16.0,
              ),
              _buildSignInButton(state),
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _formType = _formType.anotherType;
                  });
                },
                child: Text(
                  _formType.anotherType.submitButtonName,
                  style: TextStyle(
                    color: Colors.lightBlue,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _emailEditingComplete(SignInDefault state) {
    final newFocus = state.isValidEmail ? _passwordFocusNode : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  TextField _buildPasswordTextField(SignInState state) {
    final SignInDefault defaultState = state is SignInDefault ? state : null;
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: "password",
        errorText: defaultState?.passwordErrorText,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onChanged: (password) {
        context.read<SignInBloc>().add(
              SignInUpdate(
                email: _emailController.text,
                password: password,
              ),
            );
      },
    );
  }

  TextField _buildEmailTextField(SignInState state) {
    final SignInDefault defaultState = state is SignInDefault ? state : null;
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        labelText: "email",
        hintText: "email@example.com",
        errorText: defaultState?.emailErrorText,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: (email) {
        context.read<SignInBloc>().add(
              SignInUpdate(
                email: email,
                password: _passwordController.text,
              ),
            );
      },
      onEditingComplete: () => _emailEditingComplete(defaultState),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildSignInButton(SignInState state) {
    if (state is SignInSubmitting) {
      return LoadingButton();
    }
    return SignInButton(
      text: _formType.submitButtonName,
      color: Theme.of(context).primaryColor,
      onPressed: state.canSubmit
          ? () => context.read<SignInBloc>().add(
                SignInSubmit(
                  email: _emailController.text,
                  password: _passwordController.text,
                  formType: _formType,
                ),
              )
          : null,
      textColor: Colors.white,
    );
  }
}
