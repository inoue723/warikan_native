import 'package:date_format/date_format.dart';
import 'package:equatable/equatable.dart';
import 'package:warikan_native/src/costs/bloc/index.dart';
import 'package:warikan_native/src/models/burden_rate.dart';
import 'package:warikan_native/src/models/cost.dart';

abstract class CostsState extends Equatable {
  const CostsState();

  @override
  List<Object> get props => [];
}

class CostsLoading extends CostsState {}

class CostsLoaded extends CostsState {
  final List<Cost> costs;
  final String partnerId;

  CostsLoaded(this.costs, this.partnerId);

  List<DateCosts> get dateList {
    List<DateCosts> dateList = [];
    this.costs.forEach((cost) {
      final formattedDate =
          formatDate(cost.paymentDate, [yyyy, "-", mm, "-", dd]);
      final dateCosts = dateList.firstWhere(
        (dateCosts) => dateCosts.date == formattedDate,
        orElse: () {
          final newDateCosts = DateCosts(date: formattedDate);
          dateList.add(newDateCosts);
          return newDateCosts;
        },
      );

      dateCosts.costs.add(cost);
    });

    return dateList;
  }

  int get totalCostAmount {
    return this.costs.isNotEmpty
        ? this
            .costs
            .map((cost) => cost.amount)
            .reduce((value, element) => value + element)
        : 0;
  }

  int get borrowAmount {
    final myCosts = this.costs.where((cost) => cost.uid != this.partnerId);
    final partnerCosts = this.costs.where((cost) => cost.uid == this.partnerId);

    double result = 0;
    myCosts.forEach((myCost) {
      result -= myCost.amount *
          (myCost.burdenRate?.partnerRate ?? BurdenRate.evenRate);
    });
    partnerCosts.forEach((partnerCost) {
      result += partnerCost.amount *
          (partnerCost.burdenRate?.partnerRate ?? BurdenRate.evenRate);
    });

    return result.round();
  }

  @override
  List<Object> get props => [costs];
}
