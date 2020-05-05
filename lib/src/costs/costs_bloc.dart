import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:warikan_native/src/costs/costs_list.dart';
import 'package:warikan_native/src/costs/models/burden_rate.dart';
import 'package:warikan_native/src/home/models.dart';
import 'package:warikan_native/src/services/database.dart';
import 'package:warikan_native/src/services/models/user.dart';

abstract class CostsState extends Equatable {
  const CostsState();

  @override
  List<Object> get props => [];
}

class CostsLoading extends CostsState {}

class CostsLoaded extends CostsState {
  final costs;

  CostsLoaded(this.costs);

  @override
  List<Object> get props => [costs];
}

abstract class CostsEvent extends Equatable {
  const CostsEvent();

  @override
  List<Object> get props => [];
}

class LoadCosts extends CostsEvent {}

class CostsUpdated extends CostsEvent {
  final CostsSummaryTileModel costs;

  CostsUpdated(this.costs);

  @override
  List<Object> get props => [costs];
}

class CostsBloc extends Bloc<CostsEvent, CostsState> {
  CostsBloc({@required this.database});
  final Database database;
  StreamSubscription _subscription;

  @override
  CostsState get initialState => CostsLoading();

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
    final User user = await database.getMyUserInfo();
    _subscription = _totalCostsStream(user.partnerId)
        .listen((costs) => add(CostsUpdated(costs)));
  }

  Stream<CostsSummaryTileModel> _totalCostsStream(String partnerId) =>
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

  CostsSummaryTileModel _createModels(List<List<Cost>> costsList) {
    final myCosts = costsList[0];
    final partnerCosts = costsList[1];
    final flattenCosts = costsList.expand((cost) => cost).toList();

    flattenCosts.sort(
        (current, next) => next.paymentDate.compareTo(current.paymentDate));

    final totalCostAmount = flattenCosts
        .map((cost) => cost.amount)
        .reduce((value, element) => value + element);

    double borrowAmount = 0;
    myCosts.forEach((myCost) {
      borrowAmount -= myCost.amount * (myCost.burdenRate?.partnerRate ?? BurdenRate.evenRate);
    });
    partnerCosts.forEach((partnerCost) {
      borrowAmount += partnerCost.amount * (partnerCost.burdenRate?.partnerRate ?? BurdenRate.evenRate);
    });

    return CostsSummaryTileModel(
      costs: flattenCosts,
      totalCostAmount: totalCostAmount,
      borrowAmount: borrowAmount.round(),
    );
  }
}
