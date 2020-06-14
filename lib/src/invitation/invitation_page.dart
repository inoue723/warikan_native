import 'package:flutter/material.dart';

class InvitationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Center(child: Text("準備中"))),
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
