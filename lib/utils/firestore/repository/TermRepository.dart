import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scheduleapp/utils/firestore/models/term.dart';

class TermRepository{
  final CollectionReference collection = Firestore.instance.collection('terms');
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
  Future<DocumentReference> addPet(Term term) {
    return collection.add(term.toJson());
  }
  // 4
  updatePet(Term term) async {
    collection.document(term.reference.documentID).updateData(term.toJson());
  }
}