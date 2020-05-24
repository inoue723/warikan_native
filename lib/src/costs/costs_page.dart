import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:warikan_native/src/common_widgets/platform_alert_dialog.dart';
import 'package:warikan_native/src/costs/bloc/index.dart';
import 'package:warikan_native/src/costs/costs_list.dart';
import 'package:warikan_native/src/costs/edit_cost_page.dart';
import 'package:warikan_native/src/services/auth.dart';

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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(30),
        child: AppBar(
          backgroundColor: Colors.white10,
          elevation: 0,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              color: Colors.black,
              onPressed: () => _confirmSignOut(context),
            )
          ],
        ),
      ),
      body: _buildContents(context),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () => EditCostPage.show(context, cost: null),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    return BlocBuilder<CostsBloc, CostsState>(
      builder: (context, state) {
        if (state is CostsLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (state is CostsLoaded) {
          return CostsListContent(model: state.costs);
        }

        return Container();
      },
    );
  }
}
