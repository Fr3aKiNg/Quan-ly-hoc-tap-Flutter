import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scheduleapp/utils/firestore/models/event.dart';

class EventRepository{
  final CollectionReference collection = Firestore.instance.collection('events');
  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }
  Future<QuerySnapshot> getAllDocument() {
    return collection.getDocuments() ;
  }
  removeDocument(String id) async {
    collection.document(id).delete();
  }
  Future<DocumentSnapshot> getDocumentById(String id) {
    return collection.document(id).get();
  }
  Future<DocumentReference> addPet(Event value) {
    return collection.add(value.toJson());
  }
  // 4
  updatePet(Event value) async {
    collection.document(value.reference.documentID).updateData(value.toJson());
  }
}