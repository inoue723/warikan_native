import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Cost {
  Cost({
    @required this.id,
    @required this.amount,
    @required this.category,
    @required this.paymentDate,
  });
  final String id;
  final int amount;
  final String category;
  final DateTime paymentDate;

  factory Cost.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final int amount = data["amount"];
    final String category = data["category"];
    DateTime paymentDate;

    final originPaymentDate = data["paymentDate"];
    if (originPaymentDate is Timestamp) {
      paymentDate = originPaymentDate.toDate();
    }

    return Cost(
      id: documentId,
      amount: amount,
      category: category,
      paymentDate: paymentDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "amount": amount,
      "category": category,
      "paymentDate": paymentDate,
    };
  }
}
