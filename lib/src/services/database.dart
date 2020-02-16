import 'package:flutter/foundation.dart';
import 'package:warikan_native/src/home/models.dart';
import 'package:warikan_native/src/services/api_path.dart';
import 'package:warikan_native/src/services/firestore_service.dart';

abstract class Database {
  Future<void> setCost(Cost cost);
  Stream<List<Cost>> costStream();
  String documentIdFromCurrentDate();
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;
  final _service = FirestoreService.instance;

  String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

  Future<void> setCost(Cost cost) async => _service.setData(
        path: APIPath.cost(uid, cost.id),
        data: cost.toMap(),
      );

  Stream<List<Cost>> costStream() => _service.collectionStream(
        path: APIPath.costs(uid),
        builder: (data, documentId) => Cost.fromMap(data, documentId),
      );

}
