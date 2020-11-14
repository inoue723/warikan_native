import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/invitation_bloc.dart';

class InvitationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: BlocBuilder<InvitationBloc, InvitationState>(
            builder: (context, state) {
              if (state is InvitationNotInvited) {
                return _buildInvitationContainer();
              }
              return Text("すでに相手がいます");
            },
          ),
        ),
      ),
      bottomNavigationBar: Builder(
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.close),
                iconSize: 46.0,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(height: 30),
            ],
          );
        },
      ),
    );
  }
}

// TODO build form to submit email address
Widget _buildInvitationContainer() {
  return Column(
    children: [
      Text("相手のメールアドレスを入力してください"),
      TextFormField(
        decoration: InputDecoration(labelText: "メールアドレス"),
        keyboardType: TextInputType.emailAddress,
        validator: (value) => value.isNotEmpty ? null : "メールアドレスを入力してください",
      ),
    ],
    mainAxisAlignment: MainAxisAlignment.center,
  );
}
