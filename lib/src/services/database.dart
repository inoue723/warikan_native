import 'package:flutter/foundation.dart';
import 'package:warikan_native/src/models/cost.dart';
import 'package:warikan_native/src/models/user.dart';
import 'package:warikan_native/src/services/api_path.dart';
import 'package:warikan_native/src/services/firestore_service.dart';

abstract class Database {
  Future<void> setCost(Cost cost);
  Future<void> deleteCost(Cost cost);
  String documentIdFromCurrentDate();
  Stream<List<Cost>> myCostsStream();
  Stream<List<Cost>> costsStream(String partnerUid);
  Future<User> getMyUserInfo();
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;
  final _service = FirestoreService.instance;

  @override
  String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

  @override
  Future<void> setCost(Cost cost) async => _service.setData(
        path: APIPath.cost(cost.uid, cost.id),
        data: cost.toMap(),
      );

  @override
  Future<void> deleteCost(Cost cost) async => _service.deleteData(
        path: APIPath.cost(cost.uid, cost.id),
      );

  @override
  Stream<List<Cost>> myCostsStream() => _service.collectionStream(
        path: APIPath.costs(uid),
        builder: (data, documentId) => Cost.fromMap(data, documentId, uid),
      );

  @override
  Stream<List<Cost>> costsStream(String partnerUid) =>
      _service.collectionStream(
        path: APIPath.costs(partnerUid),
        builder: (data, documentId) =>
            Cost.fromMap(data, documentId, partnerUid),
      );

  @override
  Future<User> getMyUserInfo() async => _service.getData(
        path: APIPath.user(uid),
        builder: (data, documentId) => User.fromMap(data, documentId),
      );
}
