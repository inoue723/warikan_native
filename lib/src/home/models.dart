import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Cost {
  Cost({
    @required this.amount,
    @required this.category,
    @required this.paymentDate,
    @required this.createdAt,
  });
  final int amount;
  final String category;
  final DateTime paymentDate;
  final DateTime createdAt;

  factory Cost.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final int amount = data["amount"];
    final String category = data["category"];
    DateTime createdAt;
    DateTime paymentDate;

    final originCreatedAt = data["createdAt"];
    if (originCreatedAt is Timestamp) {
      createdAt = originCreatedAt.toDate();
    }

    final originPaymentDate = data["paymentDate"];
    if (originPaymentDate is Timestamp) {
      paymentDate = originCreatedAt.toDate();
    }

    return Cost(
      amount: amount,
      category: category,
      paymentDate: paymentDate,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "amount": amount,
      "category": category,
      "createdAt": createdAt,
      "paymentDate": paymentDate,
    };
  }
}
