import 'package:equatable/equatable.dart';
import 'package:warikan_native/src/models/cost_summary.dart';

abstract class CostsEvent extends Equatable {
  const CostsEvent();

  @override
  List<Object> get props => [];
}

class LoadCosts extends CostsEvent {}

class CostsUpdated extends CostsEvent {
  final CostsSummary costs;

  CostsUpdated(this.costs);

  @override
  List<Object> get props => [costs];
}
