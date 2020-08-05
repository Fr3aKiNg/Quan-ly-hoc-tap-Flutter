import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scheduleapp/utils/firestore/models/note.dart';

class NoteRepository{
  final CollectionReference collection = Firestore.instance.collection('notes');
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
  Future<DocumentReference> addPet(Note value) {
    return collection.add(value.toJson());
  }
  // 4
  updatePet(Note value) async {
    collection.document(value.reference.documentID).updateData(value.toJson());
  }
}