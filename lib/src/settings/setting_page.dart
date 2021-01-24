import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warikan_native/src/common_widgets/platform_alert_dialog.dart';
import 'package:warikan_native/src/services/auth.dart';

class SettingPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: "確認",
      content: "ログアウトしますか？",
      cancelActionText: "いいえ",
      defaultActionText: "はい",
    ).show(context);

    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: Column(
          children: [
            Text(
              "設定",
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            SizedBox(height: 24),
            _createSettingList(context),
          ],
        ),
      ),
    );
  }

  Widget _createSettingList(BuildContext context) {
    return Container(
      child: Column(
        children: [
          GestureDetector(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.exit_to_app_rounded),
                SizedBox(width: 8),
                Text(
                  "ログアウト",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            onTap: () {
              _confirmSignOut(context);
            },
          )
        ],
      ),
    );
  }
}
