import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:warikan_native/src/common_widgets/platform_alert_dialog.dart';
import 'package:warikan_native/src/common_widgets/platfrom_exption_alert_dialog.dart';
import 'package:warikan_native/src/costs/costs_list.dart';
import 'package:warikan_native/src/costs/list_items_builder.dart';
import 'package:warikan_native/src/costs/edit_cost_page.dart';
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
        onPressed: () => EditCostPage.show(context, cost: null),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Cost>>(
      stream: database.costStream(),
      builder: (context, snapshot) {
        return ListItemBuilder(
          snapshot: snapshot,
          itemBuilder: (context, cost) => Dismissible(
            key: Key("cost-${cost.id}"),
            background: Container(
              color: Colors.red,
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, cost),
            child: CostsListTile(
              cost: cost,
              onTap: () => EditCostPage.show(
                context,
                cost: cost,
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _delete(BuildContext context, Cost cost) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteCost(cost);
    } on PlatformException catch (err) {
      PlatformExceptionAlertDialog(
        title: "削除に失敗しました",
        exception: err, 
      );
    }
  }
}
