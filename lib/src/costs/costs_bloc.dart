import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:warikan_native/src/costs/costs_list.dart';
import 'package:warikan_native/src/home/models.dart';
import 'package:warikan_native/src/services/database.dart';

class CostsBloc {
  CostsBloc({@required this.database});
  final Database database;

  Stream<List<Cost>> get _totalCostsStream => CombineLatestStream([
      database.myCostsStream(),
      database.partnerCostsStream(),
    ], _costCombiner);

  List<Cost> _costCombiner(List<List<Cost>> values) {
    values[0].addAll(values[1]);
    return values[0];
  }

  Stream<CostsSummaryTileModel> get costsSummaryTileModelStream =>
    _totalCostsStream.map(_createModels);

  CostsSummaryTileModel _createModels(List<Cost> costs) {
    if (costs.isEmpty) {
      return null;
    }

    final totalCostAmount = 100;
    final myTotalCostAmount = 10;
    final partnerTotalCostAmount = 10;

    return CostsSummaryTileModel(costs: costs, totalCostAmount: totalCostAmount, myTotalCostAmount: myTotalCostAmount, partnerTotalCostAmount: partnerTotalCostAmount,);
  }
}