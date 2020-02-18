import 'package:rxdart/rxdart.dart';
import 'package:flutter/foundation.dart';
import 'package:warikan_native/src/home/models.dart';
import 'package:warikan_native/src/services/api_path.dart';
import 'package:warikan_native/src/services/firestore_service.dart';

abstract class Database {
  Future<void> setCost(Cost cost);
  Future<void> deleteCost(Cost cost);
  // Stream<List<Cost>> myCostsStream();
  // Stream<List<Cost>> partnerCostsStream();
  Stream<List<Cost>> totalCostsStream();
  String documentIdFromCurrentDate();
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid, @required this.partnerUid}) : assert(uid != null);
  final String uid;
  final String partnerUid;
  final _service = FirestoreService.instance;

  @override
  String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

  @override
  Future<void> setCost(Cost cost) async => _service.setData(
        path: APIPath.cost(uid, cost.id),
        data: cost.toMap(),
      );

  @override
  Future<void> deleteCost(Cost cost) async => _service.deleteData(
        path: APIPath.cost(uid, cost.id),
      );

  // @override
  Stream<List<Cost>> _myCostsStream() => _service.collectionStream(
        path: APIPath.costs(uid),
        builder: (data, documentId) => Cost.fromMap(data, documentId),
      );

  // @override
  Stream<List<Cost>> _partnerCostsStream() => _service.collectionStream(
        path: APIPath.costs(partnerUid),
        builder: (data, documentId) => Cost.fromMap(data, documentId),
      );
  
  @override
  Stream<List<Cost>> totalCostsStream() {
    Stream<List<Cost>> myCostsStream = _myCostsStream();
    Stream<List<Cost>> partnerCostsStream = _partnerCostsStream();

    return CombineLatestStream([myCostsStream, partnerCostsStream], _costCombiner);
  }


  List<Cost> _costCombiner(List<List<Cost>> values) {
    values[0].addAll(values[1]);
    return values[0];
  }
}
