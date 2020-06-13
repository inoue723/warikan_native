import 'package:flutter/foundation.dart';
import 'package:warikan_native/src/models/cost.dart';

class CostsSummary {
  CostsSummary({
    @required this.totalCostAmount,
    @required this.borrowAmount,
    @required this.costs,
  });
  final int totalCostAmount;
  final int borrowAmount;
  final List<Cost> costs;
}
