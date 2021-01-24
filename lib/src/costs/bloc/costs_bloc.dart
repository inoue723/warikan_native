import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:warikan_native/src/costs/bloc/costs_event.dart';
import 'package:warikan_native/src/costs/bloc/costs_state.dart';
import 'package:warikan_native/src/models/cost.dart';
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
      yield CostsLoaded(event.costs, event.partnerId);
    }
  }

  Stream<CostsState> _mapLoadCostsToState() async* {
    _subscription?.cancel();
    _subscription = _totalCostsStream(partnerId)
        .listen((costs) => add(CostsUpdated(costs, partnerId)));
  }

  Stream<List<Cost>> _totalCostsStream(String partnerId) =>
      CombineLatestStream([
        database.myCostsStream(),
        database.costsStream(partnerId),
      ], _costCombiner);

  List<Cost> _costCombiner(List<List<Cost>> values) {
    final myCosts = values[0];
    final partnerCosts = values[1];
    return [...myCosts, ...partnerCosts]..sort(
        (current, next) => next.paymentDate.compareTo(current.paymentDate),
      );
  }
}

class DateCosts {
  final String date;
  List<Cost> costs = [];

  DateCosts({this.date});
}
