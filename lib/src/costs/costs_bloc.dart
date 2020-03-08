import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:warikan_native/src/costs/costs_list.dart';
import 'package:warikan_native/src/home/models.dart';
import 'package:warikan_native/src/services/database.dart';

class CostsBloc {
  CostsBloc({@required this.database});
  final Database database;

  Stream<List<List<Cost>>> get _totalCostsStream => CombineLatestStream([
        database.myCostsStream(),
        database.partnerCostsStream(),
      ], _costCombiner);

  List<List<Cost>> _costCombiner(List<List<Cost>> values) {
    final myCosts = values[0];
    final partnerCosts = values[1];
    return [myCosts, partnerCosts];
  }

  Stream<CostsSummaryTileModel> get costsSummaryTileModelStream =>
      _totalCostsStream.map(_createModels);

  CostsSummaryTileModel _createModels(List<List<Cost>> costsList) {
    final myCosts = costsList[0];
    final partnerCosts = costsList[1];
    final flattenCosts = costsList
      .expand((cost) => cost)
      .toList();

    flattenCosts.sort((current, next) => next.paymentDate.compareTo(current.paymentDate));

    final totalCostAmount = flattenCosts
        .map((cost) => cost.amount)
        .reduce((value, element) => value + element);

    final myTotalCostAmount = myCosts
        .map((cost) => cost.amount)
        .reduce((value, element) => value + element);

    final partnerTotalCostAmount = partnerCosts
        .map((cost) => cost.amount)
        .reduce((value, element) => value + element);

    return CostsSummaryTileModel(
      costs: flattenCosts,
      totalCostAmount: totalCostAmount,
      myTotalCostAmount: myTotalCostAmount,
      partnerTotalCostAmount: partnerTotalCostAmount,
      differenceAmount: myTotalCostAmount - partnerTotalCostAmount,
    );
  }
}
