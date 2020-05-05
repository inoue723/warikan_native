class BurdenRate {
  static const evenRate = 0.5;
  static const lendingRate = 0.0;

  BurdenRate(this.rate);
  const BurdenRate.even() : rate = evenRate;
  const BurdenRate.lending() : rate = lendingRate;

  final double rate;
  double get partnerRate => 1 - rate;

  bool get isEven => rate == evenRate;
  bool get isLending => rate == lendingRate;

  BurdenRateType toBurdenRateType() {
    if (rate == evenRate) {
      return BurdenRateType.even;
    } else if (rate == lendingRate) {
      return BurdenRateType.lending;
    } else {
      return BurdenRateType.custom;
    }
  }
}

enum BurdenRateType {
  even,
  lending,
  custom,
}

extension BurdenRateTypeExtension on BurdenRateType {
  BurdenRate toBurdenRate({double rate}) {
    switch (this) {
      case BurdenRateType.even:
        return BurdenRate.even();
      case BurdenRateType.lending:
        return BurdenRate.lending();
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
