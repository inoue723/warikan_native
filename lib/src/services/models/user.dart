import 'package:flutter/foundation.dart';

class User {
  final String uid;
  final String partnerId;

  User({
    @required this.uid,
    @required this.partnerId,
  });

  factory User.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }

    final String partnerId = data["partnerId"];

    return User(
      uid: documentId,
      partnerId: partnerId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "partnerId": partnerId,
    };
  }
}