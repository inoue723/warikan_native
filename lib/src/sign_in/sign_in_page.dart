import 'package:flutter/material.dart';
import 'package:warikan_native/src/services/auth.dart';
import 'package:warikan_native/src/sign_in/sign_in_button.dart';

class SignInPage extends StatelessWidget {
  SignInPage({@required this.auth, @required this.onSignIn});
  final Function(User) onSignIn;
  final AuthBase auth;

  Future<void> _signInWithEmailAndPassword() async {
    try {
      User user = await auth.signInWithEmailAndPassword(
        email: 'warikan-app2@warikan.test',
        password: 'inoue123',
      );
      onSignIn(user);
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      appBar: AppBar(
        title: Text("warikan"),
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            "Sign in",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 100.0),
          SignInButton(
            text: "Sign In With Email",
            color: Colors.white,
            textColor: Colors.black,
            onPressed: _signInWithEmailAndPassword,
          ),
          SizedBox(height: 8.0),
        ],
      ),
    );
  }
}

void _signInWithEmail() {
  // TODO: sign in with email
}
