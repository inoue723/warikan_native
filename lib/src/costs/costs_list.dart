import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warikan_native/src/costs/edit_cost_page.dart';
import 'package:warikan_native/src/home/models.dart';
import 'package:warikan_native/src/services/database.dart';
import 'package:warikan_native/src/common_widgets/platfrom_exption_alert_dialog.dart';
import 'package:flutter/services.dart';

class CostsSummaryTileModel {
  CostsSummaryTileModel({
    @required this.totalCostAmount,
    @required this.myTotalCostAmount,
    @required this.partnerTotalCostAmount,
    @required this.costs,
    @required this.borrowAmount,
  });
  final int totalCostAmount;
  final int myTotalCostAmount;
  final int partnerTotalCostAmount;
  final int borrowAmount;
  final List<Cost> costs;
}

class CostsListContent extends StatelessWidget {
  const CostsListContent({Key key, @required this.model}) : super(key: key);
  final CostsSummaryTileModel model;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      Column(
        children: <Widget>[
          RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.grey, fontSize: 14),
              children: [
                TextSpan(
                  text: model.borrowAmount < 0 ? "貸してる" : "借りてる",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black54,
                  ),
                ),
                TextSpan(
                  text: "金額",
                )
              ],
            ),
          ),
          _buildLendOrBorrowAmountText(),
        ],
      )
    ];

    List<Dismissible> costList = List.generate(model.costs.length, (index) {
      final cost = model.costs[index];
      return Dismissible(
        key: Key("cost-${cost.id}"),
        background: Container(
          color: Colors.red,
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) => _delete(context, cost),
        child: ListTile(
          title: Text("${cost.amount}円"),
          subtitle: Text(cost.category),
          trailing: Icon(Icons.chevron_right),
          onTap: () => EditCostPage.show(
            context,
            cost: cost,
          ),
        ),
      );
    });

    children.addAll(costList);

    return ListView(children: children);
  }

  RichText _buildLendOrBorrowAmountText() {
    final amount = model.borrowAmount.isNegative
        ? model.borrowAmount * -1
        : model.borrowAmount;
    final color = model.borrowAmount.isNegative ? Colors.green : Colors.red;
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "$amount",
            style: TextStyle(fontSize: 20, color: color),
          ),
          TextSpan(
            text: "円",
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
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
