import 'package:flutter/material.dart';
import 'package:warikan_native/src/common_widgets/platform_alert_dialog.dart';
import 'package:warikan_native/src/services/auth.dart';

class HomePage extends StatelessWidget {
  HomePage({@required this.auth});
  final AuthBase auth;

  Future<void> _signOut() async {
    try {
      await auth.signOut();
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: "ログアウト",
      content: "ログアウトしますか？",
      cancelActionText: "いいえ",
      defaultActionText: "はい",
    ).show(context);

    if (didRequestSignOut == true) {
      _signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("home"),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "logout",
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
            onPressed: () => _confirmSignOut(context),
          )
        ],
      ),
    );
  }
}
