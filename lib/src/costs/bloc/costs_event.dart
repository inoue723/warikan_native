import 'package:equatable/equatable.dart';
import 'package:warikan_native/src/models/cost.dart';

abstract class CostsEvent extends Equatable {
  const CostsEvent();

  @override
  List<Object> get props => [];
}

class LoadCosts extends CostsEvent {}

class CostsUpdated extends CostsEvent {
  final List<Cost> costs;
  final String partnerId;

  CostsUpdated(this.costs, this.partnerId);

  @override
  List<Object> get props => [costs];
}
