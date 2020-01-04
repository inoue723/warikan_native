import 'package:flutter/material.dart';
import 'package:warikan_native/src/services/auth.dart';
import 'package:warikan_native/src/sign_in/sign_in_form.dart';

class SignInPage extends StatelessWidget {
  SignInPage({@required this.auth});
  final AuthBase auth;

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      appBar: AppBar(
        title: Text("ログイン"),
        elevation: 2.0,
      ),
      body: _buildContainer(),
      backgroundColor: Colors.grey[200],
    );
    return scaffold;
  }

  Widget _buildContainer() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 8.0),
          SingleChildScrollView(
            child: Card(
              child: SignInForm(auth: auth),
            ),
          ),
        ],
      ),
    );
  }
}
