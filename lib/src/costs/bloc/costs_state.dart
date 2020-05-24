import 'package:equatable/equatable.dart';

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
