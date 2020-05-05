import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:warikan_native/src/costs/models/burden_rate.dart';

class Cost {
  Cost({
    @required this.id,
    @required this.amount,
    @required this.category,
    @required this.paymentDate,
    @required this.burdenRate,
  });
  final String id;
  final int amount;
  final String category;
  final DateTime paymentDate;
  final BurdenRate burdenRate;

  factory Cost.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final int amount = data["amount"];
    final String category = data["category"];
    DateTime paymentDate;
    final double burdenRate = data["burdenRate"];

    final originPaymentDate = data["paymentDate"];
    if (originPaymentDate is Timestamp) {
      paymentDate = originPaymentDate.toDate();
    }

    return Cost(
      id: documentId,
      amount: amount,
      category: category,
      paymentDate: paymentDate,
      burdenRate: burdenRate != null ? BurdenRate(burdenRate) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "amount": amount,
      "category": category,
      "paymentDate": paymentDate,
      "burdenRate": burdenRate.rate,
    };
  }

  @override
  String toString() {
    return "id: $id, amount: $amount, category: $category, paymentDate: $paymentDate";
  }
}
