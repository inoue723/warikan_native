import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:warikan_native/src/services/auth.dart';
import 'package:warikan_native/src/sign_in/bloc/sign_in_bloc.dart';
import 'package:warikan_native/src/sign_in/sign_in_form.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 30),
              _buildContainer(context),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
    return scaffold;
  }

  Widget _buildContainer(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(height: 8.0),
        SingleChildScrollView(
          child: BlocProvider<SignInBloc>(
            create: (context) => SignInBloc(auth: auth),
            child: SignInForm(),
          ),
        ),
      ],
    );
  }
}
