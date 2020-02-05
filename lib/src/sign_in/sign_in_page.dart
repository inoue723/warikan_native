import 'package:flutter/material.dart';
import 'package:warikan_native/src/sign_in/sign_in_form_bloc_based.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      appBar: AppBar(
        title: Text("ログイン"),
        elevation: 2.0,
      ),
      body: _buildContainer(context),
      backgroundColor: Colors.grey[200],
    );
    return scaffold;
  }

  Widget _buildContainer(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 8.0),
          SingleChildScrollView(
            child: Card(
              child: SignInFormBlocBased.create(context),
            ),
          ),
        ],
      ),
    );
  }
}
