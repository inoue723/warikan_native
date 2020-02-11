import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:warikan_native/src/common_widgets/platform_alert_dialog.dart';
import 'package:warikan_native/src/common_widgets/platfrom_exption_alert_dialog.dart';
import 'package:warikan_native/src/home/models.dart';
import 'package:warikan_native/src/services/auth.dart';
import 'package:warikan_native/src/services/database.dart';

class CostsPage extends StatelessWidget {
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
      title: "ログアウト",
      content: "ログアウトしますか？",
      cancelActionText: "いいえ",
      defaultActionText: "はい",
    ).show(context);

    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  Future<void> _createCost(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    try {
      await database.createCost(Cost(
        amount: 1000,
        category: "test",
        // createdAt: DateTime.now(),
        // paymentDate: DateTime.now(),
      ));
    } on PlatformException catch (err) {
      PlatformExceptionAlertDialog(
        title: "Operation failed",
        exception: err,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ホーム"),
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
      body: _buildContents(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _createCost(context),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Cost>>(
      stream: database.costStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final costs = snapshot.data;
          final children = costs.map((cost) => Text(cost.category)).toList();
          return ListView(children: children);
        }
        if (snapshot.hasError) {
          return Center(child: Text("snapshot error"));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
