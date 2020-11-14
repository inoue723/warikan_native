import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:warikan_native/src/costs/bloc/costs_event.dart';
import 'package:warikan_native/src/costs/bloc/costs_state.dart';
import 'package:warikan_native/src/models/burden_rate.dart';
import 'package:warikan_native/src/models/cost.dart';
import 'package:warikan_native/src/models/cost_summary.dart';
import 'package:warikan_native/src/services/database.dart';

class CostsBloc extends Bloc<CostsEvent, CostsState> {
  final Database database;
  final String partnerId;

  CostsBloc({@required this.database, @required this.partnerId})
      : super(CostsLoading());
  StreamSubscription _subscription;

  @override
  Stream<CostsState> mapEventToState(CostsEvent event) async* {
    if (event is LoadCosts) {
      yield* _mapLoadCostsToState();
    } else if (event is CostsUpdated) {
      yield CostsLoaded(event.costs);
    }
  }

  Stream<CostsState> _mapLoadCostsToState() async* {
    _subscription?.cancel();
    _subscription = _totalCostsStream(partnerId)
        .listen((costs) => add(CostsUpdated(costs)));
  }

  Stream<CostsSummary> _totalCostsStream(String partnerId) =>
      CombineLatestStream([
        database.myCostsStream(),
        database.costsStream(partnerId),
      ], _costCombiner)
          .map(_createModels);

  List<List<Cost>> _costCombiner(List<List<Cost>> values) {
    final myCosts = values[0];
    final partnerCosts = values[1];
    return [myCosts, partnerCosts];
  }

  CostsSummary _createModels(List<List<Cost>> costsList) {
    final myCosts = costsList[0];
    final partnerCosts = costsList[1];
    final flattenCosts = costsList.expand((cost) => cost).toList();

    flattenCosts.sort(
      (current, next) => next.paymentDate.compareTo(current.paymentDate),
    );

    final totalCostAmount = flattenCosts.isNotEmpty
        ? flattenCosts
            .map((cost) => cost.amount)
            .reduce((value, element) => value + element)
        : 0;

    double borrowAmount = 0;
    myCosts.forEach((myCost) {
      borrowAmount -= myCost.amount *
          (myCost.burdenRate?.partnerRate ?? BurdenRate.evenRate);
    });
    partnerCosts.forEach((partnerCost) {
      borrowAmount += partnerCost.amount *
          (partnerCost.burdenRate?.partnerRate ?? BurdenRate.evenRate);
    });

    return CostsSummary(
      costs: flattenCosts,
      totalCostAmount: totalCostAmount,
      borrowAmount: borrowAmount.round(),
    );
  }
}
