import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warikan_native/src/common_widgets/platform_alert_dialog.dart';
import 'package:warikan_native/src/costs/container_builder.dart';
import 'package:warikan_native/src/costs/costs_bloc.dart';
import 'package:warikan_native/src/costs/costs_list.dart';
import 'package:warikan_native/src/costs/edit_cost_page.dart';
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
    final bloc = CostsBloc(database: database);
    return StreamBuilder<CostsSummaryTileModel>(
      stream: bloc.costsSummaryTileModelStream,
      builder: (context, snapshot) {
        print(snapshot);
        return ContainerBuilder(
          snapshot: snapshot,
          itemBuilder: (context, model) => CostsListContent(model: model),
        );
      },
    );
  }
}
