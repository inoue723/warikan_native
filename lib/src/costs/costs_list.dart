import 'package:flutter/material.dart';
import 'package:warikan_native/src/home/models.dart';

class CostsSummaryTileModel {
  CostsSummaryTileModel({@required this.totalCostAmount, @required this.myTotalCostAmount, @required this.partnerTotalCostAmount, @required this.costs});
  final int totalCostAmount;
  final int myTotalCostAmount;
  final int partnerTotalCostAmount;
  final List<Cost> costs;
}

class CostsListContent extends StatelessWidget {
  const CostsListContent({Key key, @required this.model})
      : super(key: key);
  final CostsSummaryTileModel model;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      Card(child: Text("total cost ${model.totalCostAmount}")),
      Card(child: Text("myTotalCostAmount ${model.myTotalCostAmount}")),
      Card(child: Text("partnerTotalCostAmount cost ${model.partnerTotalCostAmount}")),
    ];

    List<ListTile> costList = List.generate(model.costs.length, (index) {
      final cost = model.costs[index];
      return ListTile(
        title: Text("${cost.amount}円"),
        subtitle: Text(cost.category),
        trailing: Icon(Icons.chevron_right),
        onTap: () {},
      );
    });

    children.addAll(costList);

    return Column(
      children: children
    );
  }
}
