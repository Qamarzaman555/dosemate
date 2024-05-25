import 'package:cloud_firestore/cloud_firestore.dart';

class FBClient {
  static final _instance = FBClient._singleton();

  factory FBClient() => _instance;

  FBClient._singleton();

  final _db = FirebaseFirestore.instance;

  Future<JsonObject> post<T>({
    required String endpoint,
    required JsonObject data,
  }) async {
    try {
      await _db.collection(endpoint).add(data);
      return {'status': 'Ok', 'message': 'Data uploaded'};
    } catch (e) {
      return {'status': 'Error', 'message': '$e'};
    }
  }

  Future<JsonObject> update<T>({
    required String endpoint,
    required JsonObject data,
  }) async {
    try {
      await _db.doc(endpoint).update(data);
      return {'status': 'Ok', 'message': 'Data updated'};
    } catch (e) {
      return {'status': 'Error', 'message': '$e'};
    }
  }

  Future<JsonObject> get<T>({required String endpoint}) async {
    try {
      final resp = await _db.collection(endpoint).get();
      List<JsonObject> data = [];
      for (final doc in resp.docs) {
        final obj = doc.data();
        obj['uuid'] = doc.id;
        data.add(obj);
      }
      return {'status': 'Ok', 'data': data};
    } catch (e) {
      return {'status': 'Error', 'message': '$e'};
    }
  }

  Future<JsonObject> delete<T>({required String endpoint}) async {
    try {
      await _db.doc(endpoint).delete();
      return {'status': 'Ok', 'message': 'Data deleted'};
    } catch (e) {
      return {'status': 'Error', 'message': '$e'};
    }
  }
  
}

typedef JsonObject = Map<String, dynamic>;
