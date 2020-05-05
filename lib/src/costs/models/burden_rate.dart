import 'package:flutter/foundation.dart';

class BurdenRate {
  BurdenRate(@required this.rate) : assert(rate != null);
  const BurdenRate.even() : rate = 0.5;
  const BurdenRate.partner() : rate = 0;

  final double rate;
  double get partnerRate => 1 - rate;

  bool get isEven => rate == 0.5;
  bool get isPartner => rate == 0;
}

enum BurdenRateType {
  even,
  partner,
  custom,
}

extension BurdenRateTypeExtension on BurdenRateType {
  BurdenRate toBurdenRate({double rate}) {
    switch (this) {
      case BurdenRateType.even:
        return BurdenRate.even();
      case BurdenRateType.partner:
        return BurdenRate.partner();
      case BurdenRateType.custom:
        if (rate == null) {
          throw Exception("rate is required when type is custom");
        }
        return BurdenRate(rate);
      default:
        return null;
    }
  }
}